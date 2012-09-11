# BlueTree

Bluetree is a module of methods which allow you to create composable view 
classes. Each class instance is initialized with an ERB template. The 
templates of these views have access to all local instance variables and 
methods plus access to the immediate parent and root node objects.

## Installation

Add this line to your application's Gemfile:

    gem 'blue_tree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blue_tree

## Usage

Say you wanted to create a composite view using a couple of different classes:

    require 'blue_tree'
    
    class Page
      include BlueTree::Node
      use_template_path "path/to/my/templates" # defaults to "YOUR_GEM_PATH/templates"
      use_template_ext  ".foo.erb"             # defaults to ".html.erb"
      
      attr_reader :page_title, :introduction, :conclusion
      # More Page specific code...
    end
    
    class Section
      include BlueTree::Node

      attr_reader :title, :description
      # More Section specific code...
    end
    
Set up your nodes (The symbol argument is the basename of the ERB template 
file):
    
    main_page   = Page.new(:page_template)
    section     = Section.new(:section_template)
    sub_section = Section.new(:sub_section_template)
    
Compose your nodes:

    section.add_child sub_section
    main_page.add_child section
    
What you can reference in the templates:

  * any methods and variables in the current object
  * *children_nodes* - returns an array of child node objects
  * *parent_node* - returns the immediate parent object
  * *root_node* - returns the root object

So for example, the sub_section template might look like this:

    <h2><%= title %> (Part of the <%= root_node.page_title %> series)</h2>
    <p>This follows on from the <%= parent_node.title %> section.</p>
    <p><%= description %></p>
    
It's up to the templates to render any children nodes - so the main page 
template might look like this (the trailing dash notation is accepted):

    <h1><%= page_title %></h1>
    <p><%= introduction %></p>
    <% child_nodes.each do |c| -%>
      <%= c.render %>
    <% end -%>
    <p><%= conclusion %></p>

Rendering:
    
    main_page.render # => returns the recursively rendered string
    
### Rendering arbitrary templates

You can also render templates not associated with any nodes by using the 
*render_template* method. This can be useful if you want to reuse common
templates like headers or footers. The template must exist in your
*template_path*. Like any node, it has access to all variables and methods in the 
current object, the parent object and the root object:

    ...
    <%= render_template(:common_footer_template) %>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
