#!/usr/bin/perl

open($fh, "< 1.input") || die "Unable to open file: $!\n";

@input = <$fh>;

%frequency = ();
$sum = 0;
$i = 0;

for (;;$i++) {
    $i = $i % scalar(@input);

    chomp($input[$i]);
    $sum += int($input[$i]);

    if (defined ($frequency{$sum})) {
        print "First recurring value: $sum\n";
        exit;
    }
    $frequency{$sum} = 1;
}

