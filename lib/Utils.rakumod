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

class Puzzle is export {
    has $.solution is required;

    method guess ($word) {
        my @response = [0, 0, 0, 0, 0];
        for 0..4 -> $i {
            my $letter = $word.substr($i, 1);
            if $letter eq $.solution.substr($i, 1) {
                @response[$i] = 2;
            }
            elsif $.solution.contains($letter) {
                @response[$i] = 1;
            }
        }

        return @response;
    }
}

class Filter is export {
    has @.indexes is required;
    has $.is is required;
    has $.letter is required;

    method filter($word) {
        return $word.indices($.letter).grep({$.is /[@.indexes]/ });
    }
}



