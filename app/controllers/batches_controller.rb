class BatchesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :approve, :add_product]
  before_action :is_admin?, only: [:new, :create, :approve, :add_product]
  
  def index
    @approved_batches = Batch.where.not(approver: nil).order(created_at: :desc)

    if user_signed_in? && current_user.is_admin
      @awaiting_approval_batches = Batch.where(approver: nil).order(created_at: :desc)
    end
  end

  def show
    @batch = Batch.find(params[:id])

    if @batch.approver.blank?
      return redirect_to root_path unless user_signed_in? && current_user.is_admin

      @products = Product.where(batch: nil).order(:name)
    end
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

  def approve
    @batch = Batch.find(params[:id])

    redirect_to @batch, notice: 'Lote aprovado com sucesso.' if @batch.update!(approver: current_user)
  end

  def add_product
    return unless params[:product_id]

    @batch = Batch.find(params[:id])
    @product = Product.find(params[:product_id])

    if @product.update(batch: @batch)
      redirect_to @batch, notice: 'Produto vinculado com sucesso.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def batch_params
    params.require(:batch).permit(:code, :start_date, :end_date, :min_bid_in_centavos, :min_diff_between_bids_in_centavos)
  end
end
