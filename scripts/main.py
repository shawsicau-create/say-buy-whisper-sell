"""
Main Runner Script for Say-Buy/Whisper-Sell Analysis
Executes all 5 empirical steps in sequence.
"""
import step5_crosssection
import step4_insider
import step3_quarterly
import step2_event
import step1_portfolio
from utils import print_section
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))


def run_all_steps():
    """Run all 5 empirical steps."""
    print("\n" + "="*70)
    print("  Say-Buy/Whisper-Sell: 中国A股分析师言行不一实证研究")
    print("  Full Pipeline Execution")
    print("="*70)

    results = {}

    # Step 1: Portfolio Test
    print("\n>>> Running Step 1: Portfolio Test")
    r1 = step1_portfolio.run_step1()
    results["step1"] = r1

    # Step 2: Event Study
    print("\n>>> Running Step 2: Event Study")
    r2 = step2_event.run_step2()
    results["step2"] = r2

    # Step 3: Quarterly Holdings
    print("\n>>> Running Step 3: Quarterly Holdings Consistency")
    r3 = step3_quarterly.run_step3()
    results["step3"] = r3

    # Step 4: Insider Trading
    print("\n>>> Running Step 4: Insider Trading Analysis")
    r4 = step4_insider.run_step4()
    results["step4"] = r4

    # Step 5: Cross-Sectional Heterogeneity
    print("\n>>> Running Step 5: Cross-Sectional Heterogeneity")
    r5 = step5_crosssection.run_step5()
    results["step5"] = r5

    print("\n" + "="*70)
    print("  All Steps Complete")
    print("="*70)

    return results


if __name__ == "__main__":
    results = run_all_steps()
    print("\nResults summary:")
    for step, result in results.items():
        print(f"  {step}: {'OK' if result is not None else 'FAILED'}")
