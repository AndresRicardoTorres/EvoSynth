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


require 'evosynth'


class TestMinimizingIndividual < EvoSynth::MinimizingIndividual

	def initialize(fitness = 0.0)
		@fitness = fitness
		@genome = EvoSynth::ArrayGenome.new
	end

end


class TestMaximizingIndividual < EvoSynth::MaximizingIndividual

	def initialize(fitness = 0.0)
		@fitness = fitness
		@genome = EvoSynth::ArrayGenome.new
	end

end


class TestBinaryGenomeIndividual < EvoSynth::MinimizingIndividual

	def initialize(value)
		@genome = EvoSynth::BinaryGenome.new(value)
	end

end


class TestArrayBinaryIndividual < EvoSynth::MinimizingIndividual

	def initialize(genome_size)
		@genome = EvoSynth::ArrayGenome.new(genome_size)
	end

end


class TestArrayGenomeIndividual < EvoSynth::MinimizingIndividual

	def initialize(genes)
		@fitness = 0.0
		@genome = EvoSynth::ArrayGenome.new(genes)
	end

end