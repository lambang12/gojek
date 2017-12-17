class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize
  protect_from_forgery with: :null_session

  protected
    def authorize
      @current_user = User.find_by(id: session[:gojek_user_id])
      unless @current_user
        redirect_to login_url, notice: 'Please Login'
      else
        @current_user = @current_user.decorate
      end
    end
end
