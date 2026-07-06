#!/usr/bin/env python3
"""
测试 API 连接脚本 (v3 - 并行版本)
读取 api_config.json 配置，并行测试每个启用的 API 端点连接。
支持模型自动重试，提高测试成功率。
"""

import json
import time
import requests
import threading
from typing import Dict, Any, Optional, List, Tuple
from concurrent.futures import ThreadPoolExecutor, as_completed


def load_config(config_path: str) -> Dict[str, Any]:
    """加载配置文件"""
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"错误：配置文件 {config_path} 未找到")
        raise
    except json.JSONDecodeError as e:
        print(f"错误：配置文件格式错误 - {e}")
        raise


def determine_api_type(api_config: Dict[str, Any]) -> str:
    """根据配置确定 API 类型"""
    name = api_config.get("name", "").lower()
    base_url = api_config.get("base_url", "").lower()

    if "anthropic" in name or "anthropic" in base_url:
        return "anthropic"
    elif "openai" in name or "openai" in base_url or "gptsapi" in base_url:
        return "openai"
    else:
        # 默认尝试 OpenAI 兼容格式
        return "openai"


def get_candidate_models(api_type: str, test_models: List[str]) -> List[str]:
    """获取候选模型列表"""
    if api_type == "anthropic":
        # 筛选 Claude 模型
        claude_models = [m for m in test_models if "claude" in m.lower()]
        return claude_models if claude_models else ["claude-sonnet-4-6"]
    else:
        # 筛选 GPT 模型，优先选择 mini 模型（通常更便宜）
        gpt_models = [m for m in test_models if "gpt" in m.lower()]
        # 如果没有 GPT 模型，返回所有模型
        return gpt_models if gpt_models else test_models


def build_request_payload(api_type: str, model: str, message: str, settings: Dict[str, Any]) -> Dict[str, Any]:
    """构建请求体"""
    max_tokens = settings.get("max_tokens", 500)

    if api_type == "anthropic":
        return {
            "model": model,
            "max_tokens": max_tokens,
            "messages": [
                {"role": "user", "content": message}
            ]
        }
    else:  # openai 兼容格式
        return {
            "model": model,
            "messages": [
                {"role": "user", "content": message}
            ],
            "max_tokens": max_tokens,
            "temperature": 0.7
        }


def build_headers(api_type: str, api_key: str) -> Dict[str, str]:
    """构建请求头"""
    headers = {
        "Content-Type": "application/json"
    }

    if api_type == "anthropic":
        headers["x-api-key"] = api_key
        headers["anthropic-version"] = "2023-06-01"
    else:
        headers["Authorization"] = f"Bearer {api_key}"

    return headers


def extract_response_content(api_type: str, response_data: Dict[str, Any]) -> str:
    """从响应中提取内容"""
    try:
        if api_type == "anthropic":
            # Anthropic 响应格式
            if "content" in response_data and response_data["content"]:
                return response_data["content"][0].get("text", "无内容")
            return "无内容"
        else:
            # OpenAI 兼容格式
            if "choices" in response_data and response_data["choices"]:
                choice = response_data["choices"][0]
                if "message" in choice:
                    return choice["message"].get("content", "无内容")
                elif "text" in choice:
                    return choice["text"]
            return "无内容"
    except (KeyError, IndexError, TypeError) as e:
        return f"解析响应时出错: {e}"


def is_model_not_found_error(api_type: str, status_code: int, error_data: Dict[str, Any]) -> bool:
    """检查是否为模型未找到错误"""
    if status_code != 400:
        return False

    error_msg = ""
    if isinstance(error_data, dict):
        if "error" in error_data:
            error_info = error_data["error"]
            if isinstance(error_info, dict):
                error_msg = error_info.get("message", "").lower()
            else:
                error_msg = str(error_info).lower()
        elif "message" in error_data:
            error_msg = error_data["message"].lower()

    return "model not found" in error_msg or "model_not_found" in error_msg


def try_single_model(api_config: Dict[str, Any], model: str, test_message: str,
                     settings: Dict[str, Any]) -> Tuple[Dict[str, Any], Optional[Dict[str, Any]]]:
    """尝试使用单个模型测试 API"""
    api_type = determine_api_type(api_config)
    base_url = api_config.get("base_url", "").rstrip('/')
    api_key = api_config.get("api_key", "")
    timeout = settings.get("timeout", 30)

    # 构建请求
    payload = build_request_payload(api_type, model, test_message, settings)
    headers = build_headers(api_type, api_key)

    # 确定端点路径
    if api_type == "anthropic":
        endpoint = f"{base_url}/messages"
    else:
        endpoint = f"{base_url}/chat/completions"

    start_time = time.time()

    try:
        response = requests.post(
            endpoint,
            headers=headers,
            json=payload,
            timeout=timeout
        )

        elapsed_time = time.time() - start_time

        # 处理响应
        if response.status_code == 200:
            response_data = response.json()
            content = extract_response_content(api_type, response_data)
            return {
                "status": "success",
                "status_code": response.status_code,
                "latency": elapsed_time,
                "response_preview": content[:100],
                "model_used": model,
                "full_content": content
            }, None
        else:
            # 处理错误状态码
            error_msg = ""
            error_data = {}
            try:
                error_data = response.json()
                if "error" in error_data:
                    error_msg = error_data["error"].get(
                        "message", str(error_data["error"]))
                else:
                    error_msg = str(error_data)
            except:
                error_msg = response.text[:200]
                error_data = {"raw": error_msg}

            return {
                "status": "error",
                "status_code": response.status_code,
                "latency": elapsed_time,
                "error": error_msg,
                "model_used": model,
                "error_data": error_data
            }, error_data

    except requests.exceptions.Timeout:
        elapsed_time = time.time() - start_time
        return {
            "status": "timeout",
            "timeout_seconds": timeout,
            "latency": elapsed_time,
            "model_used": model
        }, None

    except requests.exceptions.ConnectionError as e:
        elapsed_time = time.time() - start_time
        return {
            "status": "connection_error",
            "error": str(e)[:200],
            "latency": elapsed_time,
            "model_used": model
        }, None

    except requests.exceptions.RequestException as e:
        elapsed_time = time.time() - start_time
        return {
            "status": "request_error",
            "error": str(e)[:200],
            "latency": elapsed_time,
            "model_used": model
        }, None


def test_single_api(api_config: Dict[str, Any], test_message: str,
                    test_models: List[str], settings: Dict[str, Any],
                    budget_lock: threading.Lock, budget_info: Dict[str, float],
                    api_index: int) -> Optional[Dict[str, Any]]:
    """测试单个 API 端点，支持模型重试（线程安全版本）"""
    api_name = api_config.get("name", "未知API")
    base_url = api_config.get("base_url", "").rstrip('/')
    estimated_cost_per_attempt = 0.01  # 估算每次测试成本

    # 线程安全的输出前缀
    thread_prefix = f"[API-{api_index+1}]"

    print(f"\n{thread_prefix} 开始测试: {api_name}")
    print(f"{thread_prefix} 端点: {base_url}")

    # 线程安全地检查预算
    with budget_lock:
        if budget_info["remaining"] < estimated_cost_per_attempt:
            print(
                f"{thread_prefix} 跳过测试：预算不足 (剩余: ${budget_info['remaining']:.2f}, 需要: ${estimated_cost_per_attempt:.2f})")
            return None

    # 确定 API 类型和候选模型
    api_type = determine_api_type(api_config)
    candidate_models = get_candidate_models(api_type, test_models)

    print(f"{thread_prefix} API 类型: {api_type}")
    print(f"{thread_prefix} 候选模型: {', '.join(candidate_models)}")
    print(f"{thread_prefix} 测试消息: {test_message[:50]}...")

    # 尝试每个候选模型
    best_result = None
    attempts = []

    for i, model in enumerate(candidate_models):
        print(f"{thread_prefix}   尝试模型 {i+1}/{len(candidate_models)}: {model}")

        result, error_data = try_single_model(
            api_config, model, test_message, settings)
        attempts.append({
            "model": model,
            "result": result,
            "error_data": error_data
        })

        if result["status"] == "success":
            print(f"{thread_prefix}   ✓ 成功 - 状态码: {result['status_code']}")
            print(f"{thread_prefix}     延迟: {result['latency']:.2f} 秒")
            print(f"{thread_prefix}     响应内容: {result['response_preview']}...")
            best_result = result
            break
        else:
            print(f"{thread_prefix}   ✗ 失败 - {result.get('status', '未知错误')}")
            if result.get("status_code"):
                print(f"{thread_prefix}     状态码: {result['status_code']}")
            if result.get("error"):
                print(f"{thread_prefix}     错误: {result['error'][:100]}")

            # 如果不是模型未找到错误，停止重试
            if not is_model_not_found_error(api_type, result.get("status_code", 0), error_data or {}):
                print(f"{thread_prefix}     非模型错误，停止重试")
                best_result = result
                break

    # 如果没有成功的结果，使用最后一次尝试的结果
    if not best_result and attempts:
        best_result = attempts[-1]["result"]

    # 线程安全地更新预算（仅对成功请求扣减）
    if best_result and best_result.get("status") == "success":
        with budget_lock:
            budget_info["remaining"] -= estimated_cost_per_attempt
            print(
                f"{thread_prefix}   估算成本: ${estimated_cost_per_attempt:.2f}, 剩余预算: ${budget_info['remaining']:.2f}")

    # 构建最终结果
    final_result = {
        "api_name": api_name,
        "base_url": base_url,
        "api_type": api_type,
        "attempts": len(attempts),
        "models_tried": [a["model"] for a in attempts],
        "test_index": api_index
    }

    if best_result:
        final_result.update(best_result)

    print(f"{thread_prefix} 完成测试: {api_name} - {best_result.get('status', '未知') if best_result else '无结果'}")
    return final_result


def main():
    """主函数"""
    config_path = "api_config.json"

    print("=" * 60)
    print("API 连接测试工具 (v3 - 并行版本)")
    print("=" * 60)

    # 加载配置
    try:
        config = load_config(config_path)
    except Exception as e:
        print(f"无法加载配置文件: {e}")
        return

    # 提取配置
    apis = config.get("apis", [])
    test_models = config.get("test_models", [])
    test_messages = config.get("test_messages", [])
    budget_limit = config.get("budget_limit", 0)
    settings = config.get("settings", {})

    print(f"\n配置信息:")
    print(f"  API 数量: {len(apis)}")
    print(f"  预算限制: ${budget_limit:.2f}")
    print(f"  测试模型: {', '.join(test_models)}")
    print(f"  超时设置: {settings.get('timeout', 30)} 秒")
    print(f"  请求间延迟: {settings.get('delay_between_requests', 1)} 秒")

    # 检查预算
    if budget_limit <= 0:
        print("\n警告: 预算限制为 0，跳过所有测试")
        return

    # 使用第一条测试消息
    test_message = test_messages[0] if test_messages else "你好，请用一句话介绍你自己"
    print(f"\n测试消息: {test_message}")

    # 筛选启用的 API
    enabled_apis = [api for api in apis if api.get("enabled", False)]
    print(f"\n启用的 API: {len(enabled_apis)} 个")

    if not enabled_apis:
        print("没有启用的 API 端点")
        return

    # 并行测试配置
    max_workers = min(len(enabled_apis), 4)  # 最多4个并发线程
    print(f"\n并行测试配置:")
    print(f"  最大并发数: {max_workers}")
    print(f"  预计测试时间: 约 {settings.get('timeout', 30) + 2} 秒（取决于最慢的API）")

    # 线程安全的预算信息
    budget_info = {
        "remaining": budget_limit
    }
    budget_lock = threading.Lock()

    # 存储结果
    results = []
    results_lock = threading.Lock()

    # 测试开始时间
    start_time = time.time()

    # 使用线程池并行测试
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # 提交所有测试任务
        future_to_api = {}
        for i, api_config in enumerate(enabled_apis):
            future = executor.submit(
                test_single_api,
                api_config,
                test_message,
                test_models,
                settings,
                budget_lock,
                budget_info,
                i
            )
            future_to_api[future] = (i, api_config.get("name", f"API-{i+1}"))

        # 收集结果
        print(f"\n开始并行测试 {len(enabled_apis)} 个 API...")

        for future in as_completed(future_to_api):
            api_index, api_name = future_to_api[future]
            try:
                result = future.result()
                if result:
                    with results_lock:
                        results.append(result)
            except Exception as e:
                print(f"\n[API-{api_index+1}] 测试异常: {api_name} - {str(e)}")
                with results_lock:
                    results.append({
                        "api_name": api_name,
                        "status": "exception",
                        "error": str(e),
                        "test_index": api_index
                    })

    # 测试总时间
    total_time = time.time() - start_time

    # 输出测试总结
    print("\n" + "=" * 60)
    print("测试总结")
    print("=" * 60)

    success_count = sum(
        1 for r in results if r and r.get("status") == "success")
    total_tested = len(results)

    print(f"测试完成: {total_tested}/{len(enabled_apis)} 个 API")
    print(f"成功: {success_count} 个")
    print(f"失败: {total_tested - success_count} 个")
    print(f"总测试时间: {total_time:.2f} 秒")
    print(
        f"平均每个API时间: {total_time/total_tested:.2f} 秒" if total_tested > 0 else "")
    print(f"剩余预算: ${budget_info['remaining']:.2f}")

    # 详细结果（按测试索引排序）
    if results:
        print("\n详细结果:")
        sorted_results = sorted(results, key=lambda x: x.get("test_index", 0))
        for result in sorted_results:
            if result:
                status_icon = "✓" if result.get("status") == "success" else "✗"
                model_info = f" (尝试 {result.get('attempts', 1)} 个模型)" if result.get(
                    'attempts', 1) > 1 else ""
                latency_info = f" ({result.get('latency', 0):.2f}s)" if result.get(
                    'latency') else ""
                print(f"  {status_icon} {result.get('api_name', '未知')}: "
                      f"{result.get('status', '未知')}{latency_info}{model_info}")
                if result.get("status") != "success" and result.get("error"):
                    print(f"    错误: {result['error'][:100]}")

    # 保存结果到文件
    try:
        output_data = {
            "test_time": time.strftime("%Y-%m-%d %H:%M:%S"),
            "test_message": test_message,
            "budget_limit": budget_limit,
            "remaining_budget": budget_info["remaining"],
            "total_apis": len(enabled_apis),
            "successful_apis": success_count,
            "total_test_time_seconds": total_time,
            "max_workers": max_workers,
            "results": sorted(results, key=lambda x: x.get("test_index", 0))
        }

        with open("api_test_results.json", "w", encoding="utf-8") as f:
            json.dump(output_data, f, ensure_ascii=False, indent=2)
        print(f"\n测试结果已保存到: api_test_results.json")
    except Exception as e:
        print(f"\n保存结果时出错: {e}")

    # 返回成功状态
    return success_count > 0


if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
