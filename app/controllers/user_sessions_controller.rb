class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_to :back, :flash => { }
    else
      redirect_to :back, :flash => { :login_error => "Login failed!" }
    end
  end

  def destroy
    logout
    redirect_to :back
  end
end
