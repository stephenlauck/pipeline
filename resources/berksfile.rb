actions :create

attribute :group, :kind_of => String
attribute :berksfile, :kind_of => String
attribute :commands_template, :kind_of => String

def initialize(*args)
  super
  @action = :create
end
