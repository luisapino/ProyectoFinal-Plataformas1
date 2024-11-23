Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
  
    config.vm.define "dns" do |dns|
      dns.vm.box = "ubuntu/jammy64"
      dns.vm.network "public_network", ip: "192.168.1.102"
      dns.vm.hostname = "dns.dalvik.xyz"
      dns.vm.provision "shell", path: "scripts/dns_setup.sh"
    end
  
    config.vm.define "email" do |email|
      email.vm.box = "ubuntu/jammy64"
      email.vm.network "public_network", ip: "192.168.1.103"
      email.vm.hostname = "mail.dalvik.xyz"
      email.vm.provision "shell", path: "scripts/email_setup.sh"
    end
  
    config.vm.define "http" do |http|
      http.vm.box = "ubuntu/jammy64"
      http.vm.network "public_network", ip: "192.168.1.104"
      http.vm.hostname = "web.dalvik.xyz"
      http.vm.provision "shell", path: "scripts/http_setup.sh"
    end
end
  