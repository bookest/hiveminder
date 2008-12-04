module Hiveminder
  module Locator
    def self.encode(arg)
      raise ArgumentError.new unless arg.kind_of?(Integer)
      numbers = []
      while arg != 0
        numbers.unshift(arg % 32)
        arg = (arg / 32).to_int
      end
      numbers.map { |n| @int_to_char[n] }.join('')
    end

    def self.decode(arg)
      num = 0
      arg.upcase.split('').each do |c|
        value = @char_to_int[c]
        raise ArgumentError.new("Invalid character: #{c}") if value.nil?
        num = (num * 32) + value
      end
      num
    end

    private
    def self.init
      @int_to_char = { }
      @char_to_int = { }
      chars = [ '2'..'9', 'A', 'C' .. 'R', 'T' .. 'Z' ].map { |e| e.to_a }.flatten
      chars.each_with_index do |elm, i|
        @int_to_char[i] = elm
        @char_to_int[elm] = i
      end

      remap = {
        '0' => 'O',
        '1' => 'I',
        'S' => 'F',
        'B' => 'P',
      }
      remap.each { |k,v| @char_to_int[k] = @char_to_int[v] }
    end

    init
  end
end
