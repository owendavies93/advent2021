#!/usr/bin/env perl
use Mojo::Base -strict;

use Algorithm::Combinatorics qw(combinations);
use Clone qw(clone);
use List::AllUtils qw(max);
use POSIX qw(ceil floor);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day18';
$file = "inputs/day18-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $counts = {};
my @lines = ();
while (<$fh>) {
    chomp;
    my $depth = 0;
    my @nums = ();
    for my $ch (split //, $_) {
        if ($ch eq '[') {
            $depth++;
        } elsif ($ch eq ']') {
            $depth--;
        } elsif ($ch =~ /\d/) {
            push @nums, [$ch, $depth];
        }
    }
    push @lines, \@nums;
}

my $max_mag = 0;
my $combs = combinations(\@lines, 2);
while (my $pair = $combs->next()) {
    my ($a, $b) = @$pair;
    my $x = clone($a);
    my $y = clone($b);
    my $mag = get_pair_mag($x, $y);
    $max_mag = $mag if $mag > $max_mag;

    my $v = clone($a);
    my $u = clone($b);
    $mag = get_pair_mag($v, $u);
    $max_mag = $mag if $mag > $max_mag;
}

say $max_mag;

sub get_pair_mag {
    my ($a, $b) = @_;
    for (my $i = 0; $i < scalar @$a; $i++) {
        $a->[$i][1]++;
    }

    for (my $i = 0; $i < scalar @$b; $i++) {
        $b->[$i][1]++;
    }

    my @nums = (@$a, @$b);
    my $nums = \@nums;
    my $explode = 1;
    my $split = 0;

    while ($explode || $split) {
        ($nums, $explode) = do_explode($nums);
        next if $explode;
        ($nums, $split) = do_split($nums);
    }

    return magnitude($nums);
}

sub magnitude {
    my $nums = shift;
    my @nums = @$nums;

    my $sum = 0;
    my $depth = max map { $_->[1] } @nums;

    while ($depth > 0) {
        my $i = 0;
        while ($i < $#nums) {
            my $num  = $nums[$i][0];
            my $d    = $nums[$i][1];
            my $next = $nums[$i + 1][0];
            my $nd   = $nums[$i + 1][1];
        
            if ($depth == $d && $d == $nd) {
                my $s = ((3 * $num) + (2 * $next));
                splice @nums, $i, 2, [$s, $depth - 1];
            }
            $i++;
        }
        $depth--;
    }

    return $nums[0][0];
}

sub do_explode {
    my $nums = shift;
    my @nums = @$nums;

    my $has_exploded = 0;
    for (my $i = 0; $i < $#nums; $i++) {
        my $num   = $nums[$i][0];
        my $depth = $nums[$i][1];
        my $next  = $nums[$i + 1][0];
        my $nd    = $nums[$i + 1][1];

        if ($depth > 4 && $nd == $depth) {
            if ($i > 0 && $i < $#nums - 1) {
                $nums[$i - 1][0] += $num;
                $nums[$i + 2][0] += $next;
                splice @nums, $i, 2, [0, $depth - 1];
            } elsif ($i == 0) {
                $nums[$i][0] = 0;
                $nums[$i][1] -= 1;
                $nums[$i + 2][0] += $next;
                splice @nums, $i + 1, 1;
            } elsif ($i == $#nums - 1) {
                $nums[$i + 1][0] = 0;
                $nums[$i + 1][1] -= 1;
                $nums[$i - 1][0] += $num;
                splice @nums, $i, 1;
            }
            $has_exploded = 1;
            last;
        }
    }

    return (\@nums, $has_exploded);
}

sub do_split {
    my $nums = shift;
    my @nums = @$nums;

    my $has_split = 0;
    for (my $i = 0; $i <= $#nums; $i++) {
        my $num   = $nums[$i][0];
        my $depth = $nums[$i][1];

        if ($num >= 10) {
            my $left = floor($num / 2);
            my $right = ceil($num / 2);
            splice @nums, $i, 1, ([$left, $depth + 1], [$right, $depth + 1]);
            $has_split = 1;
            last;
        }
    }

    return (\@nums, $has_split);
}
