#    Copyright (C) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
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


module EvoSynth

	# This class is used to create and maintain a population

	class Population
		include Comparable
		include Enumerable

		attr_accessor :individuals

		# Setup a population of individuals with the given size
		# and a block to initialize each individual

		def initialize(size = 0)
			@individuals = Genome.new(size)
			@individuals.map! { |individual| yield } if block_given?
		end

		def deep_clone
			my_clone = self.clone
			my_clone.individuals = self.individuals.clone
			self.individuals.each_index { |index| my_clone.individuals[index] = self.individuals[index].deep_clone }
			my_clone
		end

		def <=>(anOther)
			@individuals <=> anOther.individuals
		end


		def each
			@individuals.each { |individual| yield individual }
		end


		def map!
			@individuals.map! { |individual| yield individual }
		end


		def add(individual)
			@individuals << individual
		end


		def remove(individual)
			# FIXME: this is a rather ugly hack
			# -> should be replaced with a cool 1.9 function

			found = nil
			@individuals.each_index do |index|
				if @individuals[index] == individual
					found = index
					break
				end
			end

			@individuals.delete_at(found) if found != nil
		end


		def clear_all
			@individuals.clear
		end


		def best(count = 1)
			@individuals.sort!
			count == 1 ? @individuals.last : @individuals.last(count).reverse
		end


		def worst(count = 1)
			@individuals.sort!
			count == 1 ? @individuals.first : @individuals.first(count).reverse
		end


		def [](index)
			@individuals[index]
		end


		def []=(index, individual)
			@individuals[index] = individual
		end


		def empty?
			@individuals.empty?
		end


		def size
			@individuals.size
		end


		def to_s
			"Population (size=#{@individuals.size}, individuals=#{@individuals})"
		end

	end

end
