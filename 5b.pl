#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 5b.input") || die "Unable to open file: $!\n";

@input = <$fh>;


<<EOC
@input = (
"ABCDDdEefFdABC",
"dabAcCaCBAcCcaDA",
"dabBBbbbBBbAcCaCBAcCcaDA",
);
EOC
;
# Disable output buffering
$| = 1;

chomp($input[0]);
$inputPolymer = $input[0];

%chars = ();

for $lower ('a' ... 'z') {
    $upper = uc($lower);

    $polymer = $inputPolymer;
    $polymer =~ s/${lower}//g;
    $polymer =~ s/${upper}//g;

    $count = 0;
    $matched = 1;

    while ($matched == 1) {
        $matched = 0;
        while ($polymer =~ /(\w)\1/gi) {
            # Fetch the starting position of the match
            $pos = $-[0];

            # Extract substring
            $substr = substr($polymer, $pos, 2);

            # Check if substring is a correct match: Aa, not AA or aa
            if ($substr =~ m/($1)$1/) {
                # Only move next match 1 character to prevent 'ACCcB' from stepping from 'CC' to 'cB', thus missing 'Cc'
                pos($polymer) = pos($polymer) - 1;
                next;
            }

            # Replace match with whitespace
            substr($polymer, $pos, 2) = "  ";

            $matched = 1;
        }
        # Clean all whitespace
        $polymer =~ s/  //g;
    }
    $chars{$lower} = length($polymer);
}

foreach $char (sort { $chars{$a} <=> $chars{$b} } keys %chars) {
    print "Removing character: '$char' creates the smallest reduction: $chars{$char}\n";
    last;
}

