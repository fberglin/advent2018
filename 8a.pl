#!/usr/bin/perl -w

use Data::Dumper;

open($fh, "< 8.input") || die "Unable to open file: $!\n";

@input = <$fh>;

<<EOC
@input = (
"2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
);
EOC
;

# Disable output buffering
$| = 1;

sub buildTree(@);
sub sumTree(@);

chomp($input[0]);
@data = split(/\s+/, $input[0]);

$tree = { "id" => 0, "children" => [] };

# $id = 0;
$id = "A";

buildTree(\@data, \%tree);
my $totalSum = sumTree(\%tree);

print "Total sum: $totalSum\n";

sub buildTree(@) {
    my $data = shift;
    my $node = shift;

    my $numChildren = int(shift(@$data));
    my $numMetadata = int(shift(@$data));

    $node->{ "numChildren" } = $numChildren;
    # $node->{ "numMetadata" } = $numMetadata;

    $node->{ "children" } = ();

    while ($numChildren-- > 0) {
        my $newNode = { "id" => ++$id };
        buildTree($data, $newNode);
        push (@{$node->{ "children" }}, $newNode);
    }

    my $sumMetadata = 0;
    while ($numMetadata-- > 0) {
        my $metadata = int(shift(@$data));
        push(@{$node->{ "metadata" }}, $metadata);
        $sumMetadata += $metadata;
    }

    $node->{ "sumMetadata" } = $sumMetadata;

}

sub sumTree(@) {
    my $node = shift;

    my $sum = $node->{ "sumMetadata" };
    foreach my $child (@{$node->{ "children" }}) {
        $sum += sumTree($child);
    }
    return $sum;
}

# print Dumper %tree;

