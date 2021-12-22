#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day22';
$file = "inputs/day22-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $on = {};

while (<$fh>) {
    chomp;
    my ($state) = split ' ';
    my ($minx, $maxx, $miny, $maxy, $minz, $maxz) = m/(-?\d+)/g;

    next unless ($minx > -50 && $maxx < 50) &&
                ($miny > -50 && $maxy < 50) &&
                ($minz > -50 && $maxz < 50);

    for my $x ($minx..$maxx) {
        for my $y ($miny..$maxy) {
            for my $z ($minz..$maxz) {
                if ($state eq 'on') {
                    $on->{$x,$y,$z} = 1;
                } else {
                    delete $on->{$x,$y,$z};
                }
            }
        }
    }
}

say scalar keys %$on;
