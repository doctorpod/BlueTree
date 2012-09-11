require 'blue_tree/node'
require File.dirname(__FILE__) + '/helper'

describe BlueTree::Node do
  describe "Class defaults and settings" do
    before(:each) do
      class Foo
        include BlueTree::Node
        use_template_path fixtures
        use_template_ext  ".foo.erb"
      end
      
      class Bar
        include BlueTree::Node
      end
    end
    
    it "template_path set correctly" do
      Foo.template_path.should == fixtures
      Bar.template_path.should == File.expand_path(File.join(File.dirname(__FILE__), '..', 'templates'))
    end

    it "template_ext set correctly" do
      Foo.template_ext.should == ".foo.erb"
      Bar.template_ext.should == ".html.erb"
    end
  end
  
  describe "Building a composite page" do
    before(:each) do
      class Page
        include BlueTree::Node
        use_template_path fixtures
        use_template_ext '.txt.erb'
        attr_accessor :page_title, :introduction, :conclusion
      end

      class Section
        include BlueTree::Node
        use_template_path fixtures
        use_template_ext '.txt.erb'
        attr_accessor :title, :description
      end
  
      @page = Page.new(:page)
      @page.page_title = 'The Main Title'
      @page.introduction = 'The introduction...'
      @page.conclusion = 'The conclusion...'
      
      @child1 = Section.new(:child1)
      @child1.title = 'Section 1'
      @child1.description = 'Section 1 description...'

      @child2 = Section.new(:child2)
      @child2.title = 'Section 1.1'
      @child2.description = 'Section 1.1 description...'
      
      @child1.add_child @child2
      @page.add_child @child1
    end
    
    describe "Instance defaults" do
      it "should have correct template path" do
        @page.template_path.should == fixtures
      end

      it "should have correct template ext" do
        @page.template_ext.should == '.txt.erb'
      end
    end
    
    describe "Data access" do
      it "should have access to child nodes" do
        @page.child_nodes.should == [@child1]
      end
    
      it "should have access to parent node" do
        @child1.parent_node.should == @page
        @child2.parent_node.should == @child1
      end
    
      it "should have access to root node" do
        @child1.root_node.should == @page
        @child2.root_node.should == @page
      end
    end
    
    describe "Rendering" do
      it "leaf node should render as expected" do
        @child2.render.should == File.read(fixtures('child2.txt'))
      end
      
      it "composite page should render as expected" do
        @page.render.should == File.read(fixtures('page.txt'))
      end
      
      context "Arbitrary templates" do
        before(:each) do
          @child3 = Section.new(:child3)
          @child3.title = 'Section 1.2'
          @child3.description = 'Section 1.2 description...'
          
          @child1.add_child @child3
        end
        
        it "should render arbritary template" do
          @child3.render.should == File.read(fixtures('child3.txt'))
        end
      end
    end
  end
end
