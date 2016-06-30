module Codily
  class Dumper
    def initialize(root)
      @root = root
    end

    attr_reader :root

    def tree
      # :children:
      #   service: (element_tree)
      #     KEY:
      #       :self: Elements::Base
      #       :children:
      #         healthcheck:
      #           KEY:
      #             :self: Elements::Base
      @tree ||= {self: root, children: {}}.tap do |tree|
        root.elements.each_key.sort_by { |klass| klass.path.size }.each do |klass|
          elements = root.list_element(klass)
          elements.each do |key, element|
            parents = element.parents
            subtree = parents.inject(tree) { |r,i| r[:children][i.class.name_for_attr][i.key] }
            (subtree[:children][element.class.name_for_attr] ||= {})[element.key] = {self: element, children: {}}
          end
        end
      end
    end

    def simple_tree
      simplize_tree tree
    end

    def ruby_code
      "#{dump_ruby_code(tree)}\n"
    end
    
    private

    def simplize_tree(leaf)
      {}.tap do |tree|
        tree.merge! leaf[:self].as_dsl_hash
        leaf[:children].each do |name, children|
          tree[name] = {}
          children.each do |key, child|
            tree[name][child[:self].dsl_args] = simplize_tree(child)
          end
        end
      end
    end

    def dump_ruby_code(tree, level=0)
      indent = '  ' * level
      lines = []

      attrs =tree[:self].as_dsl_hash
      attrs.each do |key, value|
        value_str = value.inspect
        if value.kind_of?(Hash)
          value_str = value_str.gsub(/\A{|}\z/, '')
        end
        lines << "#{indent}#{key} #{value_str}"
      end

      lines << nil if !attrs.empty? && !tree[:children].empty?

      tree[:children].each_with_index do |(name, children), i|
        lines << nil if i > 0
        children.each_with_index do |(key, child), j|
          lines << nil if j > 0

          value_str = child[:self].dsl_args.map(&:inspect).join(?,)
          if child[:self].dsl_args.size == 1 && child[:self].dsl_args[0].kind_of?(Hash)
            value_str = value_str.gsub(/\A{|}\z/, '')
          end

          lines << "#{indent}#{name} #{value_str} do"
          lines << dump_ruby_code(child, level.succ)
          lines << "#{indent}end"
        end
      end

      lines.join("\n").gsub(/ do\n\n\s+end/,'')
    end
  end
end
