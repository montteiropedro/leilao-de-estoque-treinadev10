class BidsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    lot = Lot.find(params[:lot_id])
    current_user_bid = reais_to_centavos(params[:value_in_reais])
    bid = Bid.new(value_in_centavos: current_user_bid, user: current_user, lot: lot)

    if bid.save
      redirect_to lot, notice: 'Lance realizado com sucesso.'
    else
      if bid.errors[:value_in_centavos]
        flash[:notice] = bid.errors.full_messages.last
      else
        flash[:notice] = 'Falha ao realizar o lance.'
      end

      redirect_to lot
    end
  end
end
