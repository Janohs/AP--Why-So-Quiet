# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
    # Render the login form
  end

  def create
    # Handle login logic here (authentication)
    redirect_to dashboard_index_path # Redirect to dashboard after successful login
  end

  def destroy
    # Handle logout logic here
    redirect_to root_path
  end

  # To do : make sure if logged in, no need to re login again
end
