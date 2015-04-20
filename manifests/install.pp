# Install Big blue button
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

  # Multiverse installed by default

  # Install LibreOffice ppa
  package{ 'software-properties-common':
    ensure => present,
    before => Apt::Ppa['ppa:libreoffice/libreoffice-4-3']
  }

  apt::ppa { 'ppa:libreoffice/libreoffice-4-3': }

  # Add bigbluebutton key and apt repo
  exec{ 'wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -':
    path   => '/usr/bin',
  }

  apt::source { 'bigbluebutton':
    location   => 'http://ubuntu.bigbluebutton.org/trusty-090/',
    repos      => 'bigbluebutton-trusty main',
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

  exec{'install-ffmpeg.sh':
    path    => '/usr/local/bin/:/usr/bin/:/bin',
    require => File['/usr/local/bin/install-ffmpeg.sh'],
  }
}
