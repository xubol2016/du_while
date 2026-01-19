#!/bin/bash
#
# DU 进程监控脚本（集成 coredump 分析功能）

source /flashDev/duapp/ducfg/config/base.sh
source /home/cmccVer/CMCC/rootfs/config/dataplane_env

# 配置参数
CORE_FILE_PATH="/home/cmccRootfs/logFile"
SNAPSHOT_PATH="/home/cmccRootfs/logFile/core_snapshots"
EXECUTABLE_PATH="/flashDev/duapp/ducfg/bin"

# 创建快照目录
mkdir -p ${SNAPSHOT_PATH}

# 分析 core 文件并生成快照
analyze_and_save_core() {
    local du_idx=$1
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 检查是否有 cmccDuCtrl${du_idx} 的 core 文件..."
    
    # 查找最新的 core 文件
    local latest_core=$(find ${CORE_FILE_PATH} -maxdepth 1 -name "core_cmccDuCtrl${du_idx}_*" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
    
    if [ -n "${latest_core}" ] && [ -f "${latest_core}" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 发现 core 文件: ${latest_core}"
        
        local core_basename=$(basename ${latest_core})
        local snapshot_file="${SNAPSHOT_PATH}/${core_basename}_${timestamp}.txt"
        local executable="${EXECUTABLE_PATH}/cmccDuCtrl${du_idx}"
        
        # 检查可执行文件
        if [ ! -f "${executable}" ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 警告: 找不到可执行文件 ${executable}"
            return 1
        fi
        
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始分析 core 文件..."
        
        # 创建 gdb 命令
        cat > /tmp/gdb_analysis_$$.cmd << 'GDBEOF'
set pagination off
set print pretty on
printf "\n========== CORE DUMP ANALYSIS ==========\n"
printf "Analysis Time: "
shell date
printf "Core File: %s\n", (char*)0
printf "\n========== CRASH SIGNAL ==========\n"
info program
printf "\n========== BACKTRACE ==========\n"
bt full
printf "\n========== ALL THREADS BACKTRACE ==========\n"
thread apply all bt
printf "\n========== THREAD LIST ==========\n"
info threads
printf "\n========== REGISTERS ==========\n"
info registers
printf "\n========== CRASH LOCATION DETAILS ==========\n"
frame 0
info frame
info locals
info args
printf "\n========================================\n"
quit
GDBEOF
        
        # 执行 gdb 分析
        if command -v gdb &> /dev/null; then
            gdb -batch -x /tmp/gdb_analysis_$$.cmd ${executable} ${latest_core} > ${snapshot_file} 2>&1
            
            if [ $? -eq 0 ]; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] Core 分析完成，快照保存至: ${snapshot_file}"
                
                # 提取关键崩溃信息
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] === 崩溃摘要 ==="
                grep -A 3 "Program terminated\|Program received signal" ${snapshot_file} 2>/dev/null
                grep -A 2 "^#0 " ${snapshot_file} 2>/dev/null | head -5
                
                # 备份原 core 文件（添加 .analyzed 后缀）
                mv ${latest_core} ${latest_core}.analyzed
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] Core 文件已标记: ${latest_core}.analyzed"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: GDB 分析失败"
            fi
            
            rm -f /tmp/gdb_analysis_$$.cmd
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 警告: 系统未安装 gdb，无法分析 core 文件"
        fi
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 未发现对应的 core 文件"
    fi
}

# 清理旧的 core 文件（删除 .analyzed 文件和未处理的旧文件）
clean_old_core_files() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 清理旧 core 文件..."
    
    # 删除已分析的 core 文件（保留最近3个）
    find ${CORE_FILE_PATH} -maxdepth 1 -name "core_*.analyzed" -type f -mtime +7 -delete 2>/dev/null
    
    # 清理未分析的旧 core 文件（超过1天）
    find ${CORE_FILE_PATH} -maxdepth 1 -name "core_*" ! -name "*.analyzed" -type f -mtime +1 -delete 2>/dev/null
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Core 文件清理完成"
}

# 监控和处理单个 DU 的函数
monitor_du_process() {
    local board_id=$1
    local cell_id_arr_name=$2
    local protocol_arr_name=$3
    
    eval "local du_num=\${#${cell_id_arr_name}[@]}"
    echo "BaseBoard${board_id} du_num="${du_num}
    
    for i in $(seq ${du_num}); do
        eval "local du_id=\${${cell_id_arr_name}[i-1]}"
        local du_idx=$(($du_id - 1))
        local du_ps=$(ps -x | grep "cmccDuCtrl${du_idx}" | grep -v grep | wc -l)
        
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 检查 cmccDuCtrl${du_idx}, 进程数: ${du_ps}"
        
        if [ ${du_ps} -ge 1 ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} 运行正常"
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] *** 检测到 cmccDuCtrl${du_idx} 进程异常 ***"
            
            # 先分析 core 文件（如果存在）
            analyze_and_save_core ${du_idx}
            
            # 清理旧的 core 文件
            clean_old_core_files
            
            # 重启进程
            eval "local protocol_id=\${${protocol_arr_name}[i-1]}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 执行重启: ./start.sh -app du ${protocol_id} ${du_id}"
            ./start.sh -app du ${protocol_id} ${du_id}
            
            if [ $? -eq 0 ]; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} 重启成功"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] *** 错误: cmccDuCtrl${du_idx} 重启失败 ***"
            fi
        fi
    done
}

# 主循环
while true; do
    sleep 10
    
    case ${BASEBOARDID} in
        2)
            monitor_du_process 2 "BaseBoard2CellIdArr" "BaseBoard2CellIdProtolIdArr"
            ;;
        3)
            monitor_du_process 3 "BaseBoard3CellIdArr" "BaseBoard3CellIdProtolIdArr"
            ;;
        4)
            monitor_du_process 4 "BaseBoard4CellIdArr" "BaseBoard4CellIdProtolIdArr"
            ;;
        5)
            monitor_du_process 5 "BaseBoard5CellIdArr" "BaseBoard5CellIdProtolIdArr"
            ;;
        6)
            monitor_du_process 6 "BaseBoard6CellIdArr" "BaseBoard6CellIdProtolIdArr"
            ;;
        7)
            monitor_du_process 7 "BaseBoard7CellIdArr" "BaseBoard7CellIdProtolIdArr"
            ;;
    esac
done
