#!/bin/bash

# 디렉토리 설정
work_dir="/home/ubuntu/log_backups"
aggr_base_dir="/home/ubuntu/log_aggr"
work_target_ymd=$(date +%F)  # 현재 날짜 (YYYY-MM-DD)

# 날짜별 폴더 설정
target_folder="$work_dir/$work_target_ymd"

# 집계 로그 파일 경로 설정
list_file="$aggr_base_dir/list/${work_target_ymd}_list.log"
view_file="$aggr_base_dir/view/${work_target_ymd}_view.log"
cart_file="$aggr_base_dir/cart/${work_target_ymd}_cart.log"
order_file="$aggr_base_dir/order/${work_target_ymd}_order.log"

# aggr_base_dir 디렉토리와 하위 디렉토리들이 존재하지 않으면 생성
mkdir -p "$aggr_base_dir/list"
mkdir -p "$aggr_base_dir/view"
mkdir -p "$aggr_base_dir/cart"
mkdir -p "$aggr_base_dir/order"

# 날짜별 폴더가 존재하는지 확인
if [ ! -d "$target_folder" ]; then
    echo "Directory $target_folder does not exist."
    exit 1
fi

# 날짜별 폴더 내의 모든 logcontroller.~ 파일 처리
for logfile in "$target_folder"/logcontroller.*; do
    # 파일이 아닌 경우 건너뜀
    [ -f "$logfile" ] || continue
    
    # 로그 파일의 내용을 한 줄씩 처리
    while IFS= read -r line; do
        # 첫 글자에 따라 처리
        case "${line:0:1}" in
            l)
                echo "$line" >> "$list_file"
                ;;
            v|c|o)
                # 7번째 필드 추출
                field=$(echo "$line" | awk '{print $7}')
                
                # 필드 값에 따라 적절한 파일에 추가
                case "$field" in
                    order)
                        echo "$line" >> "$order_file"
                        ;;
                    view)
                        echo "$line" >> "$view_file"
                        ;;
                    cart)
                        echo "$line" >> "$cart_file"
                        ;;
                    *)
                        # 다른 경우는 무시
                        ;;
                esac
                ;;
            *)
                # 첫 글자가 l, v, c, o 가 아닌 경우 무시
                ;;
        esac
    done < "$logfile"
    
    echo "$logfile processed"
done

# 날짜가 동일한 집계 로그 파일이 존재하면 빈 파일을 처리
for file in "$list_file" "$view_file" "$cart_file" "$order_file"; do
    # 파일이 빈 경우 "no"라는 메시지를 추가
    if [ ! -s "$file" ]; then
        echo "no" > "$file"
    fi
done

echo "Filtering completed."
