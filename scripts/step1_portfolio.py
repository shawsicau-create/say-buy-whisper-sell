"""
Step 1: Portfolio Test
Analyst Recommendations vs Institutional Trading Direction Divergence

This tests whether stocks with positive research ratings but declining 
institutional holdings (Group B: say-buy/whisper-sell) underperform.
"""
from utils import *
from config import *
import pandas as pd
import numpy as np
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))


def run_step1():
    """
    Main function for Step 1 portfolio test.

    Tests:
    - Group B (HighRating_InstDecrease) should underperform
    - Group A (HighRating_InstIncrease) should be the best
    - BHAR and DGTW-adjusted returns
    """
    print_section("Step 1: Portfolio Test - Say-Buy/Whisper-Sell")

    # Load analysis panel (priority: full > enhanced > basic)
    panel_file = DATA_PROCESSED / "analysis_panel_full.csv"
    if not panel_file.exists():
        panel_file = DATA_PROCESSED / "analysis_panel_enhanced.csv"
    if not panel_file.exists():
        panel_file = DATA_PROCESSED / "analysis_panel.csv"
    if not panel_file.exists():
        print("Analysis panel not found. Run build_panel.py first.")
        return None

    panel = pd.read_csv(panel_file)
    print(
        f"Loaded panel: {len(panel)} rows, {panel['ts_code'].nunique()} stocks")

    # Assign groups
    # Sort by research rating and institutional holdings
    if "has_buy_rating" in panel.columns and "inst_decrease" in panel.columns:
        panel["group"] = panel.apply(
            lambda r: assign_group(r["has_buy_rating"], r["inst_decrease"]), axis=1
        )
    else:
        print("Required columns missing. Creating from available data...")
        # Create groups from rating score and holder change
        if "rating_score" in panel.columns:
            panel["has_buy_rating"] = (panel["rating_score"] > 0).astype(int)
        if "inst_holder_chg" in panel.columns:
            panel["inst_decrease"] = (panel["inst_holder_chg"] < 0).astype(int)

        if "has_buy_rating" in panel.columns and "inst_decrease" in panel.columns:
            panel["group"] = panel.apply(
                lambda r: assign_group(r["has_buy_rating"], r["inst_decrease"]), axis=1
            )
        else:
            print("Cannot assign groups. Missing rating or holder data.")
            return None

    # Calculate portfolio returns
    results = calculate_portfolio_returns(panel)

    # Print results
    print("\n=== Portfolio Returns by Group ===")
    for g, ret in results.items():
        if g.startswith("spread"):
            print(f"  {ret.get('description', g)}: Mean = {ret.get('mean', 0):.4f}")
        else:
            t = ret.get('tstat', float('nan'))
            t_str = f"{t:.2f}" if not np.isnan(t) else "nan"
            n = ret.get('n', 0)
            print(
                f"  Group {g}: Mean = {ret['mean']:.4f}, t-stat = {t_str}, N = {n}")

    # Save results
    save_results(results, "step1_portfolio_results.csv")

    return results


def assign_group(has_buy, inst_decrease):
    """Assign stock to one of 4 groups based on rating and holder change."""
    if has_buy == 1 and inst_decrease == 0:
        return "A"  # HighRating_InstIncrease (positive alignment)
    elif has_buy == 1 and inst_decrease == 1:
        return "B"  # HighRating_InstDecrease (say-buy/whisper-sell)
    elif has_buy == 0 and inst_decrease == 0:
        return "C"  # LowRating_InstIncrease (benchmark)
    else:
        return "D"  # LowRating_InstDecrease (benchmark)


def calculate_portfolio_returns(panel):
    """
    Calculate returns for each group.

    Returns:
        dict: {group: {"mean": float, "tstat": float, "n": int}}
    """
    results = {}

    for group in ["A", "B", "C", "D"]:
        g_data = panel[panel["group"] == group]
        if len(g_data) == 0:
            results[group] = {"mean": np.nan, "tstat": np.nan, "n": 0}
            continue

        # Forward returns
        ret_col = "ret_q"  # quarterly return as forward return
        if ret_col not in g_data.columns:
            results[group] = {"mean": np.nan, "tstat": np.nan, "n": 0}
            continue

        rets = g_data[ret_col].dropna()
        if len(rets) == 0:
            results[group] = {"mean": np.nan, "tstat": np.nan, "n": 0}
            continue

        mean_ret = rets.mean()
        std_ret = rets.std()
        tstat = mean_ret / (std_ret / np.sqrt(len(rets))
                            ) if std_ret > 0 else np.nan

        results[group] = {
            "mean": mean_ret,
            "std": std_ret,
            "tstat": tstat,
            "n": len(rets),
            "median": rets.median(),
        }

    # Calculate Group B - Group D spread (the main test)
    if results.get("B", {}).get("n", 0) > 0 and results.get("D", {}).get("n", 0) > 0:
        b_ret = results["B"]["mean"]
        d_ret = results["D"]["mean"]
        results["spread_BD"] = {
            "mean": b_ret - d_ret,
            "description": "Group B - Group D (say-buy/whisper-sell spread)"
        }

    return results


def save_results(results, filename):
    """Save results to CSV."""
    rows = []
    for k, v in results.items():
        row = {"group": k}
        row.update(v)
        rows.append(row)

    df = pd.DataFrame(rows)
    out_path = RESULTS_DIR / filename
    df.to_csv(out_path, index=False, encoding="utf-8-sig")
    print(f"\nResults saved to {out_path}")


def create_summary_table(results):
    """Create summary table for the paper."""
    data = []
    for g in ["A", "B", "C", "D"]:
        r = results.get(g, {})
        data.append({
            "Group": GROUP_LABELS.get(g, g),
            "Mean Return": f"{r.get('mean', 0):.4f}",
            "t-stat": f"{r.get('tstat', 0):.2f}",
            "N": r.get("n", 0),
        })

    df = pd.DataFrame(data)
    print("\n" + "="*80)
    print("Table 1: Portfolio Returns by Analyst Rating and Institutional Holdings")
    print("="*80)
    print(df.to_string(index=False))
    return df


if __name__ == "__main__":
    results = run_step1()
    if results:
        create_summary_table(results)
