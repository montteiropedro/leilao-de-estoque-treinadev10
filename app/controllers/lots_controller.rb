class LotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :approve, :close, :cancel, :add_product, :expired, :won]
  before_action :is_admin?, only: [:new, :create, :approve, :close, :cancel, :add_product, :expired]
  
  def index
    @approved_lots_in_progress = Lot.where.not(approver: nil).and(Lot.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)).order(created_at: :desc)
    @approved_lots_waiting_start = Lot.where.not(approver: nil).and(Lot.where('start_date > ?', Date.today)).order(created_at: :desc)

    return unless user_signed_in? && current_user.is_admin

    @awaiting_approval_lots = Lot.where(approver: nil).and(Lot.where('end_date >= ?', Date.today)).order(created_at: :desc)
  end

  def expired
    @expired_lots = Lot.where('end_date < ?', Date.today).and(Lot.where(buyer: nil)).order(created_at: :desc)
    @closed_expired_lots = Lot.where('end_date < ?', Date.today).and(Lot.where.not(buyer: nil)).order(created_at: :desc)
  end
  
  def won
    return redirect_to root_path if current_user.is_admin

    @won_lots = current_user.won_lots
  end

  def show
    @lot = Lot.find(params[:id])

    return redirect_to root_path if @lot.approver.blank? && !user_signed_in?
    return redirect_to root_path if @lot.approver.blank? && (user_signed_in? && !current_user.is_admin)

    if @lot.approver.present? && (@lot.in_progress? || @lot.expired?)
      @bids = @lot.bids.order(value_in_centavos: :desc)
    end

    return unless user_signed_in? && current_user.is_admin
    
    if @lot.approver.blank? && !@lot.expired?
      @products = Product.where(lot: nil).order(:name)
    end
  end

  def new
    @lot = Lot.new
    @code_suggestion = Lot.generate_code_suggestion
  end

  def create
    @lot = Lot.new(lot_params)
    @lot.creator = current_user

    if @lot.save
      redirect_to @lot, notice: 'Lote cadastrado com sucesso.'
    else
      @code_suggestion = lot_params[:code]
      flash.now[:notice] = 'Falha ao cadastrar o lote.'
      render :new, status: :unprocessable_entity
    end
  end

  def approve
    @lot = Lot.find(params[:id])
    @lot.approver = current_user

    redirect_to @lot, notice: 'Lote aprovado com sucesso.' if @lot.save(validate: false)
  end

  def add_product
    return unless params[:product_id]

    @lot = Lot.find(params[:id])
    @product = Product.find(params[:product_id])

    if @product.update(lot: @lot)
      redirect_to @lot, notice: 'Produto vinculado com sucesso.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def cancel
    @lot = Lot.find(params[:id])
    @lot.products.each(&:available!)

    return unless @lot.destroy

    redirect_to expired_lots_path, notice: 'Lote cancelado com sucesso.'
  end

  def close
    @lot = Lot.find(params[:id])
    @winning_bid = @lot.bids.order(value_in_centavos: :desc).first
    @lot.buyer = @winning_bid.user
    @lot.products.each(&:sold!)

    return unless @lot.save(validate: false)

    redirect_to expired_lots_path, notice: 'Lote encerrado com sucesso.'
  end

  private

  def lot_params
    params.require(:lot).permit(:code, :start_date, :end_date, :min_bid_in_centavos, :min_diff_between_bids_in_centavos)
  end
end
