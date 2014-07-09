class { 'python':
  version => 'system',
  dev => true,
  virtualenv => true,
  pip => true
}

python::pip { 'pymongo':
  pkgname => 'pymongo',
}

python::pip { 'elasticsearch':
  pkgname => 'elasticsearch',
}

python::pip { 'pysolr':
  pkgname => 'pysolr'
}
