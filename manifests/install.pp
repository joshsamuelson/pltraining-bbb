# Install Big blue button
# This is mostly copied from the install script and could be cleaned up to remove all the execs
class bbb::install{
  # Make sure that we're on en_US.UTF-8
  package{ 'language-pack-en': 
    ensure => present
  }
  exec{'update locale': 
    command => 'update-locale LANG=en_US.UTF-8',
    path    => '/usr/sbin/',
    require => Package['language-pack-en']
  }

  # Install LibreOffice ppa
  package{ 'software-properties-common':
    ensure => present,
    before => Apt::Ppa['ppa:libreoffice/libreoffice-4-3']
  }
  apt::ppa { 'ppa:libreoffice/libreoffice-4-3':}

  # Add bigbluebutton key and apt repo
  exec{ 'add bbb key':
    command => 'wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -'
    path    => '/usr/bin',
  }
  exec{ 'add bbb repo':
    command => 'echo "deb http://ubuntu.bigbluebutton.org/trusty-090/ bigbluebutton-trusty main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list',
    path    => '/bin:/usr/bin',
    creates => '/etc/apt/srouces.list.d/bigbluebutton.list',
    require => Exec['add bbb key']
  }

  # Install ffmpeg
  package{[ 'build-essential',
            'git-core',
            'checkinstall',
            'yasm',
            'texi2html',
            'libvorbis-dev',
            'libx11-dev',
            'libvpx-dev',
            'libxfixes-dev',
            'zlib1g-dev',
            'pkg-config',
            'netcat',
            'libncurses5-dev']:
    ensure => present,
    before => Exec['install-ffmpeg.sh']
  }

  file{'/usr/local/bin/install-ffmpeg.sh':
    ensure => present,
    source => 'puppet:///modules/bbb/install-ffmpeg.sh',
    mode   => 755
  } 

  # This takes a really long time...
  exec{'install-ffmpeg.sh':
    path    => '/usr/local/bin/:/usr/bin/:/bin',
    timeout => 0,
    creates => '/usr/local/bin/ffmpeg',
    require => [File['/usr/local/bin/install-ffmpeg.sh'],Apt::Ppa['ppa:libreoffice/libreoffice-4-3']],
  }

  # Install BBB and restart
  package{'bigbluebutton':
    ensure  => present,
    require => [Exec['install-ffmpeg.sh'],Exec['add bbb repo']]
  }

  package{'bbb-check':
    ensure  => present,
    require => Package['bigbluebutton']
  }

  exec{'bbb clean restart':
    command => 'bbb-conf --clean'
    path    => '/usr/bin',
    require => Package['bbb-check'],
}
