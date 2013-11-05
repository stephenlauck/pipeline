# install berkshelf gem
gem_package "foodcritic" do
  gem_binary("/opt/chef/embedded/bin/gem")
  version "3.0.3"
end