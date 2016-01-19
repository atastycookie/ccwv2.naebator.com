#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use lib './lib';

use DB;
use Device;
use YAML::XS qw(LoadFile);
### read config ###
my $config = LoadFile('./etc/conf.yml');
###################

### conn to db ###
my $db_obj = new DB;
my $dbh = $db_obj->connect($config->{db});
##################

### devices obj ###
my $device_obj = new Device( { dbh => $dbh, conf => $config } );

###  паралелим
while (1) {
    my $devices = $device_obj->list();
    foreach my $device ( @{$devices} ){
        `perl ./rc.d/start.pl $device->{id} &`;
    }
    sleep 20;
}