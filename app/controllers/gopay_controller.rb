class GopayController < ApplicationController
  def new
    @user = @current_user
  end
  
  def create
    response = GopayService.register_gopay(params)
    if response[:Status] == 'OK'
      redirect_to user_path, notice: 'You can start using gopay service now'
    else
      flash.now[:alert] = response[:Status]
      render :new
    end
  end

  def update
    response = UserService.update(user_params, session[:token])
    if response[:status] == 'OK'
      redirect_to user_index_path, notice: response[:message]
    else
      flash.now[:alert] = response[:message]
      redirect_to user_edit_path
    end
  end
end
