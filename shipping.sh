#!/bin/bash

source ./common.sh
app_name=shipping


check_root

app_setup
maven_setup
systemd_setup

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing my sql"
 
mysql -h mysql.daws84s.cloud -u root -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ]
then
    mysql -h mysql.daws84s.cloud -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.daws84s.cloud -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h mysql.daws84s.cloud -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "Loading MySQL data"
else
    echo -e "Data is loaded already loaded into MYSQL... $Y SKIPPING $N"

fi

systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "restart shipping"

print_time

