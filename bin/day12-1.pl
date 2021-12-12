#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $edges = {};
while (<>) {
    chomp;
    my ($to, $from) = split /-/;
    push @{$edges->{$to}}, $from;
    push @{$edges->{$from}}, $to;
}

sub get_all_paths {
    my ($cur, $seen) = @_;

    return 1 if $cur eq 'end';

    local $seen->{$cur} = 1 if $cur =~ /^[a-z]/;
    
    my $paths = 0;
    for my $e (@{$edges->{$cur}}) {
        $paths += get_all_paths($e, $seen) if (!$seen->{$e});
    }

    return $paths;
}

say get_all_paths('start', {});
