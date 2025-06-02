#!/bin/bash
source ./common.sh

check_root

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Adding rabbitmq repo"

dnf install rabbitmq-server -y  &>>$LOG_FILE
VALIDATE $? "Installing rabbitmq-server"

systemctl enable rabbitmq-server  &>>$LOG_FILE
VALIDATE $? "Enabling rabbitmq-server"

systemctl start rabbitmq-server  &>>$LOG_FILE
VALIDATE $? "Starting  rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123  &>>$LOG_FILE
VALIDATE $? "Starting rabbitmq-server"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$LOG_FILE

print_time