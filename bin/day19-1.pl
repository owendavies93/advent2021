#!/usr/bin/env perl
use Mojo::Base -strict;

use Algorithm::Combinatorics qw(
    combinations
    permutations
    variations_with_repetition
);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day19';
$file = "inputs/day19-$file" if $file =~ 'test';
open(my $fh, '<', $file) or die $!;

my $scanners = {};
my $beacons = {};
my $cur = 0;
while (<$fh>) {
    chomp;
    next if !$_;

    if ($_ =~ /scanner (\d+)/) {
        $cur = $1;
        next;
    }

    my @coords = split ',', $_;
    push @{$scanners->{$cur}}, [@coords];
}

my $vars = variations_with_repetition([-1, 1], 3);
my @indices = permutations([0, 1, 2]);
my @rotations = ();
while (my $v = $vars->next()) {
    push @rotations, [@$_, @$v] for @indices;
}

for my $coord (@{$scanners->{0}}) {
    add_beacon($coord->[0], $coord->[1], $coord->[2]);
}

delete $scanners->{0};

while (scalar keys %$scanners > 0) {
    my ($found_id, $beacon_coords) = find_match($scanners);
    add_beacon($_->[0], $_->[1], $_->[2]) for (@$beacon_coords);
    delete $scanners->{$found_id};
}

say scalar keys %$beacons;

sub find_match {
    my $scanners = shift;
    for my $i (keys %$scanners) {
        my $scanned_coords = $scanners->{$i};
        for my $rot (@rotations) {
            my @transformed_coords = map { [
                $_->[$rot->[0]] * $rot->[3],
                $_->[$rot->[1]] * $rot->[4],
                $_->[$rot->[2]] * $rot->[5],
            ] } @$scanned_coords;

            for my $k (keys %$beacons) {
                my @beacon_coords = split /,/, $k;

                for my $c (@transformed_coords) {
                    my @offsets = vector_sub(\@beacon_coords, $c);

                    my $matched = grep {
                        get_beacon(vector_sum($_, \@offsets))
                    } @transformed_coords;

                    if ($matched >= 12) {
                        say "Found Scanner $i";
                        my @final_coords = map {
                            [vector_sum($_, \@offsets)]
                        } @transformed_coords;
                        return ($i, \@final_coords);
                    }
                }
            }
        }
    }
}


sub get_beacon {
    my ($x, $y, $z) = @_;
    my $k = key($x, $y, $z);
    return $beacons->{$k};
}

sub add_beacon {
    my ($x, $y, $z) = @_;
    my $k = key($x, $y, $z);
    $beacons->{$k} = 1;
}

sub vector_sum {
    my ($v1, $v2) = @_;
    return ($v1->[0] + $v2->[0], $v1->[1] + $v2->[1], $v1->[2] + $v2->[2]);
}

sub vector_sub {
    my ($v1, $v2) = @_;
    return ($v1->[0] - $v2->[0], $v1->[1] - $v2->[1], $v1->[2] - $v2->[2]);
}

sub key {
    my ($x, $y, $z) = @_;
    return join ',', ($x, $y, $z);
}

