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
  
    config.vm.define "postfix" do |postfix|
      postfix.vm.box = "ubuntu/jammy64"
      postfix.vm.network "public_network", ip: "192.168.1.103"
      postfix.vm.hostname = "mail.dalvik.xyz"
      postfix.vm.provision "shell", path: "scripts/postfix_setup.sh"
    end
  
    config.vm.define "dovecot" do |dovecot|
      dovecot.vm.box = "ubuntu/jammy64"
      dovecot.vm.network "public_network", ip: "192.168.1.104"
      dovecot.vm.hostname = "pop.dalvik.xyz"
      dovecot.vm.provision "shell", path: "scripts/dovecot_setup.sh"
    end
  
    config.vm.define "http" do |http|
      http.vm.box = "ubuntu/jammy64"
      http.vm.network "public_network", ip: "192.168.1.105"
      http.vm.hostname = "web.dalvik.xyz"
      http.vm.provision "shell", path: "scripts/http_setup.sh"
    end
end
  