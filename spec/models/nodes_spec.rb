require 'spec_helper'

describe Node do
  before do
    @node = Fabricate(:node)
  end
  it "is invalid without a title" do
    @node.title = nil
    @node.should_not be_valid
  end
  context "slugs" do
    it "saves it's title as a slug" do
      @node = Fabricate(:node, :title => "Test")
      @node.save
      @node.cached_slug.should == "test"
    end
  end
  it "prevents duplicate titles" do
    @node2 = Fabricate(:node)
    @node2.title = @node.title
    @node2.should_not be_valid
  end
  it "is invalid without a description" do
    @node.description = nil
    @node.should_not be_valid
  end
  it "responds to relationships" do
    @node.should respond_to(:relationships)
  end
  it "responds to related_nodes" do
    @node.should respond_to(:related_nodes)
  end
  it "gives you all relationships that include it" do
    @node2 = Fabricate(:node)
    @node3 = Fabricate(:node)
    @rel = Relationship.create(:node1 => @node, :node2 => @node2, :sentence1 => "%1 %2", :sentence2 => "%2 %1")
    @rel2 = Relationship.create(:node1 => @node3, :node2 => @node, :sentence1 => "%1 %2", :sentence2 => "%2 %1")
    @node.relationships.should include(@rel)
    @node.relationships.should include(@rel2)
  end
  it "gives you all related nodes" do
    @node2 = Fabricate(:node)
    @node3 = Fabricate(:node)
    @rel = Relationship.create(:node1 => @node, :node2 => @node2, :sentence1 => "%1 %2", :sentence2 => "%2 %1")
    @rel2 = Relationship.create(:node1 => @node3, :node2 => @node, :sentence1 => "%1 %2", :sentence2 => "%2 %1")
    @node.related_nodes.should include(@node2)
    @node.related_nodes.should include(@node3)
  end
  it "has a homepage" do
    @node.should be_valid
  end
  it "should order the links alphabetically" do
    @node2 = Fabricate(:node)
    @node3 = Fabricate(:node)
    @node.title = "G title"
    @node.save
    @node2.title = "A title"
    @node2.save
    @node3.title = "Z title"
    @node3.save
    Node.all.first.should == @node2
    Node.all.last.should == @node3
    Node.all.second.should == @node
  end
  it "accepts valid URLs" do
    validURLs = [
          "http://www.google.com",
          "https://hello"
    ]
    validURLs.each do |url|
      @node.homepage = url
      @node.should be_valid
    end
  end
  it "rejects invalid URLs" do
    invalidURLs = [
          "google.com",
          "hello",
          "www.google.com"
    ]
    invalidURLs.each do |url|
      @node.homepage = url
      @node.should_not be_valid
    end
  end
  describe "can have links associated" do
    it "responds to links" do
      @node.should respond_to(:links)
    end
    it "accepts attributes for a link" do
      node = Fabricate(:node)
      node.update_attributes :links_attributes => [{:url => 'http://www.google.com'}]
      @node.save.should == true
    end
    it "accepts attributes for multiple links" do
      node = Fabricate(:node)
      node.update_attributes :links_attributes => [{:url => 'http://www.google.com'}, {:url => 'http://www.yahoo.com'}]
      @node.save.should == true
    end
    it "can save with a link" do
      @node = Fabricate(:node_with_links)
      @node.links.count.should == 3
    end
  end
  describe "site handles" do
    it "responds to site handles" do
      @node.should respond_to(:site_handle)
    end
    it "accepts attributes for a site handle" do
      node = Fabricate(:node)
      node.update_attributes :site_handle_attributes => {:github => 'gmassanek'}
      @node.save.should == true
    end
    it "can save with a link" do
      @node = Fabricate(:node_with_site_handles)
      @node.handles["github"].should_not be_nil
    end
    it "responds to .handles" do
      @node.should respond_to(:handles)
    end
  end
end

