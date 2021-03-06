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


require 'shoulda'

require 'evosynth'


class EntropyDiversityTest < Test::Unit::TestCase

	context "the entropy diversity run on a simple example" do

		setup do
			@i1 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,1,1,0,1]) )
			@i2 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([1,1,0,0,0]) )
			@i3 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,0,1,1,1]) )
			@i4 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([1,0,1,0,1]) )
			@i5 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([1,1,0,1,1]) )
			@i6 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,0,0,0,0]) )
			@pop = EvoSynth::Population.new([@i1, @i2, @i3, @i4, @i5, @i6])
		end

		should "th diversity for the population be 0.6705" do
			assert_in_delta(0.6705, EvoSynth::EvoBench.diversity_entropy(@pop), 0.0009)
		end

	end

	context "the entropy diversity run on another simple example" do

		setup do
			@i1 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,0,0,1]) )
			@i2 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,0,1,1]) )
			@i3 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([1,1,1,1]) )
			@pop = EvoSynth::Population.new([@i1, @i2, @i3])
		end

		should "th diversity for the population be 0.4774" do
			assert_in_delta(0.4774, EvoSynth::EvoBench.diversity_entropy(@pop), 0.0009)
		end
	end

	context "the subsequence diversity run on yet another simple example" do

		setup do
			@i1 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,0,1,1]) )
			@i2 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,1,1,0]) )
			@i3 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([1,1,0,0]) )
			@pop = EvoSynth::Population.new([@i1, @i2, @i3])
		end

		should "th diversity for the population be 0.6365" do
			assert_in_delta(0.6365, EvoSynth::EvoBench.diversity_entropy(@pop), 0.0009)
		end
	end

end