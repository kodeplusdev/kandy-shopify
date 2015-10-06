KandyApp::Application.routes.draw do

  controller :sessions do
    get 'login' => :new, :as => :login
    post 'login' => :create, :as => :authenticate
    get 'auth/shopify/callback' => :callback
    get 'logout' => :destroy, :as => :logout
  end

  controller :home do
    get 'preferences' => :preferences
    post 'preferences' => :update_preferences
    get 'install' => :install
    get 'help' => :help
    get 'error' => :error
  end

  scope '/sms' do
    controller :sms do
      post 'order-creation' => :order_creation
      post 'order-update' => :order_update
      post 'order-payment' => :order_payment
      post 'order-fulfillment' => :order_fulfillment
      post 'customer-creation' => :customer_creation
    end
  end

  post 'app/uninstalled', to: 'shopify#uninstalled'

  root :to => 'home#index'
end
