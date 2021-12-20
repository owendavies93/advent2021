#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day20';
$file = 'inputs/day20-test' if $file eq 'test';
open(my $fh, '<', $file) or die $!;

my $width;
my $height = 0;

my $grid = {};
my $algo = scalar(<$fh>);
chomp($algo);
my @algo = map { $_ eq '#' ? 1 : 0 } split //, $algo;

while (<$fh>) {
    chomp;
    next if !$_;
    $width = 0;
    for (split //) {
        $grid->{$width,$height} = $_ eq '#' ? 1 : 0;
        $width++;
    }
    $height++;
}

my $minx = 0;
my $miny = 0;
my $maxx = $width - 1;
my $maxy = $height - 1;

step($_ % 2 == 0) for (1..50);

say scalar keys %$grid;

sub step {
    my $default = shift;
    my $next_grid = {};
    $minx -= 1;
    $maxx += 1;
    $miny -= 1;
    $maxy += 1;

    for my $y ($miny..$maxy) {
        for my $x ($minx..$maxx) {
            my $bi = get_binary_index($x, $y, $default);
            $next_grid->{$x,$y}++ if $algo[$bi] == $default;
        }
    }
    $grid = $next_grid;
}

sub get {
    my ($x, $y) = @_;
    return $grid->{$x, $y} // 0;
}

sub neighbours {
    my @ns = ();
    for my $y (-1..1) {
        for my $x (-1..1) {
            push @ns, [$x, $y];
        }
    }
    return @ns;
}

sub get_binary_index {
    my ($x, $y, $default) = @_;

    my $nv = join '', map {
        my ($dx, $dy) = @$_;
        get($x + $dx, $y + $dy);
    } neighbours();

    $nv =~ tr/10/01/ if $default;
    return oct('0b' . $nv);
}

