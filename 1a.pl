#!/usr/bin/perl

open($fh, "< 1.input") || die "Unable to open file: $!\n";

@input = <$fh>;

$sum = 0;
foreach $i (@input) {
    chomp($i);
    $sum += int($i);
}

print "Sum: $sum\n";

