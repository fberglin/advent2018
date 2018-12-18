#!/usr/bin/perl -w

use Data::Dumper;

open($fh, "< 13.input") || die "Unable to open file: $!\n";

@input = <$fh>;

<<EOC
@input = (
"/->-\\        ",
"|   |  /----\\",
"| /-+--+-\\  |",
"| | |  | v  |",
"\\-+-/  \\-+--/",
"  \\------/   "
);
EOC
;

$|++;

$x = 0;
$y = 0;

@wagons = ();

foreach $line (@input) {
    @chars = split(//, $line);
    $x = 0;

    foreach $char (@chars) {
        if ($char eq ">" or $char eq "<" or $char eq "^" or $char eq "v") {
            $wagon = { "dir" => $char, "x" => $x, "y" => "$y", "turns" => 0 };
            push(@wagons, $wagon);
        }
        if ($char eq ">" or $char eq "<") {
            $char = "-";
        } elsif ($char eq "^" or $char eq "v") {
            $char = "|"
        }
        $grid[$x][$y] = $char;
        $x++;
    }
    $y++;
}

$xMax = $x;
$yMax = $y;

while (1) {
    @positions = ();
    foreach $wagon (@wagons) {
        $x = $wagon->{ "x" };
        $y = $wagon->{ "y" };
        # print "> x: ", $wagon->{ "x" }, " y: ", $wagon->{ "y" }, ", grid: ", $grid[$x][$y], ", dir: ", $wagon->{ "dir" }, "\n";

        # Move wagon
        if ($wagon->{ "dir" } eq "^") {
            $wagon->{ "y" }--;
        } elsif ($wagon->{ "dir" } eq ">") {
            $wagon->{ "x" }++;
        } elsif ($wagon->{ "dir" } eq "v") {
            $wagon->{ "y" }++;
        } elsif ($wagon->{ "dir" } eq "<") {
            $wagon->{ "x" }--;
        }

        # Find new heading
        $x = $wagon->{ "x" };
        $y = $wagon->{ "y" };

        if ($grid[$x][$y] eq "-" or $grid[$x][$y] eq "|") {
            # Do nothing
        } elsif ($grid[$x][$y] eq "\\") {
            if ($wagon->{ "dir" } eq "^") {
                $wagon->{ "dir" } = "<";
            } elsif ($wagon->{ "dir" } eq ">") {
                $wagon->{ "dir" } = "v";
            } elsif ($wagon->{ "dir" } eq "v") {
                $wagon->{ "dir" } = ">";
            } elsif ($wagon->{ "dir" } eq "<") {
                $wagon->{ "dir" } = "^";
            } else {
                print "! x: ", $wagon->{ "x" }, " y: ", $wagon->{ "y" }, ", dir: ", $wagon->{ "dir" }, ", grid: ", $grid[$x][$y], "\n";
            }
        } elsif ($grid[$x][$y] eq "/") {
            if ($wagon->{ "dir" } eq "^") {
                $wagon->{ "dir" } = ">";
            } elsif ($wagon->{ "dir" } eq ">") {
                $wagon->{ "dir" } = "^";
            } elsif ($wagon->{ "dir" } eq "v") {
                $wagon->{ "dir" } = "<";
            } elsif ($wagon->{ "dir" } eq "<") {
                $wagon->{ "dir" } = "v";
            } else {
                print "! x: ", $wagon->{ "x" }, " y: ", $wagon->{ "y" }, ", dir: ", $wagon->{ "dir" }, ", grid: ", $grid[$x][$y], "\n";
            }
        } elsif ($grid[$x][$y] eq "+") {
            if ($wagon->{ "turns" } % 3 == 0) {
                if ($wagon->{ "dir" } eq "^") {
                    $wagon->{ "dir" } = "<";
                } elsif ($wagon->{ "dir" } eq ">") {
                    $wagon->{ "dir" } = "^";
                } elsif ($wagon->{ "dir" } eq "v") {
                    $wagon->{ "dir" } = ">";
                } elsif ($wagon->{ "dir" } eq "<") {
                    $wagon->{ "dir" } = "v";
                }
            } elsif ($wagon->{ "turns" } % 3 == 1) {
                # Do nothing, keep on straight
            } elsif ($wagon->{ "turns" } % 3 == 2) {
                if ($wagon->{ "dir" } eq "^") {
                    $wagon->{ "dir" } = ">";
                } elsif ($wagon->{ "dir" } eq ">") {
                    $wagon->{ "dir" } = "v";
                } elsif ($wagon->{ "dir" } eq "v") {
                    $wagon->{ "dir" } = "<";
                } elsif ($wagon->{ "dir" } eq "<") {
                    $wagon->{ "dir" } = "^";
                }
            }
            $wagon->{ "turns" }++;
        } else {
            print "! x: ", $wagon->{ "x" }, " y: ", $wagon->{ "y" }, ", dir: ", $wagon->{ "dir" }, ", grid: ", $grid[$x][$y], "\n";
        }
        # print "< x: ", $wagon->{ "x" }, " y: ", $wagon->{ "y" }, ", grid: ", $grid[$x][$y], ", dir: ", $wagon->{ "dir" }, "\n";

        if (defined($positions[$x][$y])) {
            print "Collision detected at $x,$y\n";
            exit;
        }

        $positions[$x][$y] = $wagon;
    }

    if (0) {
        for $y (0 ... $yMax) {
            for $x (0 ... $xMax) {
                if (defined($positions[$x][$y])) {
                    print $positions[$x][$y]->{ "dir" };
                } else {
                    if (defined($grid[$x][$y])) {
                        print "$grid[$x][$y]";
                    } else {
                        print " ";
                    }
                }
            }
            print "\n";
        }
        getc();
    }
}

