

class BerkDSL
  class Cookbook
    attr_accessor :label, :options

    def initialize(label, options)
      @label   = label
      @options = options
    end
  end

  class Group
    attr_accessor :label, :cookbooks

    def initialize(label)
      @label     = label
      @cookbooks = []
    end
  end


  attr_accessor :groups

  def initialize(filename)
    @context = 'berkfile'
    @groups  = {}

    self.instance_eval( File.read(filename) )
  end

  def method_missing(method, *args, &block)
    puts "#{method} is missing."
  end

  def cookbook(label, options={})
    puts "Cookbook: #{label}, Options: #{options.inspect}"
    current_group.cookbooks << Cookbook.new(label, options)
  end

  def group(label)
    puts "Group: #{label}"

    old_context = @context
    @context = label
    yield
    @context = old_context
  end

protected

  def current_group
    @groups[@context] = Group.new(@context) if @groups[@context].nil?

    return @groups[@context]
  end
end


