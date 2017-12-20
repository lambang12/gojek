class GopayController < ApplicationController
  def topup
  end

  def set_topup
    response = GopayService.topup(@current_user, params[:amount])
    if response[:status] == 'OK'
      @current_user.update(gopay: response[:account][:amount])
      redirect_to user_path, notice: 'Successfully topup Go-Pay'
    else
      flash.now[:alert] = response[:status]
      render :topup
    end
  end
end
