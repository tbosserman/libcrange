#!/usr/bin/perl -w

use warnings;
use strict;

use Test::More;
use FindBin;
use File::Temp;

my $config_base = "$FindBin::Bin/test_configs/non-sequence-yamlfile";
my $build_root = $ENV{DESTDIR};
my ($range_conf_fh, $range_conf) = File::Temp::tempfile();
warn "tmpfile: $range_conf";

#FIXME allow setting of lr->funcdir in range.conf
# to let me funcdir=$build_root/usr/lib/libcrange
# and remove other refs to $build_root
my $range_conf_data = qq{
dns_data_file=$config_base/etc/dns_data.tinydns
yst_ip_list=$config_base/etc/yst-ip-list
yaml_path=$config_base/rangedata
loadmodule $build_root/usr/lib/libcrange/yamlfile
loadmodule $build_root/usr/lib/libcrange/ip
loadmodule $build_root/usr/lib/libcrange/yst-ip-list
};

print $range_conf_fh $range_conf_data;


is(
    `crange -e -c $range_conf \@baz 2>&1`,
    qq{foo1.example.com\nfoo2.example.com\n},
    "\@baz # testing non-list yaml entries with dollar reference",
    );

is(
    `crange -e -c $range_conf \@baz2 2>&1`,
    qq{foo1.example.com\nfoo2.example.com\n},
    "\@baz # testing non-list yaml entries with dollar reference",
    );

done_testing();
