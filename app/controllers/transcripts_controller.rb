class TranscriptsController < ApplicationController
  before_action :authenticate_user!
  before_action :shop

  def index
    @widget_config_json = @shop.widget.json_string.to_json
    @archived = !(params[:archived].blank? || params[:archived] == 'false')
    if params[:q].blank?
      if @archived
        @conversations = @shop.conversations.where(deleted: false).paginate(page: params[:page])
      else
        @conversations = @shop.conversations.where(deleted: false, archived: @archived).paginate(page: params[:page])
      end
    else
      q = params[:q]
      if @archived
        @conversations = @shop.conversations.where(deleted: false)
                             .joins(:users).where('conversations.name LIKE :q OR conversations.email LIKE :q OR users.email LIKE :q OR users.full_name LIKE :q', {q: "%#{q}%"})
                             .paginate(page: params[:page])
      else
        @conversations = @shop.conversations.where(deleted: false, archived: @archived)
                             .joins(:users).where('conversations.name LIKE :q OR conversations.email LIKE :q OR users.email LIKE :q OR users.full_name LIKE :q', {q: "%#{q}%"})
                             .paginate(page: params[:page])
      end
    end
  end

  def view
    @conversation = Conversation.find(params[:id])
    render layout: false
  end

  def archive
    @archived = @unarchived = 0
    unless params[:archived].blank?
      @conversations = @shop.conversations.where(deleted: false, archived: false).find(params[:archived])
      if @conversations.size > 0
        @conversations.each do |c|
          unless c.archived
            @archived += 1
            c.archived = true
            c.save
          end
        end
      end
    end
    unless params[:unarchived].blank?
      @conversations = @shop.conversations.where(deleted: false, archived: true).find(params[:archived])
      if @conversations.size > 0
        @conversations.each do |c|
          if c.archived
            @unarchived += 1
            c.archived = false
            c.save
          end
        end
      end
    end
    render layout: false, json: {archived: @archived, unarchived: @unarchived}
  end

  def destroy
    if params[:all].blank?
      @conversations = @shop.conversations.find(params[:ids])
    else
      if params[:all]
        @conversations = @shop.conversations.all
      end
    end
    @deleted = 0
    if @conversations.size > 0
      @conversations.each do |c|
        unless c.deleted
          @deleted += 1
          c.deleted = true
          c.save
        end
      end
    end
    render layout: false, json: {deleted: @deleted}
  end

  private

  def shop
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
  end
end