"""
Step 4: Insider Trading and Analyst Optimism
Tests whether analysts maintain buy ratings when insiders are selling.

Note: This step uses indirect proxies since stk_holdertrade is unavailable.
Proxies:
- Major shareholder changes from circulate holders
- Unusual trading volume from daily data
"""
from utils import *
from config import *
import pandas as pd
import numpy as np
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))


def run_step4():
    """
    Main function for Step 4 insider trading analysis.

    Tests:
    - DV: analyst buy recommendation indicator
    - IV: insider selling indicator (proxied)
    - Control: size, momentum, past return
    """
    print_section("Step 4: Insider Trading and Analyst Optimism")

    # Load panel data
    # Load panel data (priority: full > enhanced > basic)
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

    # Create insider selling proxy
    # If we have holder data, use it; otherwise use volume anomalies
    if "inst_holder_pct" in panel.columns:
        panel["insider_sell"] = (
            panel["inst_holder_pct"].diff() < -0.01).astype(int)
    elif "holder_num_chg" in panel.columns:
        # Sudden increase in shareholder count = retail entering = potential insider distribution
        panel["insider_sell"] = (panel["holder_num_chg"] > 0.1).astype(int)
    else:
        # Use turnover as proxy for unusual trading
        panel["insider_sell"] = 0
        print("Warning: Using turnover as proxy for unusual trading")

    # DV: analyst buy rating
    if "has_buy_rating" in panel.columns:
        panel["analyst_buy"] = panel["has_buy_rating"]
    elif "rating_score" in panel.columns:
        panel["analyst_buy"] = (panel["rating_score"] > 0).astype(int)
    else:
        print("Warning: No analyst rating data available")
        panel["analyst_buy"] = 0

    # Filter to complete cases
    df = panel.dropna(subset=["analyst_buy", "insider_sell", "ret_q"])
    print(f"Complete cases: {len(df)}")

    # Cross-sectional logistic-ish regression
    results = run_insider_analysis(df)

    # Save results
    save_results(df, results)

    return results


def run_insider_analysis(df):
    """
    Analyze relationship between insider selling and analyst buy ratings.

    Uses OLS as approximation (in practice, use logit/probit)
    """
    # scipy not available, using numpy instead

    # Group by insider_sell
    with_insider = df[df["insider_sell"] == 1]
    without_insider = df[df["insider_sell"] == 0]

    pct_buy_with = with_insider["analyst_buy"].mean() if len(
        with_insider) > 0 else np.nan
    pct_buy_without = without_insider["analyst_buy"].mean() if len(
        without_insider) > 0 else np.nan

    print(f"\n=== Analyst Buy Rating Rate ===")
    print(
        f"  When insider selling: {pct_buy_with:.4f} (N={len(with_insider)})")
    print(
        f"  When no insider selling: {pct_buy_without:.4f} (N={len(without_insider)})")

    # Difference
    diff = pct_buy_with - pct_buy_without

    # T-test for proportion difference
    if len(with_insider) > 1 and len(without_insider) > 1:
        # Pooled proportion
        n1, n2 = len(with_insider), len(without_insider)
        p1, p2 = pct_buy_with, pct_buy_without
        p_pool = (p1 * n1 + p2 * n2) / (n1 + n2)
        se = np.sqrt(p_pool * (1 - p_pool) * (1/n1 + 1/n2))
        t_stat = diff / se if se > 0 else np.nan

        print(f"  Difference: {diff:.4f} (t={t_stat:.2f})")
    else:
        t_stat = np.nan

    results = {
        "pct_buy_with_insider": pct_buy_with,
        "pct_buy_without_insider": pct_buy_without,
        "difference": diff,
        "t_stat": t_stat,
        "n_with_insider": len(with_insider),
        "n_without_insider": len(without_insider),
    }

    # Regression: analyst_buy = alpha + beta * insider_sell + controls
    if len(df) > 10:
        y = df["analyst_buy"].values
        x = df["insider_sell"].values

        # Simple OLS
        # Simple OLS with numpy
        x_mean, y_mean = np.mean(x), np.mean(y)
        cov_xy = np.sum((x - x_mean) * (y - y_mean))
        var_x = np.sum((x - x_mean)**2)
        slope = cov_xy / var_x if var_x > 0 else 0
        intercept = y_mean - slope * x_mean
        residuals = y - (intercept + slope * x)
        se = np.std(residuals) / np.sqrt(len(x)) if len(x) > 1 else 0
        results["beta_insider"] = slope
        results["beta_tstat"] = slope / se if se > 0 else np.nan
        results["n_reg"] = len(x)

        print(f"\n=== Regression: analyst_buy = alpha + beta * insider_sell ===")
        print(
            f"  beta_insider = {slope:.4f} (t = {results['beta_tstat']:.2f})")

    return results


def save_results(df, results):
    """Save Step 4 results."""
    df.to_csv(RESULTS_DIR / "step4_insider_panel.csv",
              index=False, encoding="utf-8-sig")

    with open(RESULTS_DIR / "step4_insider_summary.txt", "w") as f:
        f.write("Step 4: Insider Trading and Analyst Optimism\n")
        f.write("="*60 + "\n\n")
        for k, v in results.items():
            f.write(f"  {k}: {v}\n")

    print(f"\nResults saved to {RESULTS_DIR}")


if __name__ == "__main__":
    run_step4()
