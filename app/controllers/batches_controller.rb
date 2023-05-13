class BatchesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :approve, :close, :cancel, :add_product, :expired, :won, ]
  before_action :is_admin?, only: [:new, :create, :approve, :close, :cancel, :add_product, :expired, ]
  
  def index
    @approved_batches_in_progress = Batch.where.not(approver: nil).and(Batch.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)).order(created_at: :desc)
    @approved_batches_waiting_start = Batch.where.not(approver: nil).and(Batch.where('start_date > ?', Date.today)).order(created_at: :desc)

    return unless user_signed_in? && current_user.is_admin

    @awaiting_approval_batches = Batch.where(approver: nil).and(Batch.where('end_date >= ?', Date.today)).order(created_at: :desc)
  end

  def expired
    @expired_batches = Batch.where('end_date < ?', Date.today).and(Batch.where(buyer: nil)).order(created_at: :desc)
    @closed_expired_batches = Batch.where('end_date < ?', Date.today).and(Batch.where.not(buyer: nil)).order(created_at: :desc)
  end
  
  def won
    return redirect_to root_path if current_user.is_admin

    @won_batches = current_user.won_batches
  end

  def show
    @batch = Batch.find(params[:id])

    return redirect_to root_path if @batch.approver.blank? && !user_signed_in?
    return redirect_to root_path if @batch.approver.blank? && (user_signed_in? && !current_user.is_admin)

    if @batch.approver.present? && (@batch.in_progress? || @batch.expired?)
      @bids = @batch.bids.order(value_in_centavos: :desc)
    end

    return unless user_signed_in? && current_user.is_admin
    
    if @batch.approver.blank? && !@batch.expired?
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
    @batch.approver = current_user

    redirect_to @batch, notice: 'Lote aprovado com sucesso.' if @batch.save(validate: false)
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

  def cancel
    @batch = Batch.find(params[:id])

    redirect_to expired_batches_path, notice: 'Lote cancelado com sucesso.' if @batch.destroy
  end

  def close
    @batch = Batch.find(params[:id])
    @winning_bid = @batch.bids.order(value_in_centavos: :desc).first
    @batch.buyer = @winning_bid.user

    redirect_to expired_batches_path, notice: 'Lote encerrado com sucesso.' if @batch.save(validate: false)
  end

  private

  def batch_params
    params.require(:batch).permit(:code, :start_date, :end_date, :min_bid_in_centavos, :min_diff_between_bids_in_centavos)
  end
end
