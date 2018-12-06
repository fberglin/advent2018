#!/usr/bin/perl

open($fh, "< 2.input") || die "Unable to open file: $!\n";

@input = <$fh>;

# @input = ( "abcdef", "bababc", "abbcde", "abcccd", "abcccd", "abcdee", "ababab" );

$twos = 0;
$threes = 0;

for $ixThis (0 ... scalar(@input)-1) {
    for $ixThat ($ixThis+1 ... scalar(@input)-1) {
        chomp($input[$ixThis]);
        chomp($input[$ixThat]);

        @lettersThis = split(//, $input[$ixThis]);
        @lettersThat = split(//, $input[$ixThat]);

        $unmatchedLetters = 0;
        for $i (0 ... scalar(@lettersThis-1)) {
            if ($lettersThis[$i] ne $lettersThat[$i]) {
                $unmatchedLetters++;
                $ixUnmatched = $i;
            }
        }

        if ($unmatchedLetters == 1) {
            print "$ixThis: $input[$ixThis], $ixThat: $input[$ixThat]: $ixUnmatched\n";

            print "Letters in common: ";
            for $i (0 ... scalar(@lettersThis-1)) {
                if ($ixUnmatched != $i) {
                    print $lettersThis[$i];
                }
            }
            print "\n";

            exit;
        }
    }
}

