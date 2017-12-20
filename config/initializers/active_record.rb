class ActiveRecord::Base
  cattr_accessor :skip_callbacks
  # def skip_callbacks
  #   Rails.env.test?
  # end
end