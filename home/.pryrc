#Pry.config.prompt = [proc { "ᚹᚱᛘ ᛬ " },
                     #proc { "     | " }]

Pry.config.prompt = [proc { "::: " },
                     proc { "     | " }]

# switch default editor for pry to vim
Pry.config.editor = "vim"

Dir['./lib/*.rb'].each { |f| require f }

#require "awesome_print"
#AwesomePrint.pry!

# Hit Enter to repeat last command
Pry::Commands.command /^$/, "repeat last command" do
  _pry_.run_command Pry.history.to_a.last
end
