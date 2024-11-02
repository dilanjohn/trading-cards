class CardsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.joins(:cards).distinct
    @cards = Card.all

    # Filter by user if selected
    if params[:user_id].present?
      @cards = @cards.where(user_id: params[:user_id])
    end

    # Search if query present
    if params[:search].present?
      @cards = @cards.where("title ILIKE ? OR description ILIKE ?", 
                           "%#{params[:search]}%", 
                           "%#{params[:search]}%")
    end

    @cards = @cards.order(created_at: :desc)
  end

  def show
    @card = Card.find(params[:id])
    @wanted = current_user&.wants&.exists?(card: @card)
  end

  def new
    @card = current_user.cards.build
  end

  def create
    @card = current_user.cards.build(card_params)
    
    if @card.save
      redirect_to cards_path, notice: 'Card successfully added to your collection!'
    else
      flash.now[:alert] = 'There was an error saving the card.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path, notice: 'Card was successfully deleted from your collection.'
  end

  def my_wants
    @wanted_cards = current_user.wanted_cards
  end

  def toggle_want
    @card = Card.find(params[:id])
    
    if current_user.wants.exists?(card: @card)
      current_user.wanted_cards.delete(@card)
      @wanted = false
    else
      current_user.wanted_cards << @card
      @wanted = true
    end

    respond_to do |format|
      format.html { redirect_to card_path(@card) }
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace("want-button-#{@card.id}", 
            partial: 'cards/want_button', 
            locals: { card: @card, wanted: @wanted }),
          turbo_stream.replace("want-text-#{@card.id}", 
            partial: 'cards/want_text', 
            locals: { card: @card })
        ]
      }
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:title, :description, :price, :status, :card_type, :image)
  end
end 