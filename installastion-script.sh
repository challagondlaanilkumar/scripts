#!/bin/bash
USERID=$(id -u)
DATE=$(date +%F)
LOG="installation-${DATE}.log"
R="\e[31m"
G="\e[32m"
N="\e[0m"
echo $USERID
VALIDATE(){
if [ $1 -ne 0 ]; then
	echo -e "$2 ... ${R} FAILURE ${N}" 2>&1 | tee -a $LOG
	exit 1
else
	echo -e "$2 ... ${G} SUCCESS ${N}" 2>&1 | tee -a $LOG
fi
}
#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
if [ $USERID -ne 0 ]; then
	echo -e "${R} You need to be root user to execute this script ${N}"
	exit 1
fi
figlet -c updating
sudo apt update -y &>>$LOG 
VALIDATE $? "Updating apt"
figlet -c java installation
sudo apt install openjdk-17-jre -y &>>$LOG
VALIDATE $? "installing java-17"
echo "java -version"
java -version 
#--------------------------------python3----------------------------------------------
figlet -c Python3
sudo apt update -y &>>$LOG 
VALIDATE $? "Updating apt"
sudo apt install python3 -y &>>$LOG
VALIDATE $? "Installing Python3..."
echo "Python3 --version"
python3 --version

#------------------------------------docker--------------------------------------------
figlet Docker
sudo apt update -y &>>$LOG 
VALIDATE $? "Updating apt"
sudo apt install docker.io &>>$LOG
VALIDATE $? "Installing Docker"
sudo docker -v 

#-----------------------------------Jenkins Using Docker--------------------------------
figlet Jenkins
sudo apt update -y &>>$LOG 
VALIDATE $? "Updating apt"
docker network create dwithi
docker run -d --name jenkins --network=dwithi -p 8080:8080 jenkins/jenkins:lts &>>$LOG
VALIDATE $? "Creating jenkins using docker image: jenkins/jenkins:lts "
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword &>>$LOG
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
VALIDATE $? "cat /var/jenkins_home/secrets/initialAdminPassword"
#-----------------------------------SonarQube Using Docker ------------------------------









