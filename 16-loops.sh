#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellpractise-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "python3" "nginx" "httpd")

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE 

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
       echo -e "Install $2 is ...$G SUCESS $N" | tee -a $LOG_FILE 
    else
       echo -e "Install $2 is ...$R FAILURE $N "| tee -a $LOG_FILE 
       exit 1
    fi
}

for package in $@
do 
    dnf list installed $package &>>$LOG_FILE
    if [ $? -ne 0 ]
    then 
        echo "$package is not installed..... going to install" | tee -a $LOG_FILE 
        dnf install $package -y &>>$LOG_FILE 
        VALIDATE $? "$package"
    else 
        echo -e "$Y $package is already installed and nothing to do $N" | tee -a $LOG_FILE 
    fi
done
