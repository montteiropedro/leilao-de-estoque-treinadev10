class BatchesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :is_admin?, only: [:new, :create]
  
  def index
    @batches = Batch.order(id: :desc)
  end

  def show
    @batch = Batch.find(params[:id])
  end

  def new
    @batch = Batch.new
    @code_suggestion = Batch.generate_code_suggestion
  end

  def create
    @batch = Batch.new(batch_params)
    @batch.creator = current_user

    if @batch.save
      redirect_to @batch, notice: 'Lote cadastrado com sucesso.'
    else
      @code_suggestion = batch_params[:code]
      flash.now[:notice] = 'Falha ao cadastrar o lote.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def batch_params
    params.require(:batch).permit(:code, :start_date, :end_date, :minimum_bid, :minimum_difference_between_bids)
  end

  def is_admin?
    redirect_to root_path unless current_user.is_admin
  end
end
