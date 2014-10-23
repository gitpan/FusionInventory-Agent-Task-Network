#!/usr/bin/perl

use strict;
use warnings;

use English qw(-no_match_vars);
use IPC::Run qw(run);

use Test::More tests => 9;

my ($out, $err, $rc);

($out, $err, $rc) = run_netinventory('--help');
ok($rc == 0, '--help exit status');
like(
    $out,
    qr/^Usage:/,
    '--help stdout'
);
is($err, '', '--help stderr');

($out, $err, $rc) = run_netinventory();
ok($rc == 2, 'no model exit status');
like(
    $err,
    qr/no model/,
    'no target stderr'
);
is($out, '', 'no target stdout');

($out, $err, $rc) = run_netinventory("--model foobar");
ok($rc == 2, 'invalid model exit status');
like(
    $err,
    qr/invalid model file/,
    'no target stderr'
);
is($out, '', 'no target stdout');

sub run_netinventory {
    my ($args) = @_;
    my @args = $args ? split(/\s+/, $args) : ();
    run(
        [ $EXECUTABLE_NAME, 'fusioninventory-netinventory', @args ],
        \my ($in, $out, $err)
    );
    return ($out, $err, $CHILD_ERROR >> 8);
}
