$pre_commands = []
def pre_shell(*args)
  $pre_commands.push(args.join('&&'))
end

$commands = []
def shell(*args)
  $commands.push(args.join(' && '))
end

def provision(config)
  config.vm.synced_folder "~/coding", "/coding"
  config.vm.synced_folder "~/xdots", "/xdots"

  mods = []
  mods.push("puppetlabs-stdlib")
  mods.push("stankevich-python")

  config.vm.provision :shell do |shell|
    shell.inline = "mkdir -p /etc/puppet/modules"
    mods.each {|x|
      shell.inline += "&& (puppet module install " + x
      shell.inline += "|| puppet module upgrade " + x + ")"
    }
  end

  $pre_commands.each do |command|
    config.vm.provision :shell do |shell|
      shell.inline = command
    end
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifest_file = "vm.pp"
    puppet.manifests_path = "../../puppet"
  end

  $commands.each do |command|
    config.vm.provision :shell do |shell|
      shell.inline = command
    end
  end
end

# puppet/local.rb
begin
  load '../../puppet/local.rb'
rescue Exception
end

# os/local.rb
begin
  load 'local.rb'
rescue Exception
end
