class GameController
    attr_reader: :guesses, :user_word
    def initialize
        @guesses = 0
        @user_word = ''
    end

    def save
end

def win?

end
def cleanGuess
    guess = gets.chomp

    until guess.length == 1 and !(guess =~ /[0-9]/)
        guess = gets.chomp.downcase
    end
    return guess

end
def play(guess, answer, user_word)

    answer.split('').each_with_index { |char, index|

        if guess == char.downcase

            user_word[index] = guess
        end
    }
end

def selectWord
    suitable_words = File.open('5desk.txt') { |file|
        file.readlines().select { |word|
             word.strip!()
             word.length > 5 and word.length < 12
        }
    }

    return suitable_words[rand(suitable_words.length)]
end

def displayText(text)
    for char in text.split('')
        print "#{char}"
        sleep 0.02
    end
    puts ""
end


# displayText("Welcome to Hangman")

answer = selectWord()
user_word = ''
answer.length.times {user_word += '_'}
user_word = user_word.split('')

guesses_left= 8

while guesses_left > 0
    puts answer
    displayText("Guesses left: #{guesses_left}")
    displayText(user_word.join(''))
    guess = cleanGuess

    play(guess, answer, user_word)

    guesses_left -= 1

end
