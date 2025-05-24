#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: Please run the user with root access $N"
    exit 1 #give other than 0 upto 127 
else 
    echo "You are running with root access"
fi

#validating if installation is sucedded or not 
VALIDATE()
{
    if [ $1 -eq 0 ]
    then
       echo -e "Install $2 is ...$G SUCESS $N"
    else
       echo -e "Install $2 is ...$R FAILURE $N "
        exit 1
    fi
}

dnf list installed mysql
if [ $? -ne 0 ]
then 
    echo "MYSQL is not installed..... going to install"
    dnf install mysql -y 
    VALIDATE $? "MySql"
else 
    echo -e "$Y MySQL is already installed and nothing to do $N"
fi

dnf list installed nginx
if [ $? -ne 0 ]
then 
    echo "nginx is not installed..... going to install"
    dnf install nginx -y 
    VALIDATE $? "nginx"
else 
    echo -e "$Y nginx is already installed and nothing to do $N"
fi

dnf list installed python3
if [ $? -ne 0 ]
then 
    echo "python3 is not installed..... going to install"
    dnf install python3 -y 
    VALIDATE $? "Python3"
else
    echo -e "$Y python3 is already installed and nothing to do $N"
fi
