unit module Utils;

sub generate_stats(@words) is export {
    my %stats = 0 => {}, 1 => {}, 2 => {}, 3 => {}, 4 => {};
    for @words -> $word {
        for 0..4 -> $i {
            if %stats{$i}{$word.substr($i, 1)}:exists {
                %stats{$i}{$word.substr($i, 1)} +=1;
            }
            else {
                %stats{$i}{$word.substr($i, 1)} = 1;
            }
        }
    }

    return %stats;
}

sub word_score(%stats, $word) is export {
    my $score = 0;
    for 0..4 -> $i {
       $score += %stats{$i}{$word.substr($i, 1)};
    }

    return $score;
}

sub top_word(@words) is export {
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

    #say $topword, $topscore;
    return $topword;
}

class Puzzle is export {
    has Str $.solution is required;

    method guess (Str $word) {
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

class Filter is export {
    has Int @.indices is required;
    has Bool $.is is required;
    has Str $.letter is required;

    method filter($word) {
        my $matches = $word.indices($.letter) (&) @.indices;
        return ($matches.elems() != 0) == $.is;
   }

    method from-hash(%attr) {
        # Dammit Raku y u no hande lists in hashed properly?
        self.bless(
            is => %attr{'is'},
            indices => @(%attr{'indices'}),
            letter => %attr{'letter'}
        );
    }
}

sub trim-wordlist(@words, @filters) is export {
    my @filtered_words = @words.grep({
        my $word = $_;
        @filters.map(*.filter($word)).reduce: &infix:<&&>;
    });
}

sub create-filters-from-result(Str $guess, Int @result) is export {
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

