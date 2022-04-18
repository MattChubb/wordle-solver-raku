use v6;
use lib 'lib';
use Utils;

my @words = 'words'.IO.lines;
my %stats = generate_stats(@words);

my $topword;
my $topscore = 0;
for @words -> $word {
    my $score = word_score(%stats, $word);
    if $topscore < $score {
        $topword = $word;
        $topscore = $score;
    }
}
say $topword, $topscore;

my $puzzle = Puzzle.new(solution => "stare");
say $puzzle.guess("sores");

my $filter = Filter.new(indices => (0,1,3,4), is => True, letter => 'f');
say $filter.filter("sores");
