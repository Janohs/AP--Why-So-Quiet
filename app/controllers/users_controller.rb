class UsersController < ApplicationController
  require "supabase"

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation)
    username = user_params[:username]
    email = user_params[:email]
    password = user_params[:password]
    password_confirmation = user_params[:password_confirmation]

    if password != password_confirmation
      flash[:alert] = "Passwords do not match"
      render :new
      return
    end

    begin
      supabase = Supabase.client(
        supabase_url: ENV["SUPABASE_URL"],
        supabase_key: ENV["SUPABASE_API_KEY"]
      )

      response = supabase.auth.sign_up_by_email(email, password)

      if response.error
        flash[:alert] = response.error.message
        render :new
      else
        # Store user information in your local database
        user = User.create(
          username: username,
          email: email,
          password_digest: BCrypt::Password.create(password)
        )
        session[:user_id] = user.id
        redirect_to dashboard_path, notice: "Account created successfully"
      end
    rescue => e
      flash[:alert] = "Registration failed: #{e.message}"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
