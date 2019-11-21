# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def sign_in
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      remember_user(@user)
      flash.now[:success] = 'Logged in'
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'sessions/new'
    end
  end

  def sign_out # Logs out the current user.
    @current_user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def current_user # Returns the user corresponding to the remember token cookie.
    if (user_id = cookies.signed[:user_id])
      @current_user ||= User.find_by(id: user_id)
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  private

  def remember_user(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
end
