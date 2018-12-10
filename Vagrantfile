# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/xenial64'

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = '256'
  end

  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y build-essential
    sudo apt-get install -y git
    sudo apt-get install -y gcc-avr avr-libc avrdude libtool texinfo elfutils
    sudo apt-get install -y libglu1-mesa-dev freeglut3-dev gdb-avr libelf-dev
    git clone https://github.com/buserror/simavr /tmp/simavr
    cd /tmp/simavr
    sudo make install RELEASE=1
  SHELL
end
