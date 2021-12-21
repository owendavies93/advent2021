#!/usr/bin/env perl
use Mojo::Base -strict;

use List::Util qw(max);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day21';
$file = 'inputs/day21-test' if $file eq 'test';
open(my $fh, '<', $file) or die $!;

my ($space1) = scalar (<$fh>) =~ /: (\d)$/;
my ($space2) = scalar (<$fh>) =~ /: (\d)$/;

my $jescache = {};

sub count_subwins {
    my $k = jeskey(@_);
    return @{$jescache->{$k}} if exists $jescache->{$k};

    my ($rolls, $space1, $score1, $space2, $score2) = @_;

    if ($rolls == 0) {
        $score1 += $space1;
        return (1, 0) if $score1 >= 21;

        my ($wins2, $wins1) =
            count_subwins(3, $space2, $score2, $space1, $score1);

        $k = jeskey(3, $space2, $score2, $space1, $score1);
        @{$jescache->{$k}} = ($wins2, $wins1);

        return ($wins1, $wins2);
    } else {
        my $wins1 = 0;
        my $wins2 = 0;

        for my $roll (1..3) {
            my $start = (($space1 - 1 + $roll) % 10) + 1;
            my ($sub_wins1, $sub_wins2) =
                count_subwins($rolls - 1, $start, $score1, $space2, $score2);

            $k = jeskey($rolls - 1, $start, $score1, $space2, $score2);
            @{$jescache->{$k}} = ($sub_wins1, $sub_wins2);

            $wins1 += $sub_wins1;
            $wins2 += $sub_wins2;
        }

        return ($wins1, $wins2);
    }
}

sub jeskey {
    return join '', @_;
}

say max(count_subwins(3, $space1, 0, $space2, 0));

