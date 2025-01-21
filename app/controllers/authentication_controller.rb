class AuthenticationController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:user][:email])
    if @user&.authenticate(params[:user][:password])
      token = JsonWebToken.encode(user_id: @user.id)
      refresh_token = JsonWebToken.encode(user_id: @user.id, exp: 7.days.from_now.to_i)
      time = Time.now + 24.hours.to_i
      render json: {
        id: @user.id,
        email: @user.email,
        token: token,
        refresh_token: refresh_token
        }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
