unit module MostYellowLetter;
use Utils;

class YellowLetterSolver is Solver is export {
    method !generate_stats(Str @words) {
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

    method !word_score(%stats, Str $word) returns Int {
        my $score = 0;
        my @letters = $word.split('',:skip-empty).unique;

        for @letters -> $letter {
            $score += %stats{$letter};
        }

        return $score;
    }

    method top_word(Str @words) returns Str {
        my %stats = self!generate_stats(@words);

        my $topword;
        my $topscore = 0;
        for @words -> $word {
            my $score = self!word_score(%stats, $word);
            if $topscore < $score {
                $topword = $word;
                $topscore = $score;
            }
        }

        #say $topword, $topscore;
        return $topword;
    }
}