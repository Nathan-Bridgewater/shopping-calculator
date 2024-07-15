#!/bin/sh
sudo yum update -y
sudo yum install docker -y
sudo yum install git -y
sudo systemctl start docker
sudo docker version
sudo usermod -a -G docker $(whoami)
git clone https://github.com/Nathan-Bridgewater/shopping-calculator.git
cd shopping-calculator/ui
sudo docker build . -t flask
sudo docker run -p 8080:5000 flask
echo 'FINISHED'
