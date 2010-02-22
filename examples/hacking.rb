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
#require 'profile'


# lets find a solution for http://www.danielgrunwald.de/coding/hacking/2936.php

module Hacking

	GENOME_SIZE = 7
	ALPHABET = "abcdefghijklmnopqrstuvwxyz"

	class HackingEvaluator < EvoSynth::Core::Evaluator

		def calculate_fitness(individual)
			suma = 0.0

			individual.genome.each do |gene|
				suma *= 26
				suma += ALPHABET.index(gene) + 1
			end

			(6030912063.0 - suma).abs
		end
	end

	FLIP_CHAR = lambda { ALPHABET[rand(ALPHABET.size)] }

	profile = EvoSynth::Core::Profile.new(
		:individual			=> EvoSynth::Core::MinimizingIndividual.new( EvoSynth::Core::ArrayGenome.new(GENOME_SIZE) { ALPHABET[rand(ALPHABET.size)] }),
		:evaluator			=> Hacking::HackingEvaluator.new,
		:mutation			=> EvoSynth::Mutations::BinaryMutation.new(FLIP_CHAR)
	)

	evolver = EvoSynth::Evolvers::Hillclimber.new(profile)
	evolver.run_until_fitness_reached(0.0)
	puts "found passwort ('#{evolver.individual.genome.join("")}') after #{evolver.generations_computed} generations..."
end
