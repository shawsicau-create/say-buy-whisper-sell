"""
Project Configuration
Say-Buy/Whisper-Sell: 中国A股实证策略
"""
import os
from pathlib import Path

# === Paths ===
PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_RAW = PROJECT_ROOT / "data" / "raw"
DATA_PROCESSED = PROJECT_ROOT / "data" / "processed"
ANALYSIS_DIR = PROJECT_ROOT / "analysis"
RESULTS_DIR = PROJECT_ROOT / "results"

for d in [DATA_RAW, DATA_PROCESSED, ANALYSIS_DIR, RESULTS_DIR]:
    d.mkdir(parents=True, exist_ok=True)

# === Date Range ===
SAMPLE_START = "20100101"
SAMPLE_END = "20260630"

# === Trading Parameters ===
HOLDING_PERIODS = {
    "1M": 21,
    "3M": 63,
    "6M": 126,
}

EVENT_WINDOW_BEFORE = 20
EVENT_WINDOW_AFTER = 20

# === Rating Keywords ===
POSITIVE_RATING_KEYWORDS = ["买入", "增持", "强烈买入", "推荐", "优于大市", "强推"]
NEGATIVE_RATING_KEYWORDS = ["卖出", "减持", "回避", "中性"]

# === Market Indices ===
SH_INDEX_CODE = "000001.SH"
SZ_INDEX_CODE = "399001.SZ"
CSI300_CODE = "000300.SH"

# === Group Labels ===
GROUP_LABELS = {
    "A": "HighRating_InstIncrease",
    "B": "HighRating_InstDecrease (say-buy/whisper-sell)",
    "C": "LowRating_InstIncrease",
    "D": "LowRating_InstDecrease",
}

ALPHA = 0.05
