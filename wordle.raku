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



