#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use Array::Transpose;
use List::Util qw(sum);
use List::MoreUtils qw(natatime);

my @calls;
while (<>) {
    chomp;
    last if $_ eq '';
    @calls = split ',', $_;
}

my @cards;
my $locs = {};
my @current = ();
my $length = 5;
my $width = 5;
my $mark = -1;

my $current_card = 0;
my $i = 0;
while (<>) {
    chomp;
    if ($_ eq '') {
        my @tmp = @current;
        push @cards, \@tmp;
        $current_card++;
        $i = 0;
        @current = ();
    } else {
        push @current, split ' ', $_;
        for my $num (split ' ', $_) {
            $locs->{$num}->{$current_card} = $i;
            $i++;
        }
    }
}
push @cards, \@current;

for my $call (@calls) {
    foreach my $card (keys %{$locs->{$call}}) {
        my $index = $locs->{$call}->{$card};
        $cards[$card]->[$index] = $mark;
    }

    foreach my $card (@cards) {
        if (is_winning($card)) {
            say score($card) * $call;
            exit;
        } 
    } 
}

sub is_winning {
    my $card = shift;
    my $it = natatime $width, @$card;
 
    my @chunks;   
    while (my @row = $it->()) {
        push @chunks, \@row;
        return 1 if (sum @row) == $mark * $width;  
    }

    my @tr = transpose(\@chunks);
    foreach my $row (@tr) {
        return 1 if (sum @$row) == $mark * $length;
    }
    return 0;
}

sub score {
    my $card = shift;
    my @scoring = grep { $_ != $mark } @$card;
    return sum @scoring;
}

