#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::Util qw(sum);

my $hex = scalar(<>);
chomp($hex);

my @bits = map { split '', sprintf("%04b", hex($_)) } split '', $hex;

say get_version(\@bits);

sub get_version {
    my $bits = shift;

    my $ver  = take_num_bits($bits, 3);
    my $type = take_num_bits($bits, 3);

    if ($type == 4) {
        remove_literal($bits);
        return $ver;
    } else {
        return $ver + sum_subversions($bits);
    }
}

sub remove_literal {
    my $bits = shift;

    while (scalar @$bits > 0) {
        my $prefix = shift @$bits;
        take_num_bits($bits, 4);
        last if $prefix == 0;
    }
}

sub sum_subversions {
    my $bits = shift;

    my $length_type_id = take_num_bits($bits, 1);
    my @sub_versions;

    if ($length_type_id == 1) {
        my $num_subs = take_num_bits($bits, 11);
        push @sub_versions, get_version($bits) for (1..$num_subs);
    } else {
        my $length = take_num_bits($bits, 15);
        my $remaining = abs($length - scalar @$bits);
        while (scalar @$bits > $remaining) {
            push @sub_versions, get_version($bits);
        }
    }

    return sum @sub_versions;
}

sub take_num_bits {
    my ($bits, $num) = @_;

    my $res = '';
    $res .= shift @$bits for (1..$num);
    return oct('0b' . $res);
}
