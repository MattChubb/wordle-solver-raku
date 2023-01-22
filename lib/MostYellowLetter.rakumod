unit module MostYellowLetter;

sub generate_stats(Str @words) {
    my %stats = {};
    for @words -> $word {
        for 0..4 -> $i {
            if %stats{$word.substr($i, 1)}:exists {
                %stats{$word.substr($i, 1)} +=1;
            }
            else {
                %stats{$word.substr($i, 1)} = 1;
            }
        }
    }

    return %stats;
}

sub word_score(%stats, Str $word) returns Int {
    my $score = 0;
    my @letters = $word.split('',:skip-empty).unique;

    for @letters -> $letter {
        $score += %stats{$letter};
    }

    return $score;
}

sub top_word(Str @words) returns Str is export {
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
