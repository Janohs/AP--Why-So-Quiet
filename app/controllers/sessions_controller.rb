class SessionsController < ApplicationController
  def create
    # Find the user by email
    @user = User.find_by(email: params[:email])

    # Authenticate the user with the provided password
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Login successful!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
