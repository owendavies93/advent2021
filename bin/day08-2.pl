#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use Array::Utils qw(intersect);
use List::MoreUtils qw(first_index);
use List::Util qw(first);

my $total = 0;

while (<>) {
    chomp;
    my ($input, $output) = /(.*)\s*\|\s*(.*)$/;
    my @signals = split / /, $input;

    my $one   = first { length == 2 } @signals;
    my $four  = first { length == 4 } @signals;
    my $seven = first { length == 3 } @signals;
    my $eight = first { length == 7 } @signals;

    my $nine = first {
        length == 6 && length intersect_chars($_, $four) == 4
    } @signals;

    my $zero = first {
        length == 6 && length intersect_chars($_, $seven) == 3 &&
        $_ ne $nine
    } @signals;

    my $six = first {
        length == 6 && $_ ne $zero && $_ ne $nine
    } @signals;

    my $five = first {
        length == 5 && length intersect_chars($_, $six) == 5
    } @signals;

    my $three = first {
        length == 5 && length intersect_chars($_, $four) == 3 &&
        $_ ne $five
    } @signals;

    my $two = first {
        length == 5 && $_ ne $five && $_ ne $three
    } @signals;

    my @res = map { normalise($_) } (
        $zero, $one, $two, $three, $four, $five,
        $six, $seven, $eight, $nine
    );

    my @o_sigs = map { normalise($_) } split ' ', $output;
    my $result = join '', map {
        my $s = $_;
        first_index { $_ eq $s } @res
    } @o_sigs;

    $total += $result;
}

say $total;

sub intersect_chars {
    my ($a, $b) = @_;
    my @sa = split '', $a;
    my @sb = split '', $b;
    return join '', intersect(@sa, @sb);
}

sub normalise {
    my $s = shift;
    return join '', sort { $a cmp $b } split '', $s;
}
