use v6;
use lib 'lib';
use Utils;

my @words of Str = 'words'.IO.lines;
my %stats = generate_stats(@words);

#Init puzzle
my $puzzle = Puzzle.new(solution => "stare");

my $tries = $puzzle.solve(@words);
say "Solved in $tries tries";

