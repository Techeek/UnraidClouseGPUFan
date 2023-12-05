#!/bin/bash
# 虚拟机的名称
vm_name=Win11
# 检查虚拟机是否存在
if [ -z "$(virsh list --all | grep $vm_name)" ]; then
  echo "虚拟机 $vm_name 不存在"
  exit 1
fi
# 执行nvidia-smi -q -d=PERFORMANCE
output=$(nvidia-smi -q -d=PERFORMANCE)
# 提取Performance State的值
state=$(echo "$output" | grep "Performance State" | awk '{print $4}')
# 检查Performance State是否为P8
if [ "$state" == "P8" ]; then
  echo "Performance State为P8，无需执行nvidia-smi --persistence-mode=1"
  exit 0
fi
# 如果Performance State不为P8，执行nvidia-smi --persistence-mode=1
echo "Performance State不为P8，执行nvidia-smi --persistence-mode=1"
nvidia-smi --persistence-mode=1
# 检查虚拟机是否关机
if [ -z "$(virsh list --state-shutoff | grep $vm_name)" ]; then
  echo "虚拟机 $vm_name 没有关机"
  exit 0
fi
# 如果虚拟机关机，执行nvidia-smi --persistence-mode=1
echo "虚拟机 $vm_name 已经关机，执行nvidia-smi --persistence-mode=1"
nvidia-smi --persistence-mode=1
