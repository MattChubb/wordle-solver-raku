unit module MostGreenLetter;

sub generate_stats(Str @words) {
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

sub word_score(%stats, Str $word) returns Int {
    my $score = 0;
    for 0..4 -> $i {
       $score += %stats{$i}{$word.substr($i, 1)};
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
