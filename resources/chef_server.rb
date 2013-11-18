actions :create#, :update, :delete, :build, :disable, :enable

attribute :user_pem, :kind_of => String
attribute :validation_pem, :kind_of => String
attribute :url, :kind_of => String

def initialize(*args)
  super
  @action = :create
end
