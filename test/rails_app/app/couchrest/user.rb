require 'shared_user'

class User < CouchRest::Model::Base
  def self.database
    CouchRest.new("localhost").database("devise-test-suite")
  end
  
  include Shim
  include SharedUser
end
