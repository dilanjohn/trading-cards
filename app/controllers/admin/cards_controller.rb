class Admin::CardsController < Admin::AdminController
  def edit
    @card = Card.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Card not found"
    redirect_to admin_cards_path
  end

  def update
    @card = Card.find(params[:id])
    if @card.update(card_params)
      flash[:success] = "Card updated successfully"
      redirect_to admin_cards_path
    else
      render :edit
    end
  end

  private

  def card_params
    params.require(:card).permit(
      :title,
      :status,
      :card_type,
      :price,
      :image
    )
  end
end 