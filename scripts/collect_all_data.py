"""
Unified Data Collection Script
==============================
整合BaoStock、Tushare、iFinD三源数据

使用方式:
    python collect_all_data.py --source baostock
    python collect_all_data.py --source tushare  
    python collect_all_data.py --source ifind
    python collect_all_data.py --source all
"""

import argparse
import sys
from pathlib import Path

# Add project paths
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "scripts"))


def run_baostock():
    """运行BaoStock数据采集"""
    print("\n" + "=" * 60)
    print("Step 1: BaoStock 数据采集")
    print("=" * 60)
    try:
        import fetch_baostock
        fetch_baostock.main()
    except Exception as e:
        print(f"BaoStock采集失败: {e}")


def run_tushare():
    """运行Tushare数据采集"""
    print("\n" + "=" * 60)
    print("Step 2: Tushare 数据采集")
    print("=" * 60)
    try:
        import fetch_tushare
        fetch_tushare.main()
    except Exception as e:
        print(f"Tushare采集失败: {e}")


def run_ifind():
    """运行iFinD数据采集"""
    print("\n" + "=" * 60)
    print("Step 3: iFinD 数据采集")
    print("=" * 60)
    try:
        import fetch_ifind
        fetch_ifind.main()
    except Exception as e:
        print(f"iFinD采集失败: {e}")


def run_build_panel():
    """运行面板构建"""
    print("\n" + "=" * 60)
    print("Step 4: 构建分析面板")
    print("=" * 60)
    try:
        import build_panel
        build_panel.main()
    except Exception as e:
        print(f"面板构建失败: {e}")


def main():
    parser = argparse.ArgumentParser(description='采集A股数据')
    parser.add_argument('--source', choices=['baostock', 'tushare', 'ifind', 'all'],
                        default='all', help='数据源')
    parser.add_argument('--stocks', type=int, default=50,
                        help='采集股票数量（仅baostock有效）')

    args = parser.parse_args()

    print("=" * 60)
    print("Say-Buy/Whisper-Sell Research: 全量数据采集")
    print("=" * 60)

    if args.source in ['baostock', 'all']:
        run_baostock()

    if args.source in ['tushare', 'all']:
        run_tushare()

    if args.source in ['ifind', 'all']:
        run_ifind()

    if args.source == 'all':
        run_build_panel()

    print("\n" + "=" * 60)
    print("数据采集完成!")
    print("=" * 60)
    print("\n下一步:")
    print("  1. 设置TUSHARE_TOKEN环境变量")
    print("  2. 运行 python main.py 执行实证分析")


if __name__ == "__main__":
    main()
