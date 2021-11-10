#!/bin/bash
export jenkins_endpoint=`terraform output jenkins_endpoint | cut -d '"' -f 2`
export JENKINS_USER_ID="admin"
export JENKINS_API_TOKEN=`ssh -i ~/.ssh/id_rsa yurii@${jenkins_endpoint} sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

# Remote execute

ssh -i ~/.ssh/id_rsa yurii@${jenkins_endpoint} sudo wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.11.1/jenkins-plugin-manager-2.11.1.jar
scp plugins.txt yurii@${jenkins_endpoint}:~
#ssh -i ~/.ssh/id_rsa yurii@${jenkins_endpoint} sudo mkdir -p /var/lib/jenkins/plugins
echo "Starting install plugins"
ssh -i ~/.ssh/id_rsa yurii@${jenkins_endpoint} sudo java -jar jenkins-plugin-manager-*.jar --war /usr/share/jenkins/jenkins.war --plugin-file ~/plugins.txt -d /var/lib/jenkins/plugins/
echo "Plugins installed"
ssh -i ~/.ssh/id_rsa yurii@${jenkins_endpoint} sudo chown jenkins:jenkins -R /var/lib/jenkins
ssh -i ~/.ssh/id_rsa yurii@${jenkins_endpoint} sudo systemctl restart jenkins.service


# Local execute
sleep 120
wget http://${jenkins_endpoint}:8080/jnlpJars/jenkins-cli.jar
java -jar `pwd`/jenkins-cli.jar -s http://${jenkins_endpoint}:8080 who-am-i
