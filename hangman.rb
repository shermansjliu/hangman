
def select_word
    suitable_words = File.open('5desk.txt') { |file|
        file.readlines().select { |word|
             word.strip!()
             word.length > 5 and word.length < 12
        }
    }

    return suitable_words[rand(suitable_words.length)]
end
