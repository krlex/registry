$script = <<-SCRIPT
  bash <(curl -sL https://raw.githubusercontent.com/krlex/docker-installation/master/install.sh)
  curl -sfL https://get.k3s.io | sh -
  curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
  sudo mv kustomize /usr/local/bin
  sudo apt install -y net-tools
SCRIPT

Vagrant.configure('2') do |config|
  config.vm.define 'registry' do |registry|
    registry.vm.box = 'ubuntu/jammy64'
    registry.vm.hostname = 'registry'
    registry.vm.network 'private_network', type: 'dhcp'
    # registry.vm.provision 'file', source: '~/.ssh/id_rsa', destination: '~/.ssh/id_rsa'
    registry.vm.provision 'shell', inline: $script
    registry.vm.network 'forwarded_port', guest: 80, host: 8080

    registry.vm.provider :virtualbox do |v|
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--cpus', 4]
      v.customize ['modifyvm', :id, '--memory', 4096]
      v.customize ['modifyvm', :id, '--name', 'registry']
    end
  end
end
