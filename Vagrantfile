# -*- mode: ruby -*-
# vi: set ft=ruby :

boxes = [
  { :name => :graphite,:ip    => '192.168.33.105',:ssh_port => 2205,:cpus => 2,:mem => 2048,:role => 'graphite.pp' },
]

Vagrant.configure(2) do |config|
  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
    config.vm.box  = "boxcutter/centos71"
    config.vm.network "private_network", ip: opts[:ip]
    config.vm.hostname = ENV['VAGRANT_HOSTNAME'] || opts[:name].to_s.downcase.gsub(/_/, '-').concat(".dev.local")
    config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpus", opts[:cpus] ] if opts[:cpus]
    vb.customize ["modifyvm", :id, "--memory", opts[:mem] ] if opts[:mem]
    vb.customize ["modifyvm", :id, "--natnet1", "10.0.2.0/24"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
   end
    # config.vm.provision "shell",
    #   inline: "rpm -ih --quiet https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm && yum -y -q install puppet"
    config.vm.provision :puppet do |puppet|
      puppet.module_path = 'modules'
      puppet.options     = [
        '--verbose',
        '--report',
        '--show_diff',
        '--pluginsync',
        #'--summarize',
        '--disable_warnings deprecations',
      ]
    end
  end
  end
end
