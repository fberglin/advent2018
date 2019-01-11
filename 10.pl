#!/usr/bin/perl -w

use Data::Dumper;

open($fh, "< 10.input") || die "Unable to open file: $!\n";

@input = <$fh>;

<<EOC
@input = (
"position=< 9,  1> velocity=< 0,  2>",
"position=< 7,  0> velocity=<-1,  0>",
"position=< 3, -2> velocity=<-1,  1>",
"position=< 6, 10> velocity=<-2, -1>",
"position=< 2, -4> velocity=< 2,  2>",
"position=<-6, 10> velocity=< 2, -2>",
"position=< 1,  8> velocity=< 1, -1>",
"position=< 1,  7> velocity=< 1,  0>",
"position=<-3, 11> velocity=< 1, -2>",
"position=< 7,  6> velocity=<-1, -1>",
"position=<-2,  3> velocity=< 1,  0>",
"position=<-4,  3> velocity=< 2,  0>",
"position=<10, -3> velocity=<-1,  1>",
"position=< 5, 11> velocity=< 1, -2>",
"position=< 4,  7> velocity=< 0, -1>",
"position=< 8, -2> velocity=< 0,  1>",
"position=<15,  0> velocity=<-2,  0>",
"position=< 1,  6> velocity=< 1,  0>",
"position=< 8,  9> velocity=< 0, -1>",
"position=< 3,  3> velocity=<-1,  1>",
"position=< 0,  5> velocity=< 0, -1>",
"position=<-2,  2> velocity=< 2,  0>",
"position=< 5, -2> velocity=< 1,  2>",
"position=< 1,  4> velocity=< 2,  1>",
"position=<-2,  7> velocity=< 2, -2>",
"position=< 3,  6> velocity=<-1, -1>",
"position=< 5,  0> velocity=< 1,  0>",
"position=<-6,  0> velocity=< 2,  0>",
"position=< 5,  9> velocity=< 1, -2>",
"position=<14,  7> velocity=<-2,  0>",
"position=<-3,  6> velocity=< 2, -1>",
);
EOC
;

$|++;

$id = 0;

foreach $line (@input) {
    if (not $line =~ m/position=<\s*([\d-]+),\s*([\d-]+)> velocity=<\s*([\d-]+),\s*([\d-]+)>/) {
        print "Unknown input: $0";
        exit;
    }
    $xPos = $1;
    $yPos = $2;
    $xVel = $3;
    $yVel = $4;

    $drones{$id++} = { "startX" => $xPos,
                       "startY" => $yPos,
                       "currX" => $xPos,
                       "currY" => $yPos,
                       "velX" => $xVel,
                       "velY" => $yVel };
}

$tick = 0;

$lastX = 10e6;
$lastY = 10e6;

$maxX = 0;
$maxY = 0;

for (;;$tick++) {
    $minX = 10e6;
    $minY = 10e6;
    $maxX = 0;
    $maxY = 0;

    foreach $id (keys %drones) {
        $drones{$id}->{ "currX" } = $drones{$id}->{ "currX" } + $drones{$id}->{ "velX" };
        $drones{$id}->{ "currY" } = $drones{$id}->{ "currY" } + $drones{$id}->{ "velY" };

        if ($drones{$id}->{ "currX" } < $minX) {
            $minX = $drones{$id}->{ "currX" };
        }
        if ($drones{$id}->{ "currX" } > $maxX) {
            $maxX = $drones{$id}->{ "currX" };
        }

        if ($drones{$id}->{ "currY" } < $minY) {
            $minY = $drones{$id}->{ "currY" };
        }
        if ($drones{$id}->{ "currY" } > $maxY) {
            $maxY = $drones{$id}->{ "currY" };
        }
    }

    # print "Tick: $tick, minX: $minX, maxX: $maxX, minY: $minY, maxY: $maxY\n";
    $sizeX = $maxX - $minX;
    $sizeY = $maxY - $minY;

    if ($lastX < $sizeX or $lastY < $sizeY) {
        print "Smallest size at tick: $tick\n";
        last;
    }

    # print "X: $sizeX, Y: $sizeY, $lastX, $lastY\n";

    $lastX = $sizeX;
    $lastY = $sizeY;
}


# foreach $id (keys %drones) {

foreach $id (keys %drones) {
    $x = $drones{$id}->{ "startX" } + $drones{$id}->{ "velX" } * $tick;
    $y = $drones{$id}->{ "startY" } + $drones{$id}->{ "velY" } * $tick;

    $grid[$x][$y] = "#";
}

for $y (0 ... $maxY) {
    $printed = 0;
    for $x (0 ... $maxX) {
        if (defined($grid[$x][$y])) {
            print "$grid[$x][$y]";
            $printed = 1;
        } else {
            print " ";
        }
    }
    if ($printed == 1) {
        print "\n";
    } else {
        print "\r";
    }
}

print "Size: $y cols, $x rows\n";


