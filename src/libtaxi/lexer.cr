require "colorize"

module Taxi
  enum TokenType
    EOF     = 0
    NEWLINE
    NUMBER
    IDENT
    STRING
    # Keywords.
    FUN      = 100
    ENDFUN
    LABEL
    GOTO
    PRINT
    INPUT
    VAR
    IF
    THEN
    ENDIF
    WHILE
    REPEAT
    ENDWHILE
    # Operators.
    EQ       = 200
    PLUS
    MINUS
    ASTERISK
    SLASH
    EQEQ
    NOTEQ
    LT
    LTEQ
    GT
    GTEQ
  end

  class Token
    @text : Char | String | TokenType 
    @kind : TokenType | Char | String

    def initialize(tokenText : Char | String, tokenKind : Taxi::TokenType)
      @text = tokenText
      @kind = tokenKind
    end

    def get_kind
      @kind
    end

    def check(tokenText)
      TokenType.each do |kind|
        if kind.to_s.capitalize == tokenText && kind.value >= 100 && kind.value < 200
          return kind
        end
        return TokenType::EOF
      end
    end
  end

  class Lexer
    @source : String
    @curChar : Char
    @curPos : Int64
    @curLine : Int64

    def initialize(input)
      @source = '\n' + input + '\n'
      @curChar = '\n'
      @curPos = 0
      @curLine = 0
      next_()
    end

    def next_
      if @curChar == "\n"
        @curLine += 1
      end
      @curPos += 1
      if @curPos >= @source.size
        @curChar = '\0'
      else
        @curChar = @source[@curPos]
      end
    end

    def peek
      if @curPos + 1 >= @source.size
        return '\0'
      end
      return @source[@curPos + 1]
    end

    def skipWhitespace
      while @curChar == ' ' || @curChar == '\t' || @curChar == '\r'
        next_
      end
    end

    def skipComment
      if @curChar == '@'
        while @curChar != '\n'
          next_
        end
      end
    end

    def get_token
      skipWhitespace
      skipComment

      token = Token.new(@curChar, TokenType::NEWLINE)

      if @curChar == '+'
        token = Token.new(@curChar, TokenType::PLUS)
      end
      if @curChar == '-'
        token = Token.new(@curChar, TokenType::MINUS)
      end
      if @curChar == '*'
        token = Token.new(@curChar, TokenType::ASTERISK)
      end
      if @curChar == '/'
        token = Token.new(@curChar, TokenType::SLASH)
      end
      if @curChar == '\n'
        @curLine += 1
        token = Token.new(@curChar, TokenType::NEWLINE)
      end
      if @curChar == '\0'
        token = Token.new(@curChar, TokenType::EOF)
      end
      if @curChar.number?
        startPos = @curPos

        while @curChar.number?
          if self.peek == '.'
            if !@curChar.number?
              puts "Illegal character in number at #{@curPos}"
            end
            while @curChar.number?
              self.next_
            end
          end
        end
        tokText = @source[startPos..@curPos + 1]
        token = Token.new(tokText, TokenType::NUMBER)
      end

      if @curChar.letter?
        startPos = @curPos
        while @curChar.letter? || @curChar.number?
          self.next_
        end
        tokText1 : String
        tokText1 = @source[startPos..@curPos + 1]
        keyword = token.check(tokText1)
        if keyword == Nil
          token = Token.new(tokText.to_s, TokenType::IDENT)
        else
          token = Token.new(tokText.to_s, keyword)
        end
      end

      self.next_
      return token
    end
  end
end
