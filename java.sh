#!/bin/bash
USERID=$(id -u)
DATE=$(date +%F)
LOG="java-installation-${DATE}.log"
R="\e[31m"
G="\e[32m"
N="\e[0m"

VALIDATE(){
if [ $1 -ne 0 ]; then
	echo -e "$2 ... ${R} FAILURE ${N}" 2>&1 | tee -a $LOG
	exit 1
else
	echo -e "$2 ... ${G} SUCCESS ${N}" 2>&1 | tee -a $LOG
fi
}

if [ $USERID -ne 0 ]; then
	echo -e "${R} You need to be root user to execute this script ${N}"
	exit 1
fi

cat /etc/os-release
sudo apt update -y &>>$LOG 

VALIDATE $? "Updating apt"

sudo apt install openjdk-17-jre -y &>>$LOG

VALIDATE $? "installing java-17"

java -version &>>$LOG

VALIDATE $? "java version" 