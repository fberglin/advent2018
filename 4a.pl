#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 4.input") || die "Unable to open file: $!\n";

@input = <$fh>;

<<EOC
@input = (
"[1518-11-01 00:00] Guard #10 begins shift",
"[1518-11-01 00:05] falls asleep",
"[1518-11-01 00:25] wakes up",
"[1518-11-01 00:30] falls asleep",
"[1518-11-01 00:55] wakes up",
"[1518-11-01 23:58] Guard #99 begins shift",
"[1518-11-02 00:40] falls asleep",
"[1518-11-02 00:50] wakes up",
"[1518-11-03 00:05] Guard #10 begins shift",
"[1518-11-03 00:24] falls asleep",
"[1518-11-03 00:29] wakes up",
"[1518-11-04 00:02] Guard #99 begins shift",
"[1518-11-04 00:36] falls asleep",
"[1518-11-04 00:46] wakes up",
"[1518-11-05 00:03] Guard #99 begins shift",
"[1518-11-05 00:45] falls asleep",
"[1518-11-05 00:55] wakes up"
);
EOC
;

@sorted = sort @input;

$guard = 0;

%guards = ();
%dates = ();

foreach $record (@sorted) {
    # print "$record\n";
    if ($record =~ m/\[(\d{4}-\d{2}-\d{2}) (\d{2}):(\d{2})\] Guard #(\d+) begins shift/) {
        $date = $1;
        $hour = $2;
        $minute = $3;
        $guard = $4;

        # print "$date - $hour:$minute - $guard\n";
    } elsif ($record =~ m/\[(\d{4}-\d{2}-\d{2}) (\d{2}):(\d{2})\] falls asleep/) {
        $date = $1;
        $hour = $2;
        $sleepStart = int($3);

    } elsif ($record =~ m/\[(\d{4}-\d{2}-\d{2}) (\d{2}):(\d{2})\] wakes up/) {
        $date = $1;
        $hour = $2;
        $sleepStop = int($3);

        print "$date: $guard: sleep: $sleepStart - $sleepStop: ", $sleepStop - $sleepStart, " minutes\n";

        if (not defined($guards{$guard}{$date})) {
            $guards{$guard}{$date} = ();
        }
        push(@{$guards{$guard}{$date}}, { "start" => $sleepStart, "stop" => $sleepStop });

        if (not defined($dates{$date}{$guard})) {
            $dates{$date}{$guard} = ();
        }
        push(@{$dates{$date}{$guard}}, { "start" => $sleepStart, "stop" => $sleepStop });
    }
}

%sleep = ();
foreach $date (sort keys %dates) {
    foreach $guard (keys %{$dates{$date}}) {
        printf("%s %04d ", $date, $guard);
        for $i (0 ... 59) {
            $sleeping = 0;
            foreach $period (@{$guards{$guard}{$date}}) {
                $start = $period->{ "start" };
                $stop = $period->{ "stop" };
                if ($i >= $start and $i < $stop) {
                    $sleeping = 1;
                    last;
                }
            }
            if ($sleeping == 1) {
                $sleep{ $guard }->{ "total" } += 1;
                $sleep{ $guard }->{ "frequency" }->{ $i } += 1;
                print "#";
            } else {
                print ".";
            }
        }
        print "\n";
    }
}

print "\n";

$sleepiestGuard = 0;
$maxSleepTime = 0;
foreach $guard (keys %sleep) {
    if ($sleep{ $guard }->{ "total"} > $maxSleepTime) {
        $sleepiestGuard = $guard;
        $maxSleepTime = $sleep{ $guard }->{ "total" };
    }
}
print "Sleepiest guard: $sleepiestGuard, accumulated sleep: $maxSleepTime minutes\n";

$highestMinute = 0;
$maxFrequency = 0;
foreach $minute (keys %{ $sleep{ $sleepiestGuard }->{ "frequency" } }) {
    if ($sleep{ $sleepiestGuard }->{ "frequency" }->{ $minute } > $maxFrequency) {
        $highestMinute = $minute;
        $maxFrequency = $sleep{ $sleepiestGuard }->{ "frequency" }->{ $minute };
    }
}
print "Sleeps most often at 00:$highestMinute, $maxFrequency times\n";
print "$sleepiestGuard * $highestMinute = ", $sleepiestGuard * $highestMinute, "\n";

