sudo yum update -y
sudo yum install docker -y
sudo yum install git -y
sudo systemctl enable docker
sudo docker version
usermod -a -G docker $(whoami)
