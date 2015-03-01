action :setup
default_action :setup

attribute :collect_static, 'kind_of' => [ TrueClass, FalseClass], :default => false
migrate :migrate, 'kind_of' => [ TrueClass, FalseClass], :default => false
