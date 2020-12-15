# frozen_string_literal: true

require 'amazing_print'
AmazingPrint.irb!

IRB.conf[:PROMPT][:CUSTOM] = {
  PROMPT_I: '>> ',
  PROMPT_S: '%l>> ',
  PROMPT_C: '.. ',
  PROMPT_N: '.. ',
  RETURN: '=> %s\n'
}
IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:AUTO_INDENT] = true
