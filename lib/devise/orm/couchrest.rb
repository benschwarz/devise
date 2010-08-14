module Devise
  module Orm
    module CouchRest
      module Hook
        def devise_modules_hook!
          extend Schema
          yield
          return unless Devise.apply_schema
          devise_modules.each { |m| send(m) if respond_to?(m, true) }
        end
      end

      module Schema
        include Devise::Schema

        # Tell how to apply schema methods
        def apply_devise_schema(name, type, options={})
          property name, type, options
        end
      end
    end
  end
end

CouchRest::Model::Base::ClassMethods.class_eval do
  include Devise::Models
  include Devise::Orm::CouchRest::Hook
end