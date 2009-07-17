module Mingle4r
  module Helpers
    def Helpers.fast_token
      values = [
        rand(0x0010000),
        rand(0x0010000),
        rand(0x0010000),
        rand(0x0010000),
        rand(0x0010000),
        rand(0x1000000),
        rand(0x1000000),
      ]
      "%04x%04x%04x%04x%04x%06x%06x" % values
    end
    
    def Helpers.encode2html(string)
      html_char_map = {
  	    '[' => '%5B', ']' => '%5D',
  	    '(' => '%28', ')' => '%29',
  	    ',' => '%2C', ' ' => '%20',
  	    '=' => '%3D', '\'' => '%27',
  	    '<' => '%3C', '>' => '%3E',
  	  }

  		string.strip! if string
  		encoded_string = ''
  		string.each_char do |char|
  		  encoded_string << (html_char_map[char] || char)
      end
  		encoded_string
    end
  end
end