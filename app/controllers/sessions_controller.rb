# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  SUPABASE_URL = ENV["SUPABASE_URL"]
  SUPABASE_API_KEY = ENV["SUPABASE_API_KEY"]

  def new
    # Render login form
  end

  def create
    email = params[:email]
    password = params[:password]

    begin
      # Initialize Supabase client
      client = Supabase::Client.from_url(SUPABASE_URL, SUPABASE_API_KEY)

      # Authenticate with Supabase
      response = client.sign_in_with_email(email, password)

      if response&.dig("error")
        flash.now[:alert] = response["error"]["message"] || "Invalid email or password"
        render :new
      else
        # Find or create the user in the local database
        user = User.find_or_create_by(email: email) do |u|
          u.username = email.split("@").first
          u.password_digest = BCrypt::Password.create(password)
        end

        # Log the user in (set session)
        session[:user_id] = user.id
        redirect_to dashboard_path, notice: "Logged in successfully!"
      end
    rescue => e
      Rails.logger.error "Login error: #{e.message}"
      flash.now[:alert] = "Login failed. Please try again."
      render :new
    end
  end

  def destroy
    begin
      client = Supabase::Client.from_url(SUPABASE_URL, SUPABASE_API_KEY)
      client.sign_out
    rescue => e
      Rails.logger.error "Logout error: #{e.message}"
    ensure
      session[:user_id] = nil
      redirect_to root_path, notice: "Logged out successfully"
    end
  end
end

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  SUPABASE_URL = ENV["SUPABASE_URL"]
  SUPABASE_API_KEY = ENV["SUPABASE_API_KEY"]

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
      client = Supabase::Client.from_url(SUPABASE_URL, SUPABASE_API_KEY)

      response = client.sign_up_with_email(email, password)

      if response&.dig("error")
        flash[:alert] = response["error"]["message"] || "Registration failed"
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
      Rails.logger.error "Registration error: #{e.message}"
      flash[:alert] = "Registration failed. Please try again."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
