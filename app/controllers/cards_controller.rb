class CardsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @cards = @user.cards
    else
      @cards = Card.all
    end
  end

  def show
    @card = Card.find(params[:id])
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

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:title, :description, :price, :status, :card_type, :image)
  end
end 