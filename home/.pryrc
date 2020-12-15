Pry.config.prompt = Pry::Prompt.new(
  'custom',
  'my custom prompt',
  [proc { '::: ' }, proc { '     | ' }]
)

# switch default editor for pry to vim
Pry.config.editor = 'vim'

Dir['./lib/*.rb'].each { |f| require f }

# Hit Enter to repeat last command
Pry::Commands.command /^$/ , 'repeat last command' do
  pry_instance.run_command Pry.history.to_a.last
end

# $LOAD_PATH << '/Users/pelensky/.rvm/gems/ruby-2.6.6/gems/awesome_print-1.8.0/lib/awesome_print.rb'
require 'amazing_print'
AmazingPrint.pry!
