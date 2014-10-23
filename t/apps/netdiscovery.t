#!/usr/bin/perl

use strict;
use warnings;

use English qw(-no_match_vars);
use IPC::Run qw(run);

use Test::More tests => 12;

use FusionInventory::Agent::Task::NetDiscovery;

my ($out, $err, $rc);

($out, $err, $rc) = run_netdiscovery('--help');
ok($rc == 0, '--help exit status');
like(
    $out,
    qr/^Usage:/,
    '--help stdout'
);
is($err, '', '--help stderr');

($out, $err, $rc) = run_netdiscovery('--version');
ok($rc == 0, '--version exit status');
is($err, '', '--version stderr');
like(
    $out,
    qr/$FusionInventory::Agent::Task::NetDiscovery::VERSION/,
    '--version stdin'
);

($out, $err, $rc) = run_netdiscovery();
ok($rc == 2, 'no first address exit status');
like(
    $err,
    qr/no first address/,
    'no target stderr'
);
is($out, '', 'no target stdout');

($out, $err, $rc) = run_netdiscovery('--first 192.168.0.1');
ok($rc == 2, 'no last address exit status');
like(
    $err,
    qr/no last address/,
    'no target stderr'
);
is($out, '', 'no target stdout');

sub run_netdiscovery {
    my ($args) = @_;
    my @args = $args ? split(/\s+/, $args) : ();
    run(
        [ $EXECUTABLE_NAME, 'fusioninventory-netdiscovery', @args ],
        \my ($in, $out, $err)
    );
    return ($out, $err, $CHILD_ERROR >> 8);
}
