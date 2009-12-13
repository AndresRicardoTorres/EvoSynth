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


module EvoSynth

	module Strategies

		#FIXME
		class SteadyStateGA

			def initialize(population)
				@population = population
				@parents_size
				@recombination_probability = 0.1
			end

			def run(generations)
				generations.times do |generation|
					parents = EvoSynth::Selections.fitness_proportional_selection(@population, 2)

					if rand < @recombination_probability
						c = EvoSynth::Recombinations.one_point_crossover(parents[0], parents[1])
					else
						c = parents[1]
					end
				end
			end

		end

	end

end