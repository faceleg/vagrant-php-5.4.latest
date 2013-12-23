class php54 {
  file { "/etc/apt/sources.list":
    ensure => file,
    owner => root,
    group => root,
    source => "/configuration/apt/sources.list",
  }
  exec { "import-gpg":
    command => "/usr/bin/wget -q http://www.dotdeb.org/dotdeb.gpg -O -| /usr/bin/apt-key add -"
  }

  exec { "/usr/bin/apt-get update":
    require => [File["/etc/apt/sources.list"], Exec["import-gpg"]],
  }

  /* package { [ */
  /*   "php5" */
  /* ] : */
  /*   ensure => latest, */
  /*   require => Exec["/usr/bin/apt-get update"] */
  /* } */
}
class { "php":
  /* version => "5.3.3-7+squeeze17", */
  source_dir => '/configuration/php/',
  source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
}

php::module { "mysql": }
php::module { "mcrypt": }
php::module { "gd": }
php::module { "curl": }

php::pear::module { "Zend":
  repository  => "zend.googlecode.com/svn",
  use_package => "no",
}

php::pecl::module { 'xdebug':
  use_package => "no",
}
