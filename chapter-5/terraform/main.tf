terraform {
  required_version = ">= 1.0"
}

# Generate Vagrantfile with Terraform
resource "local_file" "vagrantfile" {
  filename = "${path.module}/../Vagrantfile"
  content  = <<-EOF
    Vagrant.configure("2") do |config|
      # Web server 1
      config.vm.define "web1" do |web|
        web.vm.box = "ubuntu/focal64"
        web.vm.hostname = "web1"
        web.vm.network "private_network", ip: "192.168.56.10"
        web.vm.provider "virtualbox" do |vb|
          vb.memory = "1024"
          vb.cpus = 1
        end
      end

      # Web server 2
      config.vm.define "web2" do |web|
        web.vm.box = "ubuntu/focal64"
        web.vm.hostname = "web2"
        web.vm.network "private_network", ip: "192.168.56.11"
        web.vm.provider "virtualbox" do |vb|
          vb.memory = "1024"
          vb.cpus = 1
        end
      end

      # Load balancer
      config.vm.define "lb" do |lb|
        lb.vm.box = "ubuntu/focal64"
        lb.vm.hostname = "loadbalancer"
        lb.vm.network "private_network", ip: "192.168.56.20"
        lb.vm.network "forwarded_port", guest: 80, host: 8080
        lb.vm.provider "virtualbox" do |vb|
          vb.memory = "512"
          vb.cpus = 1
        end
      end
    end
  EOF
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content  = <<-EOF
    [webservers]
    web1 ansible_host=192.168.56.10 ansible_user=vagrant ansible_ssh_private_key_file=../.vagrant/machines/web1/virtualbox/private_key
    web2 ansible_host=192.168.56.11 ansible_user=vagrant ansible_ssh_private_key_file=../.vagrant/machines/web2/virtualbox/private_key

    [loadbalancer]
    lb ansible_host=192.168.56.20 ansible_user=vagrant ansible_ssh_private_key_file=../.vagrant/machines/lb/virtualbox/private_key

    [all:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOF
}

output "next_steps" {
  value = <<-EOF
    
    ✅ Infrastructure files created!
    
    Next steps:
    1. cd ..
    2. vagrant up
    3. cd ansible
    4. ansible-playbook -i inventory.ini site.yml
  EOF
}