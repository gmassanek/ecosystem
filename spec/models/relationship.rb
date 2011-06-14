require 'spec_helper'

describe Relationship do
  before do
    @node1 = Fabricate(:node)
    @node2 = Fabricate(:node)
    @frag1 = Faker::Lorem.words(2).join(" ")
    @frag2 = Faker::Lorem.words(3).join(" ")
    @frag3 = Faker::Lorem.words(2).join(" ")
    @sentence1 = "#{@frag1} %1 #{@frag2} %2 #{@frag3}}"
    @sentence2 = "#{@frag3} %2 #{@frag1} %1 #{@frag2}}"
    @relationship = Relationship.new(:node1=>@node1, :node2=>@node2, :sentence1 => @sentence1, :sentence2 => @sentence2)
    @relationship.save
  end
  it "displays the relationship from node1 to node2" do
    @relationship.sentence1to2.should == "#{@frag1} #{@node1} #{@frag2} #{@node2} #{@frag3}}"
  end
  it "displays the relationship from node2 to node1" do
    @relationship.sentence2to1.should == "#{@frag3} #{@node2} #{@frag1} #{@node1} #{@frag2}}"
  end
  describe "relationship key" do
    it "replies to .key function" do
      @relationship.should respond_to(:key)
    end
    it "has the same key as the opposite relationship" do
      @relationship2 = @relationship.clone
      @relationship2.node1 = @node2
      @relationship2.node2 = @node1
      @relationship2.key.should == @relationship.key
    end
    it "restricts a key to being unique" do
      @relationship2 = @relationship.clone
      @relationship2.node1 = @node2
      @relationship2.node2 = @node1
      @relationship2.should_not be_valid
    end
    it "defaults the key and saves it" do
      @relationship.key.should_not be_nil
    end
  end
end

