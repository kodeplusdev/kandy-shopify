KandyApp::Application.routes.draw do

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      invitations: 'users/invitations'
  }

  devise_scope :user do
    namespace :users do
      scope 'manage' do
        controller :manage do
          get '/' => :index, as: 'manage'
          get '/edit/:id' => :edit, as: 'manage_edit'
          post '/edit/:id' => :update
          delete '/edit/:id' => :destroy
        end
      end
    end
  end

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
    scope 'sms' do
      controller :sms do
        post 'order-creation' => :order_creation
        post 'order-update' => :order_update
        post 'order-payment' => :order_payment
        # post 'order-fulfillment' => :order_fulfillment
        post 'customer-creation' => :customer_creation
      end
    end
    controller :shop do
      post 'shop/update' => :update
      end
    controller :uninstalled do
      post 'app/uninstalled' => :index
    end
  end

  scope 'preferences' do
    controller :preferences do
      get '/' => :index, as: :preferences
      get 'api-keys' => :api_keys, as: 'api_keys'
      get 'sms-alert-templates' => :sms_alert_templates, as: 'sms_alert_templates'
      get 'chat-box-widget' => :chat_box_widget, as: 'chat_box_widget'
      get 'chat-box-widget-preview' => :chat_box_widget_preview, as: 'chat_box_widget_preview'
      post '/' => :update
    end
    controller :transcripts do
      get '/transcripts' => :index, as: 'chat_transcripts'
      get '/transcripts/:id' => :view, as: 'chat_transcript'
      delete 'transcripts' => :destroy
      match 'transcripts' => :archive, via: [:put, :patch]
    end
    controller :reports do
      get '/reports' => :index
    end
  end

  scope 'help' do
    controller :help do
      get 'variables' => :variables
    end
  end

  scope 'chat' do
    controller :chat do
      post 'widget' => :widget, as: 'chat_widget'
      get 'online' => :check, as: 'chat_check_online'
      post 'online' => :ping, as: 'chat_ping_online'
      post 'change-user-status' => :change_user_status, as: 'change_user_status'
      post 'request' => :request_chat, as: 'chat_request'
      post 'join' => :join_chat, as: 'chat_join'
      post 'leave' => :leave_chat, as: 'chat_leave'
      post 'close' => :close_chat, as: 'chat_close'
      post 'save' => :save_message, as: 'chat_save'
      post 'rating' => :rating, as: 'chat_rating'
      get 'load' => :load_chat, as: 'chat_load'
      post 'send-mail' => :send_mail, as: 'chat_send_mail'
      post 'send-mail-transcript' => :send_mail_transcript, as: 'chat_send_mail_transcript'
      get 'download' => :download, as: 'chat_download'
      delete 'ban' => :ban, as: 'chat_ban'
    end
  end

  scope 'app' do
    controller :shopify do
      get 'script-tags' => :script_tags
    end
    scope 'installed' do
      controller :installed do
        get '/' => :index, as: 'app_installed'
        post 'kandy_account' => :set_kandy_account, as: 'app_installed_kandy_account'
        post 'admin_account' => :set_admin_account, as: 'app_installed_admin_account'
      end
    end
  end

  root :to => 'home#index'
end
