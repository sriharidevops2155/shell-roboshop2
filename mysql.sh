#!/bin/bash

source ./common.sh
app_name=mysql

check_root

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "enabling mysql server"
systemctl start mysqld  &>>$LOG_FILE
VALIDATE $? "started mysql server"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE

print_time  