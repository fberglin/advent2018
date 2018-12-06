#!/usr/bin/perl

open($fh, "< 3.input") || die "Unable to open file: $!\n";

@input = <$fh>;

<<EOC
@input = ( "#1 @ 1,3: 4x4",
           "#2 @ 3,1: 4x4",
           "#3 @ 5,5: 2x2" );
EOC
;

%grid = ();

foreach $claim (@input) {
    chomp($claim);
    if (not $claim =~ m/#\d+ @ (\d+),(\d+): (\d+)x(\d+)/) {
        print "Unknown pattern: '$claim'. Exiting.\n";
        exit;
    }

    $xStart = $1;
    $yStart = $2;
    $xSize = $3;
    $ySize = $4;

    foreach $x ($xStart ... $xStart + $xSize - 1) {
        foreach $y ($yStart ... $yStart + $ySize - 1) {
            if (defined($grid{"$x,$y"})) {
                $grid{"$x,$y"}++;
            } else {
                $grid{"$x,$y"} = 1;
            }
        }
    }
}

$sharedClaims = 0;
foreach $coord (keys %grid) {
    if ($grid{$coord} > 1) {
        # print "$coord: $grid{$coord}\n";
        $sharedClaims++;
    }
}

print "Shared claims: $sharedClaims\n";

