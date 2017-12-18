class GopayController < ApplicationController
  # def new
  #   @user = @current_user
  # end
  
  # def create
  #   response = GopayService.register_gopay(params)
  #   if response[:Status] == 'OK'
  #     redirect_to user_path, notice: 'You can start using gopay service now'
  #   else
  #     flash.now[:alert] = response[:Status]
  #     render :new
  #   end
  # end

  def topup
  end

  def set_topup
    response = GopayService.topup(@current_user, params[:amount])
    if response[:Status] == 'OK'
      @current_user.update(gopay: response[:Account]["Amount"])
      redirect_to user_path, notice: 'Successfully topup Go-Pay'
    else
      flash.now[:alert] = response[:Status]
      render :topup
    end
  end

  def use_gopay
    response = GopayService.user(@current_user, params[:amount])
    if response[:Status] == 'OK'
      @current_user.update(gopay: response[:Account]["Amount"])
      true
    else
      flash.now[:alert] = response[:Status]
      false
    end
  end
end
