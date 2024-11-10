Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  # Dashboard route (Landing page for logged-in users)
  get "dashboard", to: "dashboard#index", as: :dashboard

  # Login and logout routes
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Sign-up routes
  get "signup", to: "users#new", as: :signup           # Route to display the signup form
  post "signup", to: "users#create"                    # Route to handle signup submission

  # Password reset routes
  resources :password_resets, only: [ :new, :create, :edit, :update ]

  # Root path points to the welcome page (Home page for non-logged-in users)
  root "pages#welcome" # Redirect to welcome page instead of login page

  # Redirect dashboard/index to dashboard for cleaner URL
  get "dashboard/index", to: redirect("/dashboard")

  # Canteen path (path to canteen module)
  get "canteen", to: "canteen#index", as: :canteen
end
