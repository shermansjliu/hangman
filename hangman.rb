require 'json'
class GameController
    attr_accessor :guesses, :user_word, :answer, :used_letters
    def initialize
        @guesses = 0
        @user_word = ''
        @answer = ''
        @used_letters = []
    end

    public
    def newGame
        @answer = selectWord()
        @guesses = @answer.length + 2
        @user_word = @user_word.rjust(@answer.length, '_').split('')
    end

    def save (file_name)
        if File.exists?("#{file_name}.JSON")
            puts "Would you like to overwrite this file? (y/n)"
            answer = gets.chomp.downcase
            if answer == 'y'
                file = File.open("#{file_name}.JSON", 'w')
                puts to_json(file)
            elsif answer == 'n'
                puts "This file name is taken"
            end

        else
            file = File.new("#{file_name}.JSON", 'w')
            to_json(file)
            puts "Your file is saved"
        end
    end

    def load(file_name)
        if !File.exists?("#{file_name}.JSON")
            puts "This file doesn't exist"
        end
        from_json(file_name)
    end

    def startGame
        displayText("Welcome to Hangman")
        displayText("Would you like to load a game? (y/n)")
    end

    def play(guess)
        if @used_letters.include?(guess)
            loop do
                displayText("You already played this letter")
                guess = cleanGuess
                break if !@used_letters.include?(guess)
            end
        else
            @answer.split('').each_with_index { |char, index|
                if guess == char.downcase
                    @user_word[index] = guess
                end
            }
            @used_letters.push(guess)
                @guesses -= 1
        end
    end

    private
    def from_json(file_name)
        data = JSON.parse(File.open("#{file_name}.JSON", "r").readline())
        @guesses = data['guesses']
        @user_word = data['user_word']
        @answer = data['answer']
        @used_letters = data['used_letters']
    end

    def to_json (file)
        output = JSON.generate ({
            guesses: @guesses,
            user_word: @user_word,
            answer: @answer,
            used_letters: @used_letters
            })
        file.print(output)
        file.close()
    end
end

def win?(user_word, answer)
    return user_word == answer
end

def cleanGuess
    displayText("Put in a letter!")
    guess = gets.chomp.downcase
    until guess.length == 1 and !(guess =~ /[0-9]/) or guess.downcase == 'save'
        guess = gets.chomp.downcase
    end
    return guess

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


#If the user selects load
#let the user choose a file they want to load
#Set the number of guesses to the loaded file
#set the answer to the loded word
#Set the user_word to the stored user_word

#If the user selects new game
#set the default number of guesses to 8
#Set the answer to a randomly generated word

gc = GameController.new()
gc.startGame()
load = ''

loop do
    load = gets.chomp.downcase
    break if load == 'y' or load == 'n'
end


if load == 'y'
    displayText("What's the name of the file you want to load list")
    displayText("Note: The input is case sensitive, don't type the extension of the file
        e.g 'test-file', NOT 'test-file.txt'")
    displayText("OR Press 'n' to start a new game")
    loop do
        file_name = gets.chomp
        if File.exists?("#{file_name}.JSON")
            gc.load(file_name)
            puts ''
            break
        elsif file_name.downcase == 'n'
            gc.newGame()
            break
        end
        displayText("Enter an existing file or start a new game")
      end
elsif load == 'n'
    gc.newGame()
end

displayText("Type 'save' at any point to save your game!")
while gc.guesses > 0
    displayText('')
    displayText("Guesses left: #{gc.guesses}")
    displayText("Your current status: #{gc.user_word.join('')}")
    displayText("Used Letters: #{gc.used_letters.inspect()}")

    guess = cleanGuess
    if guess == 'save'
        displayText("What would you like to name the file?")
        file_name = gets.chomp()
        gc.save(file_name)
        displayText("File saved!")
    else
        gc.play(guess)
    end

    if win?(gc.user_word.join(''), gc.answer)
        displayText("You guessed the word #{gc.user_word.join('')}correctly!")
        break
    end

end
displayText("What is your final guess?")
finalGuess = gets.chomp.downcase

if win?(finalGuess, gc.answer)
    displayText("You guessed the word #{gc.answer}correctly!")
else
    displayText("Better luck next time!")
    displayText("You were trying to guess the word #{gc.answer}")
end
