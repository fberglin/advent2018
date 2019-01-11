#!/usr/bin/perl -w

use Data::Dumper;

open($fh, "< 18.input") || die "Unable to open file: $!\n";

@input = <$fh>;

<<EOC
@input = (
".#.#...|#.",
".....#|##|",
".|..|...#.",
"..|#.....#",
"#.#|||#|#|",
"...#.||...",
".|....|...",
"||...#|.#|",
"|.||||..|.",
"...#.|..|.",
);
EOC
;

sub countAdjacent(@);
sub printGrid(@);

$|++;

$x = 0;
$y = 0;

@current = ();
@last = ();

foreach $line (@input) {
    chomp($line);
    @chars = split(//, $line);

    $x = 0;
    foreach $char (@chars) {
        $current[$x][$y] = $char;
        $last[$x][$y] = $char;
        $x++;
    }
    $y++;
}

$xMax = $x;
$yMax = $y;

$duration = 1000000000;
# $duration = 1000000;
# $duration = 10;

# After 450 iterations the pattern repeats every 28'th minute
print "Grid size: $xMax", "x", "$yMax. Calculating duration...\n";
while ($duration > 450) {
    $duration -= 28;
}

for my $minute (0 ... $duration - 1) {

    # Clear the screen
    print "\033[2J";
    # Jump to 0,0
    print "\033[0;0H";

    print "$minute/$duration\n";
    printGrid(\@last, $xMax, $yMax);

    for $y (0 ... $yMax-1) {
        for $x (0 ... $xMax-1) {
            if ($last[$x][$y] eq ".") {
                # Count trees
                $trees = countAdjacent(\@last, $x, $y, "|");
                if ($trees >= 3) {
                    $current[$x][$y] = "|";
                }
            } elsif ($last[$x][$y] eq "|") {
                $lumberyards = countAdjacent(\@last, $x, $y, "#");
                if ($lumberyards >= 3) {
                    $current[$x][$y] = "#";
                }
            } elsif ($last[$x][$y] eq "#") {
                $lumberyards = countAdjacent(\@last, $x, $y, "#");
                $trees = countAdjacent(\@last, $x, $y, "|");
                if ($lumberyards >= 1 and $trees >= 1) {
                    # Do nothing
                } else {
                    $current[$x][$y] = ".";
                }
            } else {
                print "Unknown character: '$last[$x][$y]'\n";
            }
        }
    }

    # Copy contents of two dimensional array, 'array of references'.
    @last = map { [@$_] } @current;

=pod
    # Calculate checksum
    for my $y (0 ... $yMax-1) {
        for my $x (0 ... $xMax-1) {
            if ($current[$x][$y] eq "|") {
                $trees++;
            } elsif ($current[$x][$y] eq "#") {
                $lumberyards++;
            }
        }
    }

    $checksum = $trees * $lumberyards;
    if (grep(/$checksum/, @checksums)) {
        print "Found checksum after $minute: $checksum\n";

        for $i (0 ... $#checksums) {
            if ($checksums[$i] == $checksum) {
                print "Last entry: $i\n";
            }
        }
        # exit;
        # getc();
    }
    $checksums[$minute] = $checksum;
=cut
}
print "\n";

print "After $duration minutes:\n";
printGrid(\@last, $xMax, $yMax);

$trees = 0;
$lumberyards = 0;

for my $y (0 ... $yMax-1) {
    for my $x (0 ... $xMax-1) {
        if ($current[$x][$y] eq "|") {
            $trees++;
        } elsif ($current[$x][$y] eq "#") {
            $lumberyards++;
        }
    }
}

print "Trees: $trees, lumberyards = $lumberyards. $trees * $lumberyards = ", $trees * $lumberyards, "\n";

sub printGrid(@) {
    my $grid = shift;
    my $xMax = shift;
    my $yMax = shift;

    my $ref = 0;
    if (!ref($grid)) {
        $ref = $grid;
        $grid = \$ref;
    }

    for my $y (0 ... $yMax-1) {
        for my $x (0 ... $xMax-1) {
            print $grid->[$x][$y];
        }
        print "\n";
    }
    print "-"x$xMax, "\n";
}

sub countAdjacent(@) {
    my $grid = shift;
    my $x = shift;
    my $y = shift;
    my $char = shift;

    $sum = 0;
    for $yAdj ($y-1 ... $y+1) {
        for $xAdj ($x-1 ... $x+1) {
            if ($xAdj < 0 or $yAdj < 0 or $xAdj > $xMax-1 or $yAdj > $yMax-1) {
                next;
            }
            if ($yAdj == $y and $xAdj == $x) {
                next;
            } elsif ($grid->[$xAdj][$yAdj] eq $char) {
                $sum++;
            }
        }
    }
    return $sum;
}

