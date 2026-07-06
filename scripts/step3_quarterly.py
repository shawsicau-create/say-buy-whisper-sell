"""
Step 3: Quarterly Holdings Consistency Analysis
Tests whether institutional holding changes correlate with research rating changes.

This is a robustness check using quarterly data (like Hirshleifer 2024's approach).
"""
from utils import *
from config import *
import pandas as pd
import numpy as np
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))


def run_step3():
    """
    Main function for Step 3 quarterly consistency analysis.

    Tests:
    - Correlation between research consensus and institutional holdings
    - Cross-sectional regression
    """
    print_section("Step 3: Quarterly Holdings Consistency")

    # Load analysis panel
    # Load analysis panel (priority: full > enhanced > basic)
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

    # Calculate quarterly changes
    panel = panel.sort_values(["ts_code", "quarter"])

    # Add quarter-over-quarter changes
    for col in ["rating_score", "inst_holder_pct", "holder_num"]:
        if col in panel.columns:
            panel[f"{col}_chg"] = panel.groupby("ts_code")[col].diff()

    # Filter complete cases
    if "rating_score_chg" in panel.columns and "inst_holder_pct_chg" in panel.columns:
        df = panel.dropna(subset=["rating_score_chg",
                          "inst_holder_pct_chg", "ret_q"])
    else:
        print("Missing required columns for quarterly analysis.")
        return None

    print(f"Complete cases: {len(df)}")

    # Correlation analysis
    corr = df["rating_score_chg"].corr(df["inst_holder_pct_chg"])
    print(f"\nCorrelation (rating change, holder change): {corr:.4f}")

    # Cross-sectional regression
    reg_results = run_regression(df)

    # Save results
    save_results(df, corr, reg_results)

    return {"correlation": corr, "regression": reg_results}


def run_regression(df):
    """
    Run cross-sectional regression:
    inst_holder_chg = alpha + beta * rating_score_chg + controls

    Returns regression results dict
    """
    from scipy import stats

    y = df["inst_holder_pct_chg"].values
    x = df["rating_score_chg"].values
    controls = df[["ret_q", "avg_turnover"]].fillna(
        0).values if "ret_q" in df.columns else None

    if controls is not None and controls.shape[1] >= 1:
        # Multiple regression
        X = np.column_stack([np.ones(len(x)), x, controls])
        try:
            beta, residuals, rank, s = np.linalg.lstsq(X, y, rcond=None)
            n = len(y)
            k = X.shape[1]
            mse = np.sum(residuals**2) / (n - k)
            var_beta = mse * np.linalg.inv(X.T @ X)
            se = np.sqrt(np.diag(var_beta))
            tstats = beta / se

            results = {
                "alpha": beta[0],
                "alpha_se": se[0],
                "alpha_t": tstats[0],
                "beta_rating": beta[1],
                "beta_rating_se": se[1],
                "beta_rating_t": tstats[1],
                "n": n,
                "r_squared": 1 - residuals.sum() / np.sum((y - y.mean())**2),
            }
        except:
            results = None
    else:
        # Simple regression
        slope, intercept, r, p, se = stats.linregress(x, y)
        results = {
            "alpha": intercept,
            "alpha_t": intercept / se * np.sqrt(len(x)) / np.sqrt(np.sum(x**2)) if se > 0 else np.nan,
            "beta_rating": slope,
            "beta_rating_t": slope / se if se > 0 else np.nan,
            "n": len(x),
            "r_squared": r**2,
        }

    if results:
        print(f"\n=== Regression Results ===")
        print(
            f"  alpha = {results['alpha']:.6f} (t = {results['alpha_t']:.2f})")
        print(
            f"  beta_rating = {results['beta_rating']:.6f} (t = {results['beta_rating_t']:.2f})")
        print(f"  N = {results['n']}, R^2 = {results['r_squared']:.4f}")

    return results


def save_results(df, corr, reg_results):
    """Save Step 3 results."""
    df.to_csv(RESULTS_DIR / "step3_quarterly_panel.csv",
              index=False, encoding="utf-8-sig")

    summary = {
        "correlation": corr,
        "regression": reg_results,
    }

    with open(RESULTS_DIR / "step3_quarterly_summary.txt", "w") as f:
        f.write("Step 3: Quarterly Holdings Consistency Analysis\n")
        f.write("="*60 + "\n\n")
        f.write(f"Correlation (rating change, holder change): {corr:.4f}\n\n")
        if reg_results:
            f.write(
                "Regression: inst_holder_chg = alpha + beta * rating_chg + controls\n")
            for k, v in reg_results.items():
                f.write(f"  {k}: {v}\n")

    print(f"\nResults saved to {RESULTS_DIR}")


if __name__ == "__main__":
    run_step3()
