Pry.config.prompt = Pry::Prompt.new(
  'custom',
  'my custom prompt',
  [proc { '::: ' }, proc { '     | ' }]
)

# switch default editor for pry to vim
Pry.config.editor = 'vim'

Dir['./lib/*.rb'].each { |f| require f }

# require "awesome_print"
# AwesomePrint.pry!

# Hit Enter to repeat last command
Pry::Commands.command /^$/ , 'repeat last command' do
  pry_instance.run_command Pry.history.to_a.last
end

require 'awesome_print'
AwesomePrint.pry!
