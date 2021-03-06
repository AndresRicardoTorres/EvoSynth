#	Copyright (c) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
#
#	Permission is hereby granted, free of charge, to any person
#	obtaining a copy of this software and associated documentation
#	files (the "Software"), to deal in the Software without
#	restriction, including without limitation the rights to use,
#	copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the
#	Software is furnished to do so, subject to the following
#	conditions:
#
#	The above copyright notice and this permission notice shall be
#	included in all copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#	OTHER DEALINGS IN THE SOFTWARE.


module EvoSynth

	# This class is used to create and maintain a evolver configuration. Basically a Configuration can be seen
	# as a dynamic Hash, where values can be added and removed at will.

	class Configuration

		# TODO: rdoc or remove!

		attr_accessor :properties

		# Creates a new Configuration using a given hash of symbols and values.
		# 
		# usage:
		#
		#    configuration = EvoSynth::Configuration.new(
		#        :individual      => MaxOnes.create_individual,
		#        :population      => EvoSynth::Population.new(POP_SIZE) { MaxOnes.create_individual },
		#        :evaluator       => MaxOnes::MaxOnesEvaluator.new,
		#        :mutation        => EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		#    )
		#
		# or:
		# 
		#	configuration = EvoSynth::Configuration.create do |conf|
		#	    conf.individual = MaxOnes.create_individual
		#	    conf.population = EvoSynth::Population.new(POP_SIZE) { MaxOnes.create_individual }
		#	    conf.evaluator  = MaxOnes::MaxOnesEvaluator.new
		#	    conf.mutation   = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		#	end

		def initialize(*properties) #:yields: self
			@properties = {}

			properties.each do |property|
				if property.is_a?(Symbol)
					add_symbol(property, nil)
				elsif property.is_a?(Hash)
					add_hash(property)
				else
					raise ArgumentError, "argument type not supported"
				end
			end

			yield self if block_given?
		end

		# Used to dynamically add key/value pairs.
		#
		#    p = EvoSynth::Configuration.new
		#    p.foo                        #=> raises ArgumentError
		#    p.foo = "bar"                #=> adds key 'foo' to p and sets its value to 'bar'
		#    p.foo                        #=> 'bar'

		def method_missing(method_name, *args)
			if method_name[-1] == "="
				args = args[0] if args.size == 1
				add_symbol(method_name[0..method_name.size-2].to_sym, args)
			else
				raise ArgumentError.new("Configuration does not contain a value for '#{method_name}'.") unless @properties.has_key?(method_name)
				@properties[method_name]
			end
		end

		#	:call-seq:
		#		delete(key) -> nil or key
		#
		# Removes a given key from the configuration. Returns the key if it was member of the configuration, nil otherwise.
		#
		#    p = EvoSynth::Configuration.new
		#    p.foo = "bar"                    #=> adds key 'foo' to p and sets its value to 'bar'
		#    p.delete(:foo)                   #=> 'bar'
		#    p.foo                            #=> raises ArgumentError

		def delete(key)
			@properties.delete(key)
		end

		# Return a printable version of the configuration.

		def to_s
			"evolver configuration <#{@properties.to_s}>"
		end

		#Return a deep copy of the configuration

		def deep_clone
			my_clone = self.clone
			my_clone.properties = @properties.clone
			my_clone.properties.each_key do |key|
				unless [ true, false, nil ].include?(my_clone.properties[key]) \
							|| my_clone.properties[key].is_a?(Numeric)
					if my_clone.properties[key].is_a?(String) \
					|| my_clone.properties[key].is_a?(Range) \
					|| my_clone.properties[key].is_a?(Proc)
						my_clone.properties[key] = my_clone.properties[key].clone
					else
						my_clone.properties[key] = my_clone.properties[key].deep_clone
					end
				end
			end
			my_clone
		end

		private

		# Adds a given symbol as key to the internal Hash and sets the value to the given value.

		def add_symbol(symbol, value)
			@properties[symbol] = value
		end

		# Add a given hash to the internal hash.

		def add_hash(hash)
			hash.each_pair { |key, default_value| @properties[key] = default_value }
		end

	end

end
