unit module GreenPlusYellow;
use Utils;

class GreenPlusYellowSolver is Solver is export {
    method !generate_stats(Str @words) {
        my %green_stats = 0 => {}, 1 => {}, 2 => {}, 3 => {}, 4 => {};
        my %yellow_stats = {};
        for @words -> $word {
            for 0..4 -> $i {
                if %green_stats{$i}{$word.substr($i, 1)}:exists {
                    %green_stats{$i}{$word.substr($i, 1)} +=1;
                }
                else {
                    %green_stats{$i}{$word.substr($i, 1)} = 1;
                }

                if %yellow_stats{$word.substr($i, 1)}:exists {
                    %yellow_stats{$word.substr($i, 1)} +=1;
                }
                else {
                    %yellow_stats{$word.substr($i, 1)} = 1;
                }
            }
        }

        %green_stats.push('all' => %yellow_stats);
        return %green_stats;
    }

    method !word_score(%stats, Str $word) returns Int {
        my $score = 0;
        for 0..4 -> $i {
        $score += %stats{$i}{$word.substr($i, 1)};
        }
        my @letters = $word.split('',:skip-empty).unique;
        for @letters -> $letter {
            $score += %stats{'all'}{$letter};
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