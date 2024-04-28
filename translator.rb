class Translator
    class Lexicon
        def initialize(word, pos)
            @word = word
            @pos = pos
            @lexHash = Hash.new
        end
        
        def getWord
            @word
        end
        
        def getPos
            @pos
        end
        
        def getHash
            @lexHash
        end
        
        def convert(str)
            regex1 = /^[A-Z][a-z]*$/
            regex2 = /^[a-z]+$/
            
            
            
            str.split(", ").each {
                |bigStr|
                
               arr = bigStr.split(":")
               @lexHash.store(arr[0], arr[1])
            }
            
        end
        
    end
    
    def initialize(words_file, grammar_file)
        @grammarHash = Hash.new
        @helperHash = Hash.new
        updateLexicon(words_file)
        updateGrammar(grammar_file)
    end
    
    # part 1
    
    def updateLexicon(inputfile)
        regex = /^([a-z]+), ([A-Z]{3}), ((([A-Z][a-z]*):([a-z]+),?\s?)+)$/
        File.readlines(inputfile).each {
            |line|
            if regex =~ line
                word = $1
                pos = $2
                
                lexObj = Lexicon.new(word, pos)
                lexObj.convert($3)
                @helperHash.store(word, lexObj)
            end
        }
        
    end
    
    def updateGrammar(inputfile)
        regex1 = /^([A-Z][a-z]*): (([A-Z]{3}(\{[1-9][0-9]*\})?,?\s?)+)$/
        
        regex2 = /^([A-Z]{3})\{([1-9])\}$/
        
        File.readlines(inputfile).each {
            |line|
            if regex1 =~ line
                lang = $1
                posx = $2
                posArr = Array.new
                posx.split(', ').each{
                    |x|
                    
                    if regex2 =~ x
                        currPos = $3
                        optionalNum = $4
                        num = (optionalNum.split("{"))[1].split("}")
                      
                        for i in 0..num-1
                            posArr.push(x)
                        end
                    end
                    
                    posArr.push(x)
                }
                @grammarHash.store(lang, posArr)
            end
        }
    end
    
    # part 2
    
    def generateSentence(language, struct)
        currArr = Array.new
        if struct.class.name == Array
            for pos in struct
                for k,v in @helperHash
                    if v.getPos == pos
                        if v.getHash.has_key?(language)
                            currArr.push(v.getHash[language])
                        end
                    end
                end
            end
            sentence = currArr.join(' ')
            
            return sentence
            
        end
    end
        
    def checkGrammar(sentence, language)
        currArr = Array.new
        
        sentence.split(' ').each {
            |word|
            
            for k,v in @helperHash
                if v.getHash[language] == word
                    currArr.push(v.getPos)
                end
            end
                
            }
            
        return @grammarHash[language] == currArr
            
    end
        
    def changeGrammar(sentence, struct1, struct2)
        currArr = Array.new
        currHash = Hash.new
        

        if struct2.class == String
            sentence.split(' ').each{
            |word|
                
            for k,v in @helperHash
                if v.getHash[struct1] == word
                    currHash.store(v.getPos, word)
                end
            end
                    
            }
                newArr = @grammarHash[struct2]
                for pos in newArr
                    currArr.push(currHash[pos])
                end
        else
            sentence.split(' ').each{
            |word|
                
            for k,v in @helperHash
                if v.getHash[struct1] == word
                    currHash.store(v.getPos, word)
                end
            end
                    
            }
                for i in struct2
                    currArr.push(currHash[i])
                end
        end
        sentence = currArr.join(' ')
        return sentence
    end
        
        # part 3
        
    def changeLanguage(sentence, language1, language2)
        currArr = Array.new
        sentence.split(' ').each{
            |word|
            for k,v in @helperHash
                if v.getHash[language1] == word
                    if language2 == "English"
                        currArr.push(v.getWord)
                    else
                        currArr.push(v.getHash[language2])
                    end
                end
            end
                
            }
        sentence = currArr.join(' ')
        return sentence
    end
        
    def translate(sentence, language1, language2)
        langStr = changeLanguage(sentence, language1, language2)
        grammarStr = changeGrammar(langStr, language1, language2)
        return grammarStr
    end
end
