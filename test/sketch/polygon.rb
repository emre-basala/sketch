require 'minitest/autorun'
require 'sketch'

describe Sketch do
    let(:sketch)    { Sketch.new }

    it "should make a square polygon using turtle-like commands" do
	skip
	polygon = sketch.add_polygon do
	    start_at [0,0]
	    move_to [1,0]
	    turn_left 90
	    move 1
	    turn_left 90
	    forward 1
	end
	assert_kind_of(Sketch::Polygon, polygon)
	assert_equal(1, sketch.elements.size)
	assert_equal(4, polygon.vertices.size)
	assert_equal(Point[0,0], polygon.vertices[0])
	assert_equal(Point[1,0], polygon.vertices[1])
	assert_equal(Point[1,1], polygon.vertices[2])
#	assert_equal(Point[0,1], polygon.vertices[3])
    end

    it "should make another square polygon using turtle-like commands" do
	skip
    	polygon = sketch.add_polygon do
	    start_at [0,0]
	    move [1,0]
	    move [0,1]
	    move [-1,0]
	end
	assert_kind_of(Sketch::Polygon, polygon)
	assert_equal(1, sketch.elements.size)
	assert_equal(4, polygon.vertices.size)
	assert_equal(Point[0,0], polygon.vertices[0])
	assert_equal(Point[1,0], polygon.vertices[1])
	assert_equal(Point[1,1], polygon.vertices[2])
	assert_equal(Point[0,1], polygon.vertices[3])
    end
end
