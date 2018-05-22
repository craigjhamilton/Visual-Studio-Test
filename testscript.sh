#!/bin/bash
#Give the user right to the /tmp folder
sudo chmod -R 777 /tmp

#Install Java
sudo apt-get -y install default-jre 

#Install Confluent Open Source Platform
wget -qO - https://packages.confluent.io/deb/4.0/archive.key  | sudo apt-key add - 
sudo add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/4.0  stable main"
sudo apt-get -y update && sudo apt-get -y install confluent-platform-oss-2.11

#Start the Confluent Platform
confluent start

#Install Maven
sudo apt-get -y install maven

#Install GIT and Clone GIT repo with Kafka Twitter Connector
sudo apt-get -y install git
cd /home/craig
git clone https://github.com/Eneco/kafka-connect-twitter.git

#Build the Jar files
cd /home/craig/kafka-connect-twitter
mvn package

#Update the Kafka config file to set the correct plugin path and rest API port
sudo mkdir -p /usr/local/share/kafka/plugins/kafka-connect-twitter 
sudo mv /home/craig/kafka-connect-twitter/target /usr/local/share/kafka/plugins/kafka-connect-twitter 

echo "#Set the plugin path" >> /home/craig/kafka-connect-twitter/connect-source-standalone.properties 
echo "plugin.path=/usr/local/share/kafka/plugins/kafka-connect-twitter" >> /home/craig/kafka-connect-twitter/connect-source-standalone.properties
echo "#Set the REST API port" >> /home/craig/kafka-connect-twitter/connect-source-standalone.properties
echo "rest.port=8084" >> /home/craig/kafka-connect-twitter/connect-source-standalone.properties

#Update the twitter connector properties file
cd /home/craig/kafka-connect-twitter
sudo cp twitter-source.properties.example twitter-source.properties
sed -i '/topic=test/c\topic=twitter' twitter-source.properties
sed -i '/twitter.consumerkey=/c\twitter.consumerkey=OyXUL6QBXa7e0Tq4oJrXQkZkl' twitter-source.properties
sed -i '/twitter.consumersecret=/c\twitter.consumersecret=SxYRuZYBnxb9QUGgKTe7iPOKeP9MEaDjMyc2cYjIMgcysE6a0c' twitter-source.properties
sed -i '/twitter.token=/c\twitter.token=717291305580126208-8u5eUBnXWmqMSrGpQ457UFNlmHCc3tG' twitter-source.properties
sed -i '/twitter.secret=/c\twitter.secret=hmZfo0GbLdTfv1dHnPlSAQ1zpJOJ6mqCA2nSt2VozWpm2' twitter-source.properties
sed -i '/# track.terms=news,music,hadoop,clojure,scala,fp,golang,python,fsharp,cpp,java/c\# track.terms=scala,databricks,java,kafka' twitter-source.properties
sed -i '/# language=en,ru,de/c\# language=en' twitter-source.properties

#Create the Kafka topic to write to 
cd /usr/bin
kafka-topics --zookeeper localhost:2181 --create --topic twitter --partitions 3 --replication- factor 1

#Start the connector
/usr/bin/connect-standalone /home/craig/kafka-connect-twitter/connect-source-standalone.properties /home/craig/kafka-connect-twitter/twitter-source.properties
