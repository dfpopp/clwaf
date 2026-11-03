#!/bin/sh
# WAF 一键运维脚本：托管 wafd（wafd 再托管 waf/admin/cron 三个子进程）
# 用法: ./wafctl.sh {start|stop|restart|status|initdb}
# 注意: 请在本脚本所在目录（安装目录）执行

cd "$(dirname "$0")" || exit 1
mkdir -p runtime/log/wafd

case "$1" in
    start)
        if ./wafd status >/dev/null 2>&1; then
            echo "wafd 已在运行"
            exit 0
        fi
        # 首次部署引导前置：前台执行数据库初始化检查，连接失败/缺配置时
        # 分步说明直接打印在终端上（initdb 幂等，已初始化秒过），不被 nohup 吞进日志
        if ! ./admin -initdb; then
            echo "数据库初始化检查未通过，请按上述说明处理后重新执行 $0 start"
            exit 1
        fi
        nohup ./wafd start >> runtime/log/wafd/daemon.out.log 2>&1 &
        echo "wafd 启动中 (pid=$!)，日志: runtime/log/wafd/daemon.out.log"
        # 轮询等待启动完成（wafd 需拉起 waf/admin/cron 三个子进程，慢机器可能超过 2 秒）
        i=0
        while [ "$i" -lt 30 ]; do
            sleep 1
            if ./wafd status >/dev/null 2>&1; then
                exec ./wafd status
            fi
            i=$((i + 1))
        done
        echo "启动异常（等待 30 秒仍未运行），请查看 runtime/log/wafd/daemon.out.log"
        exit 1
        ;;
    stop)
        if ./wafd stop; then
            :
        else
            echo "wafd 未在运行或停止失败"
            exit 1
        fi
        ;;
    restart)
        if ./wafd restart; then
            :
        else
            echo "wafd 未在运行或重启失败"
            exit 1
        fi
        ;;
    status)
        exec ./wafd status
        ;;
    initdb)
        # 数据库初始化检查：连接失败打印分步设置说明；空库自动导入 sql/init.sql
        exec ./admin -initdb
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status|initdb}"
        exit 1
        ;;
esac
