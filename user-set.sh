#!/bin/bash

set -e 

failure(){
echo "Failed at : $1 $2"
}

trap 'failure "${LINENO}" "${BASH_COMMAND}"' ERR

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/user-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

#check the user have root privilages or not ? 
if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: Please run the user with root access $N" | tee -a $LOG_FILE  
    exit 1 #give other than 0 upto 127 
else 
    echo "You are running with root access" | tee -a $LOG_FILE 
fi

#validating if installation is sucedded or not 
VALIDATE()
{
    if [ $1 -eq 0 ]
    then
       echo -e "$2 is ...$G SUCESS $N" | tee -a $LOG_FILE 
    else
       echo -e " $2 is ...$R FAILURE $N "| tee -a $LOG_FILE 
        exit 1
    fi
}

dnf module disable nodejs -y &>>$LOG_FILE
dnf module enable nodejs:20 -y &>>$LOG_FILE
dnf install nodejs -y &>>$LOG_FILE

id roboshop

if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "Creating system user"
else
    echo -e "System user roboshop is alread created... $Y skipping $N"
fi

mkdir -p /app   

curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip &>>$LOG_FILE

rm -rf /app/*
cd /app 

unzip /tmp/user.zip &>>$LOG_FILE

npm install  &>>$LOG_FILE

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service

systemctl daemon-reload &>>$LOG_FILE

systemctl enable user &>>$LOG_FILE

systemctl start user 

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME - $START_TIME))

echo -e "Script execution completed sucessfully, $Y time taken:  $TOTAL_TIME Seconds $N" | tee -a $LOG_FILE 