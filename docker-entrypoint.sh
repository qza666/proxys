#!/bin/sh

set -e

# 设置默认值
IPV6_CIDR=${IPV6_CIDR:-"2001:470:1f05:17b::/64"}
RANDOM_IPV6_PORT=${RANDOM_IPV6_PORT:-60000}
BIND=${BIND:-"0.0.0.0"}
VERBOSE=${VERBOSE:-false}

# 构建命令行参数
ARGS="-cidr $IPV6_CIDR -random-ipv6-port $RANDOM_IPV6_PORT -bind $BIND"

if [ "$VERBOSE" = "true" ]; then
    ARGS="$ARGS -verbose"
fi

if [ -n "$PROXY_USERNAME" ] && [ -n "$PROXY_PASSWORD" ]; then
    ARGS="$ARGS -username $PROXY_USERNAME -password $PROXY_PASSWORD"
fi

# 配置系统参数（如果有权限）
if [ "$(id -u)" = "0" ]; then
    echo "Configuring system parameters..."
    
    # 启用IPv6转发
    echo 1 > /proc/sys/net/ipv6/conf/all/forwarding 2>/dev/null || true
    echo 1 > /proc/sys/net/ipv4/ip_forward 2>/dev/null || true
    echo 1 > /proc/sys/net/ipv6/ip_nonlocal_bind 2>/dev/null || true
    
    echo "System parameters configured"
fi

echo "Starting IPv6 Proxy Server with parameters: $ARGS"

# 执行主程序
exec ./ipv6proxy $ARGS
