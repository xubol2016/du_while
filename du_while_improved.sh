#!/bin/bash
#

source /flashDev/duapp/ducfg/config/base.sh
source /home/cmccVer/CMCC/rootfs/config/dataplane_env

# 定义 core 文件路径
CORE_FILE_PATH="/home/cmccRootfs/logFile"

# 删除 core 文件的函数
clean_core_files() {
    if [ -d "${CORE_FILE_PATH}" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleaning core files in ${CORE_FILE_PATH}"
        rm -f ${CORE_FILE_PATH}/core_* 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Core files cleaned successfully"
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Warning: Failed to clean some core files"
        fi
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Warning: Directory ${CORE_FILE_PATH} does not exist"
    fi
}

while true; do
    sleep 10

    if [ ${BASEBOARDID} -eq 2 ]; then
        du_num=${#BaseBoard2CellIdArr[@]}
        echo "du_num="${du_num}
        for i in $(seq ${du_num}); do
            du_id=${BaseBoard2CellIdArr[i-1]}
            du_idx=$(($du_id - 1))
            du_ps=$(ps -x | grep "cmccDuCtrl${du_idx}" | grep -v grep | wc -l)
            echo $du_ps
            if [ ${du_ps} -ge 1 ]; then
                echo "cmccDuCtrl${du_idx} ok"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} not running, restarting..."
                # 删除 core 文件
                clean_core_files
                echo "./start.sh -app du ${BaseBoard2CellIdProtolIdArr[i-1]} ${BaseBoard2CellIdArr[i-1]}"
                ./start.sh -app du ${BaseBoard2CellIdProtolIdArr[i-1]} ${BaseBoard2CellIdArr[i-1]}
                if [ $? -eq 0 ]; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} restarted successfully"
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Failed to restart cmccDuCtrl${du_idx}"
                fi
            fi
        done
    fi

    if [ ${BASEBOARDID} -eq 3 ]; then
        du_num=${#BaseBoard3CellIdArr[@]}
        echo "du_num="${du_num}
        for i in $(seq ${du_num}); do
            du_id=${BaseBoard3CellIdArr[i-1]}
            du_idx=$(($du_id - 1))
            du_ps=$(ps -x | grep "cmccDuCtrl${du_idx}" | grep -v grep | wc -l)
            echo $du_ps
            if [ ${du_ps} -ge 1 ]; then
                echo "cmccDuCtrl${du_idx} ok"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} not running, restarting..."
                # 删除 core 文件
                clean_core_files
                echo "./start.sh -app du ${BaseBoard3CellIdProtolIdArr[i-1]} ${BaseBoard3CellIdArr[i-1]}"
                ./start.sh -app du ${BaseBoard3CellIdProtolIdArr[i-1]} ${BaseBoard3CellIdArr[i-1]}
                if [ $? -eq 0 ]; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} restarted successfully"
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Failed to restart cmccDuCtrl${du_idx}"
                fi
            fi
        done
    fi

    if [ ${BASEBOARDID} -eq 4 ]; then
        du_num=${#BaseBoard4CellIdArr[@]}
        echo "du_num="${du_num}
        for i in $(seq ${du_num}); do
            du_id=${BaseBoard4CellIdArr[i-1]}
            du_idx=$(($du_id - 1))
            du_ps=$(ps -x | grep "cmccDuCtrl${du_idx}" | grep -v grep | wc -l)
            echo $du_ps
            if [ ${du_ps} -ge 1 ]; then
                echo "cmccDuCtrl${du_idx} ok"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} not running, restarting..."
                # 删除 core 文件
                clean_core_files
                echo "./start.sh -app du ${BaseBoard4CellIdProtolIdArr[i-1]} ${BaseBoard4CellIdArr[i-1]}"
                ./start.sh -app du ${BaseBoard4CellIdProtolIdArr[i-1]} ${BaseBoard4CellIdArr[i-1]}
                if [ $? -eq 0 ]; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} restarted successfully"
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Failed to restart cmccDuCtrl${du_idx}"
                fi
            fi
        done
    fi

    if [ ${BASEBOARDID} -eq 5 ]; then
        du_num=${#BaseBoard5CellIdArr[@]}
        echo "du_num="${du_num}
        for i in $(seq ${du_num}); do
            du_id=${BaseBoard5CellIdArr[i-1]}
            du_idx=$(($du_id - 1))
            du_ps=$(ps -x | grep "cmccDuCtrl${du_idx}" | grep -v grep | wc -l)
            echo $du_ps
            if [ ${du_ps} -ge 1 ]; then
                echo "cmccDuCtrl${du_idx} ok"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} not running, restarting..."
                # 删除 core 文件
                clean_core_files
                echo "./start.sh -app du ${BaseBoard5CellIdProtolIdArr[i-1]} ${BaseBoard5CellIdArr[i-1]}"
                ./start.sh -app du ${BaseBoard5CellIdProtolIdArr[i-1]} ${BaseBoard5CellIdArr[i-1]}
                if [ $? -eq 0 ]; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} restarted successfully"
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Failed to restart cmccDuCtrl${du_idx}"
                fi
            fi
        done
    fi

    if [ ${BASEBOARDID} -eq 6 ]; then
        du_num=${#BaseBoard6CellIdArr[@]}
        echo "du_num="${du_num}
        for i in $(seq ${du_num}); do
            du_id=${BaseBoard6CellIdArr[i-1]}
            du_idx=$(($du_id - 1))
            du_ps=$(ps -x | grep "cmccDuCtrl${du_idx}" | grep -v grep | wc -l)
            echo $du_ps
            if [ ${du_ps} -ge 1 ]; then
                echo "cmccDuCtrl${du_idx} ok"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} not running, restarting..."
                # 删除 core 文件
                clean_core_files
                echo "./start.sh -app du ${BaseBoard6CellIdProtolIdArr[i-1]} ${BaseBoard6CellIdArr[i-1]}"
                ./start.sh -app du ${BaseBoard6CellIdProtolIdArr[i-1]} ${BaseBoard6CellIdArr[i-1]}
                if [ $? -eq 0 ]; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} restarted successfully"
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Failed to restart cmccDuCtrl${du_idx}"
                fi
            fi
        done
    fi

    if [ ${BASEBOARDID} -eq 7 ]; then
        du_num=${#BaseBoard7CellIdArr[@]}
        echo "du_num="${du_num}
        for i in $(seq ${du_num}); do
            du_id=${BaseBoard7CellIdArr[i-1]}
            du_idx=$(($du_id - 1))
            du_ps=$(ps -x | grep "cmccDuCtrl${du_idx}" | grep -v grep | wc -l)
            echo $du_ps
            if [ ${du_ps} -ge 1 ]; then
                echo "cmccDuCtrl${du_idx} ok"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} not running, restarting..."
                # 删除 core 文件
                clean_core_files
                echo "./start.sh -app du ${BaseBoard7CellIdProtolIdArr[i-1]} ${BaseBoard7CellIdArr[i-1]}"
                ./start.sh -app du ${BaseBoard7CellIdProtolIdArr[i-1]} ${BaseBoard7CellIdArr[i-1]}
                if [ $? -eq 0 ]; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] cmccDuCtrl${du_idx} restarted successfully"
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Failed to restart cmccDuCtrl${du_idx}"
                fi
            fi
        done
    fi
done
