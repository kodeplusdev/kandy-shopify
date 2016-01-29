class TranscriptsController < ApplicationController
  before_action :authenticate_user!
  before_action :shop

  # GET /preferences/transcripts
  def index
    authorize! :read, :transcript

    @widget_config_json = @shop.widget.json_string.to_json
    @archived = !(params[:archived].blank? || params[:archived] == 'false')
    if params[:q] || params[:archived] || params[:page]
      params.delete :id # ensure transcript details dialog will be not shown again
    end
    if params[:q].blank?
      if @archived
        @conversations = @shop.conversations.where(deleted: false).order(created_at: :desc).paginate(page: params[:page])
      else
        @conversations = @shop.conversations.where(deleted: false, archived: @archived).order(created_at: :desc).paginate(page: params[:page])
      end
    else
      q = params[:q]
      if @archived
        @conversations = @shop.conversations.where(deleted: false)
                             .joins(:users).where('conversations.name LIKE :q OR conversations.email LIKE :q OR users.email LIKE :q OR users.first_name LIKE :q OR users.last_name LIKE :q', {q: "%#{q}%"})
                             .order(created_at: :desc)
                             .paginate(page: params[:page])
      else
        @conversations = @shop.conversations.where(deleted: false, archived: @archived)
                             .joins(:users).where('conversations.name LIKE :q OR conversations.email LIKE :q OR users.email LIKE :q OR users.first_name LIKE :q OR users.last_name LIKE :q', {q: "%#{q}%"})
                             .order(created_at: :desc)
                             .paginate(page: params[:page])
      end
    end
  end

  # GET /preferences/transcripts/:id
  def view
    authorize! :read, :transcript

    @conversation = Conversation.find(params[:id])
    render layout: false
  end

  # PUT /preferences/transcripts
  def archive
    authorize! :update, :transcript

    @archived = @unarchived = 0

    # archive transcripts
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

    # unarchive transcripts
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

  # DELETE /preferences/transcripts
  def destroy
    authorize! :destroy, :transcript

    if params[:all].blank?
      @conversations = @shop.conversations.find(params[:ids])
    else
      if params[:all]
        @conversations = @shop.conversations.where('status != ?', Conversation::OPEN).all
      end
    end

    @deleted = 0

    if @conversations.size > 0
      @conversations.each do |c|
        if !c.deleted && c.status != Conversation::OPEN
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