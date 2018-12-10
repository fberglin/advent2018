#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 5.input") || die "Unable to open file: $!\n";

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
$polymer = $input[0];

$count = 0;
$matched = 1;

while ($matched == 1) {
    $matched = 0;
    while ($polymer =~ /(\w)\1/gi) {
        if ($count++ % 10000 == 0) {
            print ".";
        }

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

print "\n";
print "Count: $count. Resulting polymer: '$polymer'. Length: ", length($polymer), "\n";

print "Writing result as 5b.input\n";

open($fh, "> 5b.input") || die "Unable to open file: $!\n";
print $fh $polymer;
close($fh);

print "Done.\n";

