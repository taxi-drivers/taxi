require "clim"
require "yaml"
require "colorize"
require "readline"
require "file_utils"

require "./libtaxi/*"

module Taxi
  class Cli < Clim
    main do
      desc "Taxi language Compiler."
      usage "taxi [sub_command] [arguments]"
      run do |opts, args|
        puts opts.help_string # => help string.
      end
      sub "project" do
        desc "Project management stuff."
        usage "taxi project [command] [arguments]"
        run do |opts, args|
          puts "Project management prompt. Try typing help for more info"
          loop do
            line = Readline.readline("=> ".colorize(155, 255, 64).to_s, add_history: true)
            break if line == "quit"
            if line == "make"
              puts "  Whats the project name?"
              name = Readline.readline("==> ".colorize(155, 255, 64).to_s, add_history: true)
              puts "  Whats the project license?"
              license = Readline.readline("==> ".colorize(155, 255, 64).to_s, add_history: true)
              FileUtils.mkdir(name.to_s)
              FileUtils.touch(name.to_s + "/taxi.yml")
              FileUtils.touch(name.to_s + "/main.tx")
              File.write(name.to_s + "/taxi.yml", "name: #{name.to_s}\nlicense: #{license.to_s}\nmain: ./main.tx")
            end
          end
        end
      end
      sub "run" do
        desc "run a project"
        usage "taxi run [options] [files]"
        run do |opts, args|
          data = File.open("./taxi.yml", "r") do |file|
            conf = YAML.parse file
            main = conf["main"].as_s
            input = File.read(main)

            lexer = Lexer.new(input)

            token = lexer.get_token
            while token.get_kind != TokenType::EOF
              puts(token.get_kind)
              token = lexer.get_token
            end
          end
        end
      end
    end
  end
end

Taxi::Cli.start(ARGV)
