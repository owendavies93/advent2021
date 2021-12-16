#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::Util qw(max min product sum);

my $rule_map = {
    0 => \&sum,
    1 => \&product,
    2 => \&min,
    3 => \&max,
    5 => sub {
        my ($a, $b) = @_;
        return $a > $b ? 1 : 0;
    },
    6 => sub {
        my ($a, $b) = @_;
        return $a < $b ? 1 : 0;
    },
    7 => sub {
        my ($a, $b) = @_;
        return $a == $b ? 1 : 0,
    }
};

my $hex = scalar(<>);
chomp($hex);
my @bits = map { split '', sprintf("%04b", hex($_)) } split '', $hex;

say get_value(\@bits);

sub get_value {
    my $bits = shift;

    take_num_bits($bits, 3);
    my $type = take_num_bits($bits, 3);
    return $type == 4 ? get_literal($bits) : run_rules($bits, $type);
}

sub get_literal {
    my $bits = shift;

    my $res = 0;
    while (scalar @$bits > 0) {
        my $prefix = shift @$bits;
        $res <<= 4;
        $res += take_num_bits($bits, 4);
        last if $prefix == 0;
    }

    return $res;
}

sub run_rules {
    my ($bits, $type) = @_;

    my $length_type_id = take_num_bits($bits, 1);
    my @sub_packets;

    if ($length_type_id == 1) {
        my $num_subs = take_num_bits($bits, 11);
        push @sub_packets, get_value($bits) for (1..$num_subs);
    } else {
        my $length = take_num_bits($bits, 15);
        my $remaining = abs($length - scalar @$bits);
        while (scalar @$bits > $remaining) {
            push @sub_packets, get_value($bits);
        }
    }

    return $rule_map->{$type}->(@sub_packets);
}

sub take_num_bits {
    my ($bits, $num) = @_;

    my $res = '';
    $res .= shift @$bits for (1..$num);
    return oct('0b' . $res);
}
