#!/usr/bin/env perl
use Mojo::Base -strict;

use List::Util qw(max min);
use Memoize;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day24';
open(my $fh, '<', $file) or die $!;

my @a;
my @b;
my @tmp;

while(<$fh>) {
    if (/add x (-?\d+)/) {
        push @a, $1;
    } elsif (/div z (-?\d+)/) {
        push @b, $1;
    } elsif (/add y (-?\d+)/) {
        push @tmp, $1;
    }
}

my @c;
for (my $i = 0; $i < scalar @tmp; $i++) {
    push @c, $tmp[$i] if $i % 3 == 2;
}

sub step {
    my ($index, $prev_z, $prev_w) = @_;

    my $x = ($prev_z % 26) + $a[$index];
    $x = int($x != $prev_w);
    my $z = int($prev_z / $b[$index]);
    $z *= ((25 * $x) + 1);
    $z += ($prev_w + $c[$index]) * $x;
    return $z;
}

sub solve {
    my ($index, $prev_z) = @_;

    return [''] if $index == 14 && $prev_z == 0;
    return []   if $index == 14 || $prev_z > 10_000_000;

    my $x = $a[$index] + $prev_z % 26;

    my @res = ();
    for my $w (1..9) {
        my $z = step($index, $prev_z, $w);
        my $next = solve($index + 1, $z);
        push @res, $w . $_ for @$next;
    }
    return \@res;
}

memoize('solve');

my $solutions = solve(0, 0);
say max @$solutions;
say min @$solutions;

