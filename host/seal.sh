sudo groupadd student
sudo useradd -G docker -g student student
echo redhat | sudo passwd student --stdin
sudo cp /vagrant/student /etc/sudoers.d/student
