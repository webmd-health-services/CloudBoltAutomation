# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.ssh.username = "root"
  config.ssh.password = "cloudbolt"
  config.vm.define "cloudboltautomation" do |cb|
    cb.vm.hostname = "vagrant-cloudbolt"

    cb.vm.box = "http://downloads.cloudbolt.io/vagrant/cloudbolt-8.0.box"

    cb.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

    cb.vm.provider "virtualbox" do |vm|
      vm.memory = 4096
      vm.cpus = 2
      vm.gui = false
    end

  end

  config.trigger.after [:up, :resume] do |trigger|
    trigger.info = "Cloudbolt UI should be available at http://127.0.0.1:8080.  Confirm port mapping with 'vagrant port cloudboltautomation'."
  end

end
