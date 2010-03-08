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
	module Evolvers

		# BINÄRES-HILLCLIMBING (Weicker Page 49)

		class Hillclimber
			include EvoSynth::Evolvers::Evolver

			def initialize(profile)
				init_profile :individual, :mutation, :evaluator
				use_profile profile

				@evaluator.calculate_and_set_initial_fitness(@individual)
			end

			def to_s
				"hillclimber <mutation: #{@mutation}, individual: #{@individual}>"
			end

			def best_solution
				@individual
			end

			def worst_solution
				@individual
			end

			def return_result
				@individual
			end

			def next_generation
				child = @mutation.mutate(@individual)
				@evaluator.calculate_and_set_fitness(child)
				@individual = child if child > @individual
			end
		end

	end
end
