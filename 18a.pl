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

print "$xMax,$yMax\n";

for my $minute (0 ... 9) {

    # print "At time: $minute\n";
    # printGrid(\@last, $xMax, $yMax);
    # printGrid(\@current, $xMax, $yMax);

    for $y (0 ... $yMax-1) {
        for $x (0 ... $xMax-1) {
            if ($last[$x][$y] eq ".") {
                # Count trees
                $trees = countAdjacent(\@last, $x, $y, "|");
                # print "Pos: $x,$y. Current: $last[$x][$y], trees: $trees";
                if ($trees >= 3) {
                    # print ", changing to: |";
                    $current[$x][$y] = "|";
                }
                # print "\n";
            } elsif ($last[$x][$y] eq "|") {
                $lumberyards = countAdjacent(\@last, $x, $y, "#");
                # print "Pos: $x,$y. Current: $last[$x][$y], lumberyards: $lumberyards";
                if ($lumberyards >= 3) {
                    # print ", changing to: #";
                    $current[$x][$y] = "#";
                }
                # print "\n";
            } elsif ($last[$x][$y] eq "#") {
                $lumberyards = countAdjacent(\@last, $x, $y, "#");
                $trees = countAdjacent(\@last, $x, $y, "|");
                # print "Pos: $x,$y. Current: $last[$x][$y], lumberyards: $lumberyards, trees $trees";
                if ($lumberyards >= 1 and $trees >= 1) {
                    # Do nothing
                } else {
                    # print ", changing to: .";
                    $current[$x][$y] = ".";
                }
                # print "\n";
            } else {
                print "Unknown character: '$last[$x][$y]'\n";
            }
        }
    }

    # Copy contents of two dimensional array, 'array of references'.
    @last = map { [@$_] } @current;

    # print "After ", $minute + 1, " minutes\n";
    # printGrid(\@last, $xMax, $yMax);

    # getc();
}

print "After 10 minutes\n";
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


    # print "\n$x,$y\n";
    # printGrid($grid, $xMax, $yMax);

    $sum = 0;
    for $yAdj ($y-1 ... $y+1) {
        for $xAdj ($x-1 ... $x+1) {
            if ($xAdj < 0 or $yAdj < 0 or $xAdj > $xMax-1 or $yAdj > $yMax-1) {
                # print "x";
                next;
            }
            if ($yAdj == $y and $xAdj == $x) {
                # print "o";
                next;
            } elsif ($grid->[$xAdj][$yAdj] eq $char) {
                $sum++;
            }
            # print $grid->[$xAdj][$yAdj];
        }
        # print "\n";
    }
    return $sum;
}

