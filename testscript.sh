#Install Java
sudo apt-get install default-jre -y

#Install Maven
sudo apt install maven -y

#Install Confluent Open Source Platform
wget -qO - https://packages.confluent.io/deb/4.0/archive.key  | sudo apt-key add - 
sudo add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/4.0  stable main"
sudo apt-get update 
sudo apt-get install confluent-platform-oss-2.11 -y

#Start the Confluent Platform
confluent start

#Install GIT and Clone GIT repo with Kafka Twitter Connector
sudo apt-get install git
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
echo "rest.port=8084"

#Update the twitter connector properties file
cd /home/craig/kafka-connect-twitter
sed -i '/topic=test/c\topic=twitter' twitter-source.properties
sed -i '/twitter.consumerkey=/c\twitter.consumerkey=' twitter-source.properties
sed -i '/twitter.consumersecret=/c\twitter.consumersecret=SxYRuZYBnxb9QUGgKTe7iPOKeP9MEaDjMyc2cYjIMgcysE6a0c' twitter-source.properties
sed -i '/twitter.token=/c\twitter.token=717291305580126208-8u5eUBnXWmqMSrGpQ457UFNlmHCc3tG' twitter-source.properties
sed -i '/twitter.secret=/c\twitter.secret=hmZfo0GbLdTfv1dHnPlSAQ1zpJOJ6mqCA2nSt2VozWpm2' twitter-source.properties
