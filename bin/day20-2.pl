#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day20';
$file = 'inputs/day20-test' if $file eq 'test';
open(my $fh, '<', $file) or die $!;

my $width;
my $height = 0;

my @grid = ();
my $algo = scalar(<$fh>);
chomp($algo);
my @algo = map { $_ eq '#' ? 1 : 0 } split //, $algo;

while (<$fh>) {
    chomp;
    next if !$_;
    my @l = map { $_ eq '#' ? 1 : 0 } split //;
    $width = scalar @l if !defined $width;
    push @grid, @l;
    $height++;
}

step($_ % 2 == 0) for (1..50);

say scalar grep { $_ == 1 } @grid;

sub step {
    my $default = shift;
    extend_grid();
    my @cpy = @grid;
    for (my $i = 0; $i < scalar @grid; $i++) {
        my $bi = get_binary_index($i, $default);
        $cpy[$i] = ($algo[$bi] == $default);
    }
    @grid = @cpy;
}

sub get {
    my ($index, $default) = @_;
    if ($index >= 0 && $index < scalar @grid) {
        return $grid[$index] != $default;
    } else {
        return $default;
    }
}

sub neighbour_from_index {
    my $i = shift;

    my @cans = (
        $i - $width - 1, $i - $width, $i - $width + 1,
        $i - 1, $i, $i + 1,
        $i + $width - 1, $i + $width, $i + $width + 1
    );
    return @cans;
}

sub get_binary_index {
    my ($grid_index, $default) = @_;
    my @ns = neighbour_from_index($grid_index);
    my $nv = join '', map { get($_, $default) } @ns;
    return oct('0b' . $nv);
}

sub extend_grid {
    splice @grid, 0, 0, split //, 0 x $width;
    splice @grid, scalar @grid, 0, split //, 0 x $width;

    $height += 2;
    $width += 2;
    
    for (my $row = 0; $row < $height; $row++) {
        splice @grid, $row * $width, 0, 0;
        splice @grid, $row * $width + ($width - 1), 0, 0;
    }
}

