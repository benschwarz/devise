require 'shared_admin'

class Admin < CouchRest::Model::Base
  include Shim
  include SharedAdmin
end
