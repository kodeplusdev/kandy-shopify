KandyApp::Application.routes.draw do

  controller :sessions do
    get 'login' => :new, :as => :login
    post 'login' => :create, :as => :authenticate
    get 'auth/shopify/callback' => :callback
    get 'logout' => :destroy, :as => :logout
  end

  controller :home do
    get 'error' => :error
  end

  namespace :webhooks do
    scope :sms do
      controller :sms do
        post 'order-creation' => :order_creation
        post 'order-update' => :order_update
        post 'order-payment' => :order_payment
        # post 'order-fulfillment' => :order_fulfillment
        post 'customer-creation' => :customer_creation
      end
    end
    controller :uninstalled do
      post 'app/uninstalled' => :index
    end
  end

  scope 'preferences' do
    controller :preferences do
      get '/' => :index, as: :preferences
      get 'api-keys' => :api_keys, as: 'api_keys'
      get 'kandy-account' => :kandy_account, as: 'kandy_account'
      get 'sms-alert-templates' => :sms_alert_templates, as: 'sms_alert_templates'
      get 'chat-box-widget' => :chat_box_widget, as: 'chat_box_widget'
      get 'chat-box-widget-preview' => :chat_box_widget_preview, as: 'chat_box_widget_preview'
      post 'update' => :update
    end
  end

  scope '/help' do
    controller :help do
      get 'variables' => :variables
    end
  end

  scope '/app' do
    controller :shopify do
      get 'installed' => :installed
      get 'script-tags' => :script_tags
    end
  end

  root :to => 'home#index'
end
