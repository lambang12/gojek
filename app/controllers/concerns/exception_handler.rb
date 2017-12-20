module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from Errno::ECONNREFUSED, with: :server_down
  end

  private
    def server_down
      render 'exception_handler/server_down'
    end
end