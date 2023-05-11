class BidsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    batch = Batch.find(params[:batch_id])
    current_user_bid = params[:bid][:value_in_centavos]
    bid = Bid.new(value_in_centavos: current_user_bid, user: current_user, batch: batch)

    if bid.save
      redirect_to batch, notice: 'Lance realizado com sucesso.'
    else
      if bid.errors[:value_in_centavos]
        flash[:notice] = bid.errors.full_messages.last
      else
        flash[:notice] = 'Falha ao realizar o lance.'
      end

      redirect_to batch
    end
  end
end
