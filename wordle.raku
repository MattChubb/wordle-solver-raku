use v6;
use lib 'lib';
use Utils;

my $SAMPLE_SIZE = 5;

my @words of Str = 'words'.IO.lines;
my @results = race for @words.pick($SAMPLE_SIZE) -> $word {
    my $puzzle = Puzzle.new(solution => $word);
    $puzzle.solve(@words);
};
# say @results;

my %stats;
for @results.classify({$_}).kv -> $k, $v {
    %stats.push($k => $v.elems);
};
say %stats;