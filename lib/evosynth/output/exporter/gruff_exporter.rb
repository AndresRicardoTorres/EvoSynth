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


require 'observer'


module EvoSynth
	module Output

		class GruffExporter

			def initialize(logger)
				begin
					require 'gruff'
				rescue
					puts "Could not require 'gruff' gem, please install with gem install gruff"
				end

				@logger = logger
			end

			def export(title, filename)
				x, ys = [], []
				data_sets = 0
				@logger.data.each_pair do |key, value|
					data_sets = value.size if value.size > data_sets
					x << key
					value.each_with_index do |y, index|
						ys[index] = [] if ys[index].nil?
						ys[index] << y
					end
				end

				g = Gruff::Line.new
				g.title = title

				data_sets.times { |set|	g.data(@logger.column_names[set], ys[set]) }

				labels = {}
				x.each_with_index { |gen, index| labels[index] = "#{gen}"}
				g.labels = labels

				g.write(filename)
			end

		end

	end
end