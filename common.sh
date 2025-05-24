#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

app_setup()
{
    id roboshop &>>$LOG_FILE
    if [ $? -ne 0 ]
    then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "Creating system user"
    else
        echo -e "System user roboshop is alread created... $Y skipping $N"
    fi

    mkdir -p /app   
    VALIDATE $? "Creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "Downloading the $app_name app"

    rm -rf /app/*
    VALIDATE $? "removing the existing content"
    cd /app 
    VALIDATE $? "Moving to app directory"

    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "unzipping $app_name"
}

systemd_setup()
{
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copying $app_name service"

    systemctl daemon-reload &>>$LOG_FILE
    VALIDATE $? "deamon-reload for $app_name service"

    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "enabling $app_name service"

    systemctl start $app_name 
    VALIDATE $? "staring $app_name service"
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disabling default node js"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "Enabling nodejs 20"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "Installing nodejs:20"

    npm install  &>>$LOG_FILE
    VALIDATE $? "installing Dependencies"
}

#check the user have root privilages or not ? 
check_root()
{
    if [ $USERID -ne 0 ]
    then 
        echo -e "$R ERROR: Please run the user with root access $N" | tee -a $LOG_FILE  
        exit 1 #give other than 0 upto 127 
    else 
        echo "You are running with root access" | tee -a $LOG_FILE 
    fi
}

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

print_time()
{
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "Script executed sucessfully, $Y time taken is: $TOTAL_TIME seconds $N"
}

