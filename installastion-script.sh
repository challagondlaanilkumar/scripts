#!/bin/bash
USERID=$(id -u)
DATE=$(date +%F)
LOG="installation-${DATE}.log"
LOG1="jenkinspassword.txt"
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

#------------------------------------MAven------------------------------------------
figlet Maven
sudo apt update -y &>>$LOG

#------------------------------------docker--------------------------------------------
figlet docker
# Update package lists
sudo apt-get update &>>$LOG

# Install required packages
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common &>>$LOG

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &>>$LOG

# Add Docker repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &>>$LOG

# Update package lists again
sudo apt-get update &>>$LOG

# Install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io &>>$LOG
VALIDATE $? "installing docker-ce docker-ce-cli containerd.io" &>>$LOG
# Start and enable Docker service
sudo systemctl start docker &>>$LOG
VALIDATE $? "systemctl start docker" &>>$LOG
sudo systemctl enable docker &>>$LOG
VALIDATE $? "systemctl enable docker" &>>$LOG

# Check if Docker installation was successful
if [ $? -eq 0 ]; 
then #docker Block
     figlet Jenkins
    sudo apt update -y &>>$LOG 
    VALIDATE $? "Updating apt"
    docker network create dwithi
    docker run -d --name jenkins --network=dwithi -p 8080:8080 jenkins/jenkins:lts &>>$LOG
    VALIDATE $? "Creating jenkins using docker image: jenkins/jenkins:lts "
    sleep 5
    docker ps -a

    echo "http//:"

        if [ $? -eq 0 ]; then # jenkins block
            sudo docker exec -d jenkins cat /var/jenkins_home/secrets/initialAdminPassword &>>$LOG1
            echo "jenkins adminpassword : " 
            sudo docker exec -d jenkins cat /var/jenkins_home/secrets/initialAdminPassword
            VALIDATE $? "cat /var/jenkins_home/secrets/initialAdminPassword"
            exit 0
        else # jenkins block
            echo "conatainer creation error"
            exit 1
        fi # jenkins block

        #--------------------------------sonarqube using docker------------------------------
        figlet SonarQube
        docker run -d --name sonarqube --network=dwithi -p 9000:9000 sonarqube:lts &>>$LOG
        VALIDATE $? "Creating sonarqube using docker image: sonarqube:lts"
        if [ $? -eq 0 ]; then # sonarqubeblock
            echo "sonarqube conatiner is created successfully"
            exit 0
        else # sonarqube block
            echo "conatainer creation error"
            exit 1
        fi # sonarqube block
    exit 0 # docker block
else # docker block
    echo "Docker installation failed"
    exit 1
fi # docker block

DOCKER_CONTAINERS(){
    #-----------------------------------Jenkins Using Docker--------------------------------
    figlet Jenkins
    sudo apt update -y &>>$LOG 
    VALIDATE $? "Updating apt"
    docker network create dwithi
    docker run -d --name jenkins --network=dwithi -p 8080:8080 jenkins/jenkins:lts &>>$LOG
    VALIDATE $? "Creating jenkins using docker image: jenkins/jenkins:lts "
    sleep 5
    docker ps -a

    echo "http//:"

        if [ $? -eq 0 ]; then # jenkins block
            sudo docker exec -d jenkins cat /var/jenkins_home/secrets/initialAdminPassword &>>$LOG1
            echo "jenkins adminpassword : " 
            sudo docker exec -d jenkins cat /var/jenkins_home/secrets/initialAdminPassword
            VALIDATE $? "cat /var/jenkins_home/secrets/initialAdminPassword"
            exit 0
        else # jenkins block
            echo "conatainer creation error"
            exit 1
        fi # jenkins block

        #--------------------------------sonarqube using docker------------------------------
        figlet SonarQube
        docker run -d --name sonarqube --network=dwithi -p 9000:9000 sonarqube:lts &>>$LOG
        VALIDATE $? "Creating sonarqube using docker image: sonarqube:lts"
        if [ $? -eq 0 ]; then # sonarqubeblock
            echo "sonarqube conatiner is created successfully"
            exit 0
        else # sonarqube block
            echo "conatainer creation error"
            exit 1
        fi # sonarqube block
}










