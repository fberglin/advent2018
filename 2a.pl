#!/usr/bin/perl

open($fh, "< 2.input") || die "Unable to open file: $!\n";

@input = <$fh>;

# @input = ( "abcdef", "bababc", "abbcde", "abcccd", "abcccd", "abcdee", "ababab" );

$twos = 0;
$threes = 0;

foreach $id (@input) {
    chomp($id);
    @letters = split(//, $id);

    %frequency = ();
    foreach $letter (@letters) {
        if (not defined $frequency{$letter}) {
            $frequency{$letter} = 1;
        } else {
            $frequency{$letter}++;
        }
    }

    $foundTwo = 0;
    $foundThree = 0;
    foreach $letter (keys(%frequency)) {
        if ($frequency{$letter} == 2 and $foundTwo == 0) {
            $foundTwo = 1;
            $twos++;
        } elsif ($frequency{$letter} == 3 and $foundThree == 0) {
            $foundThree = 1;
            $threes++;
        }
    }
}

print "$twos * $threes = ", $twos * $threes, "\n";


