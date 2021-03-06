class ChatController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:widget, :save_message, :send_mail]
  skip_filter :shopify_session, except: [:load_chat, :ping, :change_user_status, :join_chat, :leave_chat, :download]
  before_action :authenticate_user!, only: [:load_chat, :ping, :change_user_status, :join_chat, :leave_chat, :send_mail_transcript]

  # POST /chat/widget
  def widget
    @shop = Shop.find(params[:id])
    @conversation = @shop.conversations.open.find(params[:chat_id])
  rescue ActiveRecord::RecordNotFound
    # ignored
  ensure
    render layout: false
  end

  # POST /chat/request
  def request_chat
    @shop = Shop.find(params[:id])
    @conversation = @shop.conversations.create(name: params[:name], email: params[:email], user_name: params[:user_name],
                                               full_user_id: params[:full_user_id], user_access_token: params[:user_access_token],
                                               user_password: params[:user_password], location: params[:location], messages: [])
    render layout: false
  end

  # GET /chat/load
  def load_chat
    authorize! :chat, :all

    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    @users = @shop.users.all
    @conversations = @shop.conversations.open.where(deleted: false, archived: false)
    render layout: false
  end

  # POST /chat/save
  def save_message
    @conversation = Conversation.find(params[:id])
    @conversation.messages << params[:message]
    @conversation.save!
  rescue ActiveRecord::RecordNotFound
    head :not_found
  ensure
    render nothing: true
  end

  # POST /chat/join
  def join_chat
    authorize! :chat, :all

    @conversation = Conversation.find(params[:id])
    unless @conversation.first_operator_id
      # add first operator joined
      @conversation.first_operator_id = current_user.id
    end
    @conversation.users << current_user
    @conversation.save!
  rescue ActiveRecord::RecordNotFound
    head :not_found
    @status = false
  ensure
    @status = true
    render layout: false
  end

  # POST /chat/leave
  def leave_chat
    authorize! :chat, :all

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

  # POST /chat/close
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

  # POST /chat/rating
  def rating
    params[:rating] = 0 if params[:rating].blank? # reset rating to none
    @conversation = Conversation.find(params[:chat_id])
    @conversation.rating = params[:rating]
    @conversation.save!
  rescue ActiveRecord::RecordNotFound
    head :not_found
  ensure
    render nothing: true
  end

  # POST /chat/send-mail
  def send_mail
    @shop = Shop.find(params[:id])
    OperatorMailer.notify_no_operator_mail_request(shop: @shop, name: params[:name], email: params[:email], question: params[:question]).deliver_later
    @status = true
    render layout: false, action: :join_chat
  end

  # POST /chat/send-mail-transcript
  def send_mail_transcript
    authorize! :chat, :all

    @conversation = Conversation.find(params[:id])
    OperatorMailer.send_transcript(email: params[:email], transcript: @conversation).deliver_later
    render layout: false, json: {status: true}
  end

  # GET /chat/download
  def download
    authorize! :chat, :all

    @conversation = Conversation.find(params[:id])
    send_data @conversation.download, filename: "#{@conversation.title}-#{@conversation.created_at}.txt"
  end

  # DELETE /chat/ban
  def ban
    authorize! :chat, :all

    render layout: false, json: {status: true}
  end

  # POST /chat/online
  def ping
    authorize! :chat, :all

    render layout: false
  end

  # GET /chat/online
  def check
    @shop = Shop.find(params[:id])
    @users = @shop.users.online
    render layout: false
  end

  # POST /chat/change-user-status
  def change_user_status
    authorize! :chat, :all

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