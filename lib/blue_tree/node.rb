require 'erb'

module BlueTree
  module Node
    attr_reader :child_nodes, :parent_node, :root_node
    
    module ClassMethods
      def use_template_path(path)
        @template_path = path
      end
      
      def template_path
        @template_path
      end
    
      def use_template_ext(ext)
        @template_ext = ext
      end
    
      def template_ext
        @template_ext
      end
    end
  
    def self.included(base)
      base.extend ClassMethods
      base.use_template_path(
        File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'templates'))
      )
      base.use_template_ext '.html.erb'
    end
    
    def initialize(template_symbol)
      @template = template_contents(template_symbol)
      @child_nodes = []
      @parent_node = nil
      @root_node = nil
    end
    
    def template_path
      self.class.template_path
    end
    
    def template_ext
      self.class.template_ext
    end
    
    def template_contents(template_symbol)
      File.read(File.join(template_path, "#{template_symbol}#{template_ext}"))
    end
    
    def add_child(child)
      child.set_root_node(@root_node || self)
      child.set_parent_node self
      @child_nodes << child
    end
    
    def set_root_node(root_node)
      @root_node = root_node
      child_nodes.each { |child| child.set_root_node(root_node) }
    end
    
    def set_parent_node(parent)
      @parent_node = parent
    end
  
    def render
      ERB.new(@template, nil, '-').result(binding)
    end
    
    def render_template(template_symbol)
      ERB.new(template_contents(template_symbol), nil, '-').result(binding)
    end
  end
end