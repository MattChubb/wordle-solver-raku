use v6;
use lib 'lib';
use Utils;

my @words of Str = 'words'.IO.lines;
my %stats = generate_stats(@words);

#Init puzzle
my $puzzle = Puzzle.new(solution => "stare");
say "Starting with {@words.elems} words";

my $tries = 0;
while @words > 0 {
    # Select top word from wordlist
    $tries++;
    my $guess = top_word(@words);
    say "Trying $guess...";

    # Try top word
    my @result of Int = $puzzle.guess($guess);
    say "result of $guess is {@result}";
    if (@result eq [2, 2, 2, 2, 2]) {
        say "Correctly guessed in $tries tries";
        last;
    }

    # Create filters
    my @filters of Filter = create-filters-from-result($guess, @result);

    # Apply filters to refine wordlist
    @words = trim-wordlist(@words, @filters);
    say "{@words.elems} words left";
}


