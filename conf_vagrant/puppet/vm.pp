stage { 'pre':
  before => Stage['main']
}

class { 'base_config':
  stage => 'pre'
}

class base_config {
  case $operatingsystem {
    debian: {
      exec { "/usr/bin/apt-get update": }
    }
  }
}
include base_config

class { 'python':
  version => 'system',
  dev => true,
  virtualenv => true,
  pip => true
}

class python_wheel {
  require python
  exec { "/usr/bin/pip install wheel": }
}

class python_packages {
  require python_wheel

  python::pip { 'pymongo':
    pkgname => 'pymongo',
  }

  python::pip { 'elasticsearch':
    pkgname => 'elasticsearch',
  }

  python::pip { 'pysolr':
    pkgname => 'pysolr'
  }
}

include python_wheel
include python_packages

class home_symlinks {
  exec { "/bin/ln -fs /xdots /home/vagrant/xdots || true": }
  exec { "/bin/ln -fs /coding /home/vagrant/coding || true": }
}

class xdots_setup {
  require home_symlinks
  exec { "/bin/su vagrant -c /home/vagrant/xdots/linux_setup": }
}
include xdots_setup
