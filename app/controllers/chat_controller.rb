class ChatController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:widget, :save_message]
  skip_filter :shopify_session, except: [:load_chat, :ping, :change_user_status, :join_chat, :leave_chat, :download]
  before_action :authenticate_user!, only: [:load_chat, :ping, :change_user_status, :join_chat, :leave_chat, :send_mail_transcript]

  def widget
    @shop = Shop.find(params[:id])
    @conversation = Conversation.open.find(params[:chat_id])
  rescue ActiveRecord::RecordNotFound
  ensure
    render layout: false
  end

  def request_chat
    @shop = Shop.find(params[:id])
    @conversation = @shop.conversations.create(name: params[:name], email: params[:email], location: params[:location], messages: [])
    @users = @shop.users.online
    render layout: false
  end

  def load_chat
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    @users = @shop.users.all
    @conversations = @shop.conversations.open.where(deleted: false, archived: false)
    render layout: false
  end

  def save_message
    @conversation = Conversation.find(params[:id])
    @conversation.messages << params[:message]
    @conversation.save!
  rescue ActiveRecord::RecordNotFound
    head :not_found
  ensure
    render nothing: true
  end

  def join_chat
    @conversation = Conversation.find(params[:id])
    @conversation.users << current_user
    @conversation.save!
  rescue ActiveRecord::RecordNotFound
    head :not_found
    @status = false
  ensure
    @status = true
    render layout: false
  end

  def leave_chat
    @conversation = Conversation.find(params[:id])
    @conversation.users.delete current_user
    @conversation.save!
  rescue ActiveRecord::RecordNotFound
    head :not_found
    @status = false
  ensure
    @status = true
    render layout: false, action: :join_chat
  end

  def close_chat
    @conversation = Conversation.find(params[:id])
    @conversation.status = Conversation::CLOSE
    @conversation.save!
  rescue ActiveRecord::RecordNotFound
    head :not_found
    @status = false
  ensure
    @status = true
    render layout: false, action: :join_chat
  end

  def rating
    @conversation = Conversation.find(params[:chat_id])
    if %w(like dislike).include?(params[:rating])
      @conversation.rating = params[:rating]
      @conversation.save!
    end
  rescue ActiveRecord::RecordNotFound
    head :not_found
  ensure
    render nothing: true
  end

  def send_mail
    render nothing: true
  end

  def send_mail_transcript
    render layout: false, json: {status: true}
  end

  def download
    @conversation = Conversation.find(params[:id])
    send_data @conversation.download, filename: "#{@conversation.title}-#{@conversation.created_at}.txt"
  end

  def ban
    render layout: false, json: {status: true}
  end

  def ping
    render layout: false
  end

  def check
    @shop = Shop.find(params[:id])
    @users = @shop.users.online
    render layout: false
  end

  def change_user_status
    @user = User.find(current_user.id)
    if @user
      if @user.available?
        @user.status = User::UNAVAILABLE
      else
        @user.status = User::AVAILABLE
      end
      @user.save!
      render layout: false
    else
      head :not_found
      render nothing: true
    end
  end
end