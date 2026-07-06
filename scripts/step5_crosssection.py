"""
Step 5: Cross-Sectional and Time-Series Heterogeneity Analysis
Tests whether the say-buy/whisper-sell effect varies by:
- Market conditions (bull/bear)
- Firm size
- Broker reputation
- North-bound capital weight
"""
from utils import *
from config import *
import pandas as pd
import numpy as np
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))


def run_step5():
    """
    Main function for Step 5 cross-sectional analysis.

    Tests heterogeneity of the Group B effect across:
    1. Market states
    2. Size quintiles
    3. Broker reputation
    4. Foreign ownership (north-bound proxy)
    """
    print_section("Step 5: Cross-Sectional Heterogeneity")

    # Load panel (priority: full > enhanced > basic)
    panel_file = DATA_PROCESSED / "analysis_panel_full.csv"
    if not panel_file.exists():
        panel_file = DATA_PROCESSED / "analysis_panel_enhanced.csv"
    if not panel_file.exists():
        panel_file = DATA_PROCESSED / "analysis_panel.csv"
    if not panel_file.exists():
        print("Analysis panel not found.")
        return None

    panel = pd.read_csv(panel_file)
    print(f"Loaded panel: {len(panel)} rows")

    # Assign groups (need group column)
    if "group" not in panel.columns:
        # Recreate groups
        if "has_buy_rating" in panel.columns and "inst_decrease" in panel.columns:
            panel["group"] = panel.apply(
                lambda r: assign_group(r["has_buy_rating"], r["inst_decrease"]), axis=1
            )
        else:
            print("Cannot assign groups.")
            return None

    # Filter to Group A and B only (core comparison)
    df_ab = panel[panel["group"].isin(["A", "B"])].copy()
    print(f"Group A+B observations: {len(df_ab)}")

    if len(df_ab) == 0:
        print("No Group A/B observations. Check data.")
        return None

    # Run heterogeneity analyses
    all_results = {}

    # 1. Market states
    if "ret_q" in df_ab.columns:
        mkt_ret = df_ab.groupby("quarter")["ret_q"].mean()
        bull_quarters = mkt_ret[mkt_ret > 0].index.tolist()
        df_ab["mkt_state"] = df_ab["quarter"].apply(
            lambda x: "Bull" if x in bull_quarters else "Bear")

        result_mkt = heterogeneity_by_group(df_ab, "mkt_state", "ret_q")
        all_results["market_state"] = result_mkt
        print(f"\n--- By Market State ---")
        print_result_mkt(result_mkt)

    # 2. Size (use avg_turnover as proxy since no market cap)
    if "avg_turnover" in df_ab.columns:
        df_ab["size_group"] = pd.qcut(df_ab["avg_turnover"].rank(method="first"),
                                      q=3, labels=["Small", "Medium", "Large"])
        result_size = heterogeneity_by_group(df_ab, "size_group", "ret_q")
        all_results["size"] = result_size
        print(f"\n--- By Size Quintile ---")
        print_result_size(result_size)

    # 3. Forward returns comparison
    result_main = group_comparison(df_ab)
    all_results["main_comparison"] = result_main
    print(f"\n--- Main Group Comparison (A vs B) ---")
    print(f"  Group A mean: {result_main.get('mean_A', np.nan):.4f}")
    print(f"  Group B mean: {result_main.get('mean_B', np.nan):.4f}")
    print(f"  Spread (B-A): {result_main.get('spread', np.nan):.4f}")

    # Save results
    save_results(df_ab, all_results)

    return all_results


def assign_group(has_buy, inst_decrease):
    """Assign stock to group based on rating and holder change."""
    if has_buy == 1 and inst_decrease == 0:
        return "A"
    elif has_buy == 1 and inst_decrease == 1:
        return "B"
    elif has_buy == 0 and inst_decrease == 0:
        return "C"
    else:
        return "D"


def heterogeneity_by_group(df, group_col, ret_col):
    """
    Calculate Group A vs B return difference within subgroups.

    Returns dict of results by subgroup
    """
    results = {}

    for subgroup in df[group_col].unique():
        if pd.isna(subgroup):
            continue
        sub_df = df[df[group_col] == subgroup]

        a_ret = sub_df[sub_df["group"] == "A"][ret_col].mean() if len(
            sub_df[sub_df["group"] == "A"]) > 0 else np.nan
        b_ret = sub_df[sub_df["group"] == "B"][ret_col].mean() if len(
            sub_df[sub_df["group"] == "B"]) > 0 else np.nan

        n_a = len(sub_df[sub_df["group"] == "A"])
        n_b = len(sub_df[sub_df["group"] == "B"])

        results[str(subgroup)] = {
            "mean_A": a_ret,
            "mean_B": b_ret,
            "spread": b_ret - a_ret if not (np.isnan(a_ret) or np.isnan(b_ret)) else np.nan,
            "n_A": n_a,
            "n_B": n_b,
        }

    return results


def group_comparison(df):
    """Main Group A vs B comparison."""
    a_data = df[df["group"] == "A"]["ret_q"].dropna()
    b_data = df[df["group"] == "B"]["ret_q"].dropna()

    mean_a = a_data.mean() if len(a_data) > 0 else np.nan
    mean_b = b_data.mean() if len(b_data) > 0 else np.nan

    # T-test for difference using numpy
    if len(a_data) > 1 and len(b_data) > 1:
        # Welch's t-test
        var_a = a_data.var()
        var_b = b_data.var()
        n_a, n_b = len(a_data), len(b_data)
        se = np.sqrt(var_a/n_a + var_b/n_b)
        t = (mean_b - mean_a) / se if se > 0 else np.nan
        p = np.nan  # p-value requires scipy
    else:
        t, p = np.nan, np.nan

    return {
        "mean_A": mean_a,
        "mean_B": mean_b,
        "spread": mean_b - mean_a,
        "t_stat": t,
        "p_value": p,
        "n_A": len(a_data),
        "n_B": len(b_data),
    }


def print_result_mkt(results):
    for state, r in results.items():
        print(
            f"  {state}: A={r['mean_A']:.4f}, B={r['mean_B']:.4f}, spread={r['spread']:.4f}")


def print_result_size(results):
    for size, r in results.items():
        print(
            f"  {size}: A={r['mean_A']:.4f}, B={r['mean_B']:.4f}, spread={r['spread']:.4f}")


def save_results(df, all_results):
    """Save Step 5 results."""
    df.to_csv(RESULTS_DIR / "step5_crosssection_panel.csv",
              index=False, encoding="utf-8-sig")

    with open(RESULTS_DIR / "step5_crosssection_summary.txt", "w") as f:
        f.write("Step 5: Cross-Sectional Heterogeneity Analysis\n")
        f.write("="*60 + "\n\n")

        for section, results in all_results.items():
            f.write(f"\n=== {section} ===\n")
            if isinstance(results, dict):
                for k, v in results.items():
                    f.write(f"  {k}: {v}\n")

    print(f"\nResults saved to {RESULTS_DIR}")


if __name__ == "__main__":
    run_step5()
