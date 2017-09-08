exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

package { ["openjdk-7-jre", "tomcat7", "mysql-server"]:
  ensure => installed,
  require => Exec["apt-update"]
}

exec { "download-vraptor-musicjungle":
  command => "/usr/bin/wget https://github.com/alura-cursos/provisionamento-com-vagrant-e-puppet/raw/master/manifests/vraptor-musicjungle.war -P /vagrant/manifests",
  unless => "/bin/cat /vagrant/manifests/vraptor-musicjungle.war"
}

service { "tomcat7":
  ensure => running,
  enable => true,
  hasstatus => true,
  hasrestart => true,
  require => Package["tomcat7"]
}

file { "/var/lib/tomcat7/webapps/vraptor-musicjungle.war":
  source => "/vagrant/manifests/vraptor-musicjungle.war",
  owner => "tomcat7",
  group => "tomcat7",
  mode => 0644,
  require => [ Exec["download-vraptor-musicjungle"], Package["tomcat7"] ],
  notify => Service["tomcat7"]
}

service { "mysql":
  ensure => running,
  enable => true,
  hasstatus => true,
  hasrestart => true,
  require => Package ["mysql-server"]
}

exec { "musicjungle":
  command => "mysqladmin -u root create musicjungle",
  unless => "mysql -u root musicjungle",
  path => "/usr/bin/",
  require => Service["mysql"]
}

exec { "usuario-senha":
  command => "mysql -uroot -e \"GRANT ALL PRIVILEGES ON * TO 'musicjungle'@'%' IDENTIFIED BY 'minha-senha';\" musicjungle",
  unless => "mysql -umusicjungle -pminha-senha musicjungle",
  path => "/usr/bin/",
  require => Exec["musicjungle"]
}

define file_line($file, $line) {
  exec { "/bin/echo '${line}' >> '${file}'":
    unless => "/bin/grep -qFx '${line}' '${file}'"
  }
}

file_line { "production":
  file =>"/bin/grep -qFx '${line}' '${file}'",
  line =>"JAVA_OPTS=\"\$JAVA_OPTS -Dbr.com.caelum.vraptor.environment=production\"",
  require => Package["tomcat7"],
  notify => Service["tomcat7"]
}
