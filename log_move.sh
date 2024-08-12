#!/bin/bash

# 로그 저장 장소 및 백업 장소 정의
bk_dir="/home/ubuntu/logs"        # 로그 저장 장소
work_dir="/home/ubuntu/log_backups" # 로그 1차 백업 장소

# 날짜를 기반으로 작업할 폴더와 파일 정의
work_target_ymd=$(date +%F)
target_dir="$work_dir/$work_target_ymd"
merged_log_file="$target_dir/${work_target_ymd}_merged.log"

# 작업 폴더가 존재하지 않으면 생성
sudo mkdir -p "$target_dir"

# 로그 파일을 백업 장소로 복사
sudo cp "$bk_dir"/logcontroller."$work_target_ymd"_* "$target_dir"/

# 병합할 파일들을 병합하여 하나의 파일로 저장
cat "$target_dir"/logcontroller."$work_target_ymd"_* > "$merged_log_file"

# 병합된 파일의 크기와 내용을 확인 (선택사항)
echo "Merged log file created: $merged_log_file"
ls -lh "$merged_log_file"
