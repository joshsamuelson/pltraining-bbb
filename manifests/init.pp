# == Class: bbb
#
# Setup and installation of bigbluebutton 0.9.0.
#
# === Parameters
#
#
# === Variables
#
#
# === Examples
#
# include bbb
#
# === Authors
#
# Josh Samuelson <js@puppetlabs.com>
#
# === Copyright
#
# Copyright 2015 PuppetLabs, unless otherwise noted.
#
class bbb {
  if $::operatingsystemrelease == '14.04'{
    include apt
    include bbb::install
  }
}
