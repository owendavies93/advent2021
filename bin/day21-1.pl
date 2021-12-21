#!/usr/bin/env perl
use Mojo::Base -strict;

use List::Util qw(min);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day21';
$file = 'inputs/day21-test' if $file eq 'test';
open(my $fh, '<', $file) or die $!;

my ($space1) = scalar (<$fh>) =~ /: (\d)$/;
my ($space2) = scalar (<$fh>) =~ /: (\d)$/;

my $score1 = 0;
my $score2 = 0;
my $roll = 0;
my $total = 0;

while ($score1 < 1000 && $score2 < 1000) {
    ($score1, $roll, $space1) = do_turn($score1, $roll, $space1);
    $total += 3;

    last if $score1 >= 1000;

    ($score2, $roll, $space2) = do_turn($score2, $roll, $space2);
    $total += 3;
}

say $total * min($score1, $score2);

sub do_turn {
    my ($score, $roll, $start) = @_;

    my $sum = ($roll + 1) + ($roll + 2) + ($roll + 3);
    $start = (($start - 1 + $sum) % 10) + 1;

    return ($score + $start, ($roll + 3) % 100, $start);
}
