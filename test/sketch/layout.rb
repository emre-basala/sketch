require 'minitest/autorun'
require 'sketch/layout'

describe Sketch::Layout do
    Group = Sketch::Group

    describe "when constructed" do
	describe "with no arguments" do
	    subject { Sketch::Layout.new }

	    it "must have an identity transformation" do
		subject.transformation.identity?.must_equal true
	    end

	    it "must be empty" do
		subject.elements.size.must_equal 0
	    end
	end

	describe "with a transformation" do
	    subject { Sketch::Layout.new origin:[1,2] }

	    it "must set the transformation property" do
		subject.transformation.must_equal Geometry::Transformation.new(origin:Point[1,2])
	    end
	end
    end

    describe "when horizontal" do
	subject { Sketch::Layout.new :horizontal }

	it "must layout primitive objects" do
	    subject.push Geometry::Rectangle.new from:[0,0], to:[5,5]
	    subject.push Geometry::Rectangle.new from:[0,0], to:[6,6]

	    subject.first.must_be_kind_of Geometry::Rectangle
	    subject.last.must_be_kind_of Sketch::Group

	    subject.last.transformation.translation.must_equal Point[5,0]
	end

	it "must layout groups" do
	    group = Group.new
	    group.push Geometry::Rectangle.new from:[0,0], to:[5,5]
	    subject.push group

	    group = Group.new
	    group.push Geometry::Rectangle.new from:[0,0], to:[6,6]
	    subject.push group

	    subject.first.transformation.translation.must_be_nil
	    subject.last.transformation.translation.must_equal Point[5,0]
	end

	describe "with spacing" do
	    subject { Sketch::Layout.new :horizontal, spacing:1 }

	    it "must add space between the elements" do
		group = Group.new.push Geometry::Rectangle.new from:[0,0], to:[5,5]
		subject.push group

		group = Group.new.push Geometry::Rectangle.new from:[0,0], to:[6,6]
		subject.push group

		subject.first.transformation.translation.must_be_nil
		subject.last.transformation.translation.must_equal Point[6,0]
	    end
	end
    end

    describe "when vertical" do
	subject { Sketch::Layout.new :vertical }

	it "must layout groups" do
	    group = Group.new
	    group.push Geometry::Rectangle.new from:[0,0], to:[5,5]
	    subject.push group

	    group = Group.new
	    group.push Geometry::Rectangle.new from:[0,0], to:[6,6]
	    subject.push group

	    subject.first.transformation.translation.must_be_nil
	    subject.last.transformation.translation.must_equal Point[0,5]
	end

	describe "with spacing" do
	    subject { Sketch::Layout.new :vertical, spacing:1 }

	    it "must add space between the elements" do
		group = Group.new.push Geometry::Rectangle.new from:[0,0], to:[5,5]
		subject.push group

		group = Group.new.push Geometry::Rectangle.new from:[0,0], to:[6,6]
		subject.push group

		subject.first.transformation.translation.must_be_nil
		subject.last.transformation.translation.must_equal Point[0,6]
	    end
	end
    end
end
