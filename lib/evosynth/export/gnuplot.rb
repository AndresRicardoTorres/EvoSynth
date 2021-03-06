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
	module Export

		# exports the contents (data) of a DataSet to gnuplot

		class Gnuplot
			attr_accessor :pngfile, :scriptfile, :datafile

			def initialize(dataset, pngfile, scriptfile = nil, datafile = nil)
				@plot_commands = []
				@dataset = dataset
				@options = ["set terminal png", "set output '#{pngfile}'"]

				if scriptfile.nil?
					@scriptfile = File.dirname(pngfile) + '/' + File.basename(pngfile, '.png') + '.gp'
				else
					@scriptfile = scriptfile
				end

				if datafile.nil?
					@datafile = File.dirname(pngfile) + '/' + File.basename(pngfile, '.png') + '.dat'
				else
					@datafile = datafile
				end
			end

			# shortcut, lets you construct a gnuplot exporter in a scoped block, to do something like:
			#
			#	EvoSynth::Output::GnuplotExporter.plot(dataset, pngfile) do |gp|
			#		gp.set_title('Rastgrin function with Elistism GA')
			#		gp.set_labels("Generationen", "")
			#		gp.plot_all_columns("lines")
			#	end

			def Gnuplot.plot(dataset, pngfile, scriptfile = nil, datafile = nil)
				gp = Gnuplot.new(dataset, pngfile, scriptfile, datafile)
				yield gp
				gp.export
			end

			def set_gnuplot_script(gnuplot_script)
				@scriptfile = gnuplot_script
			end

			def set_title(title)
				add_option("set title \"#{title}\"")
			end

			def set_labels(xlabel, ylabel)
				add_option("set xlabel \"#{xlabel}\"")
				add_option("set ylabel \"#{ylabel}\"")
			end

			def add_option(option)
				@options << option
			end

			def plot_column(column_name, style = nil)
				column_index = @dataset.column_names.index(column_name)
				raise "column '#{column_name}' not present in DataSet" if column_index.nil?

				command = "using 1:#{column_index + 2} title \"#{column_name}\""
				command += " with #{style}" unless style.nil?

				@plot_commands << command
			end

			def plot_all_columns(style = nil)
				@dataset.column_names.each { |column| plot_column(column, style) }
			end

			def export
				write_datafile
				write_gnuplot_script
				run_gnuplot
			end


			private


			def write_datafile
				File.open(@datafile,  "w+") do |file|
					file.write("# counter")
					@dataset.column_names.each { |column| file.write("\t#{column}") }

					@dataset.each_row_with_index do |row, row_number|
						file.write("\n#{row_number}")
						row.each { |column| file.write("\t#{column}")}
					end
				end
			end

			def write_gnuplot_script
				File.open(@scriptfile,  "w+") do |file|
					file.write("# Gnuplot script generated by EvoSynth - feel free to modify\n\n")
					file.write(@options.join("\n"))
					file.write("\n")

					plot_lines = "plot \"#{@datafile}\" " + @plot_commands.join(", \\\n\t\"\"")
					file.write(plot_lines)
				end
			end

			def run_gnuplot
				`gnuplot #{@scriptfile}` rescue puts "WARNING: could not find gnuplot executeable"
			end

		end
	end
end