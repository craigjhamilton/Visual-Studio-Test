#Install Java
sudo apt-get install default-jre -y

#Install Maven
sudo apt install maven -y

#Install Confluent Open Source Platform
wget -qO - https://packages.confluent.io/deb/4.0/archive.key  | sudo apt-key add - 
sudo add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/4.0  stable main"
sudo apt-get update && sudo apt-get install confluent-platform-oss-2.11 -y

#Start the Confluent Platform
confluent start
