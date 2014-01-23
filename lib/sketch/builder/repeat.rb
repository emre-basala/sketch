require_relative '../../geometry/dsl/turtle'

class Sketch
    class Builder
	class Repeat
	    attr_accessor :direction

	    include Geometry::DSL::Turtle

	    # Convenience method for evaluating a repeated {Turtle} block
	    # @param from   [Point]	the starting point of the repetition
	    # @param to	    [Point]	the endpoint
	    # @param count  [Number]	the number of repetitions
	    def self.build(from, to, count, *args, &block)
		self.new(from).build(to, count, &block)
	    end

	    # @param from [Point]   the {Point} where it all starts
	    def initialize(from)
		@direction = Vector[0,0]
		@from = Point[from]
		@points = []
	    end

	    # Evaluate a block and return a new {Path}
	    #  Use the trick found here http://www.dan-manges.com/blog/ruby-dsls-instance-eval-with-delegation
	    #  to allow the DSL block to call methods in the enclosing *lexical* scope
	    # @param to	    [Point]	the destination
	    # @param count  [Number]	the number of steps to take
	    # @return [Array<Point>]	the generated {Point}s
	    def build(to, count, &block)
		if block_given?
		    @self_before_instance_eval = eval "self", block.binding
		    current = last
		    to = Point[to]  # just in case

		    # Determine the step size from the destination and the repetition count
		    delta = to - last
		    step = delta.normalize * delta.magnitude/count

		    count.times do
			# On every eval, reset direction to point along the baseline
			@direction = (to - @from).normalize
			self.instance_exec step.magnitude, &block

			# Return to the baseline after every block
			current = current + step
			push current unless last == current
		    end
		end
		@points
	    end

	    # The second half of the instance_eval delegation trick mentioned at
	    #   http://www.dan-manges.com/blog/ruby-dsls-instance-eval-with-delegation
	    def method_missing(method, *args, &block)
		@self_before_instance_eval.send method, *args, &block
	    end

	    def last
		@points.last || @from
	    end

	    def push(arg)
		@points.push arg
	    end
	end
    end
end
