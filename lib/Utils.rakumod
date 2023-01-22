unit module Utils;

class Filter is export {
    has Int @.indices is required;
    has Bool $.is is required;
    has Str $.letter is required;

    method filter(Str $word) returns Bool {
        my $matches = $word.indices($.letter) (&) @.indices;
        return ($matches.elems() != 0) == $.is;
   }

    method from-hash(%attr) {
        # Dammit Raku y u no hande lists in hashes properly?
        self.bless(
            is => %attr{'is'},
            indices => @(%attr{'indices'}),
            letter => %attr{'letter'}
        );
    }
}


class Puzzle is export {
    has Str $.solution is required;
    
    method guess (Str $word) returns Array[Int] {
        my @response of Int = 0, 0, 0, 0, 0;
        for 0..4 -> $i {
            my $letter = $word.substr($i, 1);
            if $letter eq $.solution.substr($i, 1) {
                @response[$i] = 2;
            }
            elsif $.solution.contains($letter, 0) {
                @response[$i] = 1;
            }
        }

        return @response;
    }
}

class Solver is export {
    has Puzzle $.puzzle is required;

    method top_word(Str @words) returns Str {return @words.first};

    method !trim-wordlist(Str @words, Filter @filters) returns Positional[Str] {
        my @filtered_words of Str = @words.grep({
            my $word = $_;
            @filters.map(*.filter($word)).reduce: &infix:<&&>;
        });
        return @filtered_words;
    }

    method !create-filters-from-result(Str $guess, Int @result) returns Positional[Filter] {
        my Filter @filters = ();
        for 0..4 -> $i {
            given @result[$i] {
                when 0 {
                    @filters.push(
                        Filter.new(
                            indices => (0..4),
                            is => False,
                            letter => $guess.substr($i, 1),
                        )
                    );
                }
                when 1 {
                    @filters.push(
                        Filter.new(
                            indices => ($i),
                            is => False,
                            letter => $guess.substr($i, 1),
                        ),
                        Filter.new(
                            indices => (0..4).grep( * != $i) ,
                            is => True,
                            letter => $guess.substr($i, 1),
                        )
                    );
                }
                when 2 {
                    @filters.push(
                        Filter.new(
                            indices => ($i),
                            is => True,
                            letter => $guess.substr($i, 1),
                        )
                    );
                }
            }
        }

        return @filters;
    }

    method solve(Str @wordlist) returns Int {
        # say "Starting with {@words.elems} words";

        my $tries = 0;
        my @words of Str = @wordlist.clone;
        # say "{@words.elems} words in list";
        while @words > 0 {
            # Select top word from wordlist
            $tries++;
            my $guess = $.top_word(@words);
            # say "Trying $guess...";

            # Try top word
            my @result of Int = @($.puzzle.guess($guess));
            # say "result of $guess is {@result}";
            if (@result eq [2, 2, 2, 2, 2]) {
                # say "Correctly guessed in $tries tries";
                return $tries;
            }

            # Create filters
            my @filters of Filter = self!create-filters-from-result($guess, @result);

            # Apply filters to refine wordlist
            @words = self!trim-wordlist(@words, @filters);
            # say "{@words.elems} words left";
        }

        return -1; #TODO throw error instead
    }
}