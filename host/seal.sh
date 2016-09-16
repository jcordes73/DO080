sudo groupadd student
sudo useradd -G docker -g student student
echo redhat | sudo passwd student --stdin
sudo cp student /etc/sudoers.d/student
