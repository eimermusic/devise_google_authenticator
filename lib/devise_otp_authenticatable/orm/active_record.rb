require 'active_record/connection_adapters/abstract/schema_definitions'

module DeviseOtpAuthenticator
  module Orm
    # This module contains handle schema (migrations):
    #
    #  create_table :accounts do |t|
    #    t.gauth_secret
    #    t.gauth_enabled
    #  end
    #

    module ActiveRecord
      module Schema
        include DeviseOtpAuthenticator::Schema
      end
    end

  end
end

ActiveRecord::ConnectionAdapters::Table.send :include, DeviseOtpAuthenticator::Orm::ActiveRecord::Schema
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, DeviseOtpAuthenticator::Orm::ActiveRecord::Schema
