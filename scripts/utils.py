"""
Utility Functions for Say-Buy/Whisper-Sell Analysis
"""
import json
import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime, timedelta
import warnings
warnings.filterwarnings("ignore")


def save_mcp_output(data, filename, subdir="raw"):
    """Save MCP tool output to CSV file."""
    from config import DATA_RAW, DATA_PROCESSED
    base = DATA_RAW if subdir == "raw" else DATA_PROCESSED
    filepath = base / filename
    if isinstance(data, list) and len(data) > 0:
        df = pd.DataFrame(data)
        df.to_csv(filepath, index=False, encoding="utf-8-sig")
        print(f"Saved {len(df)} rows to {filepath}")
        return str(filepath)
    else:
        print(f"Warning: No data to save for {filename}")
        return None


def load_csv(filename, subdir="raw"):
    """Load CSV file from raw or processed directory."""
    from config import DATA_RAW, DATA_PROCESSED
    base = DATA_RAW if subdir == "raw" else DATA_PROCESSED
    filepath = base / filename
    if filepath.exists():
        return pd.read_csv(filepath, encoding="utf-8-sig")
    return None


def parse_mcp_json_output(output_text):
    """Parse MCP JSON output that might be a large single-line JSON string."""
    if isinstance(output_text, list):
        return output_text
    if isinstance(output_text, str):
        try:
            data = json.loads(output_text)
            if isinstance(data, list):
                return data
            elif isinstance(data, dict):
                # Check for common MCP response patterns
                if "data" in data:
                    d = data["data"]
                    if isinstance(d, list):
                        return d
                if "answer" in data:
                    return data  # Return full dict for text parsing
                return [data]
        except json.JSONDecodeError:
            pass
    return []


def classify_rating(rating_text):
    """
    Classify analyst rating into positive/neutral/negative.

    Args:
        rating_text: str, rating text like "买入" / "增持" / "中性"

    Returns:
        int: 1 (positive), 0 (neutral), -1 (negative)
    """
    if not isinstance(rating_text, str):
        return 0
    from config import POSITIVE_RATING_KEYWORDS, NEGATIVE_RATING_KEYWORDS
    text = rating_text.strip()
    for kw in POSITIVE_RATING_KEYWORDS:
        if kw in text:
            return 1
    for kw in NEGATIVE_RATING_KEYWORDS:
        if kw in text:
            return -1
    return 0


def calculate_bhar(ret, period=21):
    """
    Calculate buy-and-hold abnormal return.

    Args:
        ret: pd.Series of daily returns (decimal, e.g. 0.01)
        period: int, holding period in days

    Returns:
        float: BHAR
    """
    if len(ret) < period:
        return np.nan
    cum_ret = (1 + ret.iloc[:period]).prod() - 1
    return cum_ret


def calculate_dgtw_alpha(stock_ret, benchmark_ret, size_q, bm_q, mom_q):
    """
    Calculate DGTW-characteristic-adjusted abnormal return.
    Simplified version using size/BM/momentum quintile matching.

    Args:
        stock_ret: float, stock return
        benchmark_ret: float, matched portfolio return

    Returns:
        float: DGTW alpha
    """
    return stock_ret - benchmark_ret


def winsorize(x, lower=1, upper=99):
    """Winsorize series at given percentiles."""
    lo = np.nanpercentile(x, lower)
    hi = np.nanpercentile(x, upper)
    return x.clip(lo, hi)


def quarter_end_dates(start="2010-01-01", end="2026-06-30"):
    """Generate quarter-end dates."""
    dates = pd.date_range(start=start, end=end, freq="QE")
    return [d.strftime("%Y%m%d") for d in dates]


def month_end_dates(start="2010-01-01", end="2026-06-30"):
    """Generate month-end dates."""
    dates = pd.date_range(start=start, end=end, freq="ME")
    return [d.strftime("%Y%m%d") for d in dates]


def add_calendar_days(date_str, days):
    """Add calendar days to a date string YYYYMMDD."""
    d = datetime.strptime(str(date_str), "%Y%m%d")
    return (d + timedelta(days=days)).strftime("%Y%m%d")


def standard_errors_neweywest(residuals, lags=4):
    """
    Newey-West standard errors for OLS residuals.

    Args:
        residuals: np.array of residuals
        lags: int, number of lags

    Returns:
        float: standard error
    """
    n = len(residuals)
    gamma = np.sum(residuals ** 2) / n
    for j in range(1, lags + 1):
        gamma += 2 * (1 - j / (lags + 1)) * \
            np.sum(residuals[j:] * residuals[:-j]) / n
    return np.sqrt(gamma / n * n / (n - 1))


def format_table1(df, title="", note=""):
    """
    Format a pandas DataFrame as a LaTeX table.
    Returns the LaTeX string.
    """
    latex = []
    latex.append("\\begin{table}[htbp]")
    latex.append("\\centering")
    latex.append(f"\\caption{{{title}}}")
    latex.append(df.to_latex(index=True, escape=False, label=title[:20]))
    latex.append(f"\\note{{{note}}}")
    latex.append("\\end{table}")
    return "\n".join(latex)


def print_section(title):
    """Print a section header."""
    print(f"\n{'='*60}")
    print(f"  {title}")
    print('='*60)
