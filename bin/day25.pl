#!/usr/bin/env perl
use Mojo::Base -strict;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day25';
$file = "inputs/day25-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $south = {};
my $east = {};

my $height = 0;
my $width;
while (<$fh>) {
    chomp;

    $width = 0;
    for (split //) {
        $south->{$width, $height} = 1 if $_ eq 'v';
        $east->{$width, $height} = 1  if $_ eq '>';
        $width++;
    }
    $height++;
}

my $steps = 0;
while (1) {
    $steps++;
    ($south, $east, my $moves) = step($south, $east);
    if ($moves == 0) {
        say $steps;
        exit;
    }
}

sub step {
    my ($south, $east) = @_;
    my $new_south = {};
    my $new_east = {};
    my $moves = 0;

    for my $e (keys %$east) {
        my ($x, $y) = split $;, $e;
        my ($nx, $ny) = next_pos($x, $y, 0);
        if (!exists $south->{$nx, $ny} && !exists $east->{$nx, $ny}) {
            $new_east->{$nx, $ny} = 1;
            $moves++;
        } else {
            $new_east->{$x, $y} = 1;
        }
    }

    $east = $new_east;

    for my $s (keys %$south) {
        my ($x, $y) = split $;, $s;
        my ($nx, $ny) = next_pos($x, $y, 1);
        if (!exists $south->{$nx, $ny} && !exists $east->{$nx, $ny}) {
            $new_south->{$nx, $ny} = 1;
            $moves++;
        } else {
            $new_south->{$x, $y} = 1;
        }
    }

    $south = $new_south;

    return ($south, $east, $moves);
}

sub next_pos {
    my ($x, $y, $south) = @_;

    if ($south) {
        return ($x, ($y + 1) % $height);
    } else {
        return (($x + 1) % $width, $y);
    }
}
