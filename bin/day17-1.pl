#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day17';
$file = 'inputs/day17-test' if $file eq 'test';
open(my $fh, '<', $file) or die $!;
my $area = scalar <$fh>;

my ($tx1, $tx2, $ty1, $ty2) = $area =~ /(-?\d+)/g;

my $maxy = 0;
for my $initvx (0..$tx2) {
    for my $initvy ($ty1..abs($ty1)) {
        my $x = 0;
        my $y = 0;
        my $vx = $initvx;
        my $vy = $initvy;
        my $candidate = 0;
        my $max_this_run = 0;
        
        do {
            ($x, $y, $vx, $vy) = step($x, $y, $vx, $vy);
            $candidate = 1 if in($x, $y, $tx1, $tx2, $ty1, $ty2);
            $max_this_run = $y if $y > $max_this_run;
        } while (!gone($x, $y, $tx1, $tx2, $ty1, $ty2, $vx));

        if ($candidate == 1 && $max_this_run > $maxy) {
            $maxy = $max_this_run;
        }
    }
}

say $maxy;

sub step {
    my ($x, $y, $vx, $vy) = @_;
    
    $x += $vx;
    $y += $vy;
    $vx++ if ($vx < 0);
    $vx-- if ($vx > 0);
    $vy--;

    return ($x, $y, $vx, $vy);
}

sub in {
    my ($x, $y, $tx1, $tx2, $ty1, $ty2) = @_;
    return $x >= $tx1 && $x <= $tx2 && $y >= $ty1 && $y <= $ty2;
}

sub gone {
    my ($x, $y, $tx1, $tx2, $ty1, $ty2, $vx) = @_;
    return $y < $ty1 || ($vx == 0 && ($x < $tx1 || $x > $tx2));
}
