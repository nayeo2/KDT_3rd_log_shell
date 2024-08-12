#!/bin/bash

# Variables의 local_infile ON 상태로 수정해야합니다.

# MySQL 접속 정보
MYSQL_HOST="f9f032df-a7af-4c06-8247-601832f6ef39.internal.kr1.mysql.rds.nhncloudservice.com"
MYSQL_USER="user"
MYSQL_PASSWORD="mysqlmysql"
MYSQL_DATABASE="log_backup"
MYSQL_TABLE="aggr_logs"

# 오늘 날짜
work_target_ymd=$(date +%F)

# 로그 파일 경로
LOG_FILE="/home/ubuntu/log_backups/$work_target_ymd/${work_target_ymd}_merged.log"

# MySQL LOAD DATA INFILE 쿼리 실행
mysql --local-infile=1 -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "
    LOAD DATA LOCAL INFILE '$LOG_FILE'
    INTO TABLE $MYSQL_TABLE
    FIELDS TERMINATED BY '\t'  -- 탭으로 구분된 데이터
    LINES TERMINATED BY '\n'
    (type, log_date, url, method, userId, transactionId, productId, cartId, orderId, payload, clientIP, userAgent, referer);
"
