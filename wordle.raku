use v6;
use lib 'lib';
use Utils;
use MostYellowLetter;
use MostGreenLetter;
use GreenPlusYellow;
use Graphics::PLplot;

my $SAMPLE_SIZE = 1000;
my @SOLVERS = YellowLetterSolver, GreenLetterSolver, GreenPlusYellowSolver;
# my @SOLVERS = GreenPlusYellowSolver;

#Compute stats
my @stats = (['Solver', 'X', 'Y'],);
race for @SOLVERS -> $solver_module {
    my @words of Str = 'words'.IO.lines;
    my @results = race for @words.pick($SAMPLE_SIZE) -> $word {
        my $puzzle = Puzzle.new(solution => $word);
        my $solver = $solver_module.new(puzzle => $puzzle);
        $solver.solve(@words);
    };
    # say @results;

    for @results.classify({$_}).kv -> $k, $v {
        @stats.push([('"', $solver_module.^name, '"').join(), $k, $v.elems]);
    };
}

#Write stats to file
my $fh = open "stats.csv", :w;
for @stats -> @line {
    $fh.print(@line.join(','));
    $fh.print("\n");
}
$fh.close;
