#    Copyright (C) 2009 Yves Adler <yves.adler@googlemail.com>
#
#    This file is part of EvoSynth, a framework for rapid prototyping of
#    evolutionary and genetic algorithms.
#
#    EvoSynth is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    EvoSynth is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with EvoSynth.  If not, see <http://www.gnu.org/licenses/>.

# Author::    Yves Adler (mailto:yves.adler@googlemail.com)
# Copyright:: Copyright (C) 2009 Yves Adler
# License::   LGPLv3

require 'test/unit'
require 'evosynth'

class TestBinaryIndividual
	include EvoSynth::MinimizingIndividual

	def initialize(genome_size)
		@genome = EvoSynth::Genome.new(genome_size)
	end

	def fitness
		@fitness
	end

	def to_s
		@fitness.to_s + " - " + @genome.to_s
	end
end


class TestOneGeneFlipping < Test::Unit::TestCase

	def test_boolean_individual
		individual = TestBinaryIndividual.new(10)
		assert_equal(10, individual.genome.size)
		individual.genome.map! { |gene| true }
		individual.genome.each { |gene| assert_equal(true, gene) }
	end

	def test_boolean_flipping
		individual = TestBinaryIndividual.new(1)
		individual.genome.map! { |gene| true }

		assert_equal(true, individual.genome[0])
		mutated = EvoSynth::Mutations.one_gene_flipping(individual)
		assert_equal(false, mutated.genome[0])
		assert_equal(true, individual.genome[0])

		mutated2 = EvoSynth::Mutations.one_gene_flipping(mutated)
		assert_equal(false, mutated.genome[0])
		assert_equal(true, mutated2.genome[0])
		assert_equal(true, individual.genome[0])
	end

end