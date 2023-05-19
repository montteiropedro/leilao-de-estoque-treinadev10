class LotsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :is_admin?, only: [:new, :create, :approve, :close, :cancel, :add_product, :expired]
  
  def index
    load_index_lots
  end

  def favorite
    @favorite_lots = current_user.favorite_lots
  end

  def create_favorite
    @lot = Lot.find(params[:id])

    if current_user.favorite_lots << @lot
      redirect_to @lot, notice: 'Lote adicionado aos favoritos.'
    else
      redirect_to @lot, notice: 'Falha ao adicionar o lote aos favoritos.'
    end
  end

  def remove_favorite
    @lot = Lot.find(params[:id])

    if current_user.favorite_lots.destroy(@lot)
      redirect_to @lot, notice: 'Lote removido dos favoritos.'
    else
      redirect_to @lot, notice: 'Falha ao remover o lote dos favoritos.'
    end
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

  def search
    if params[:query].blank?
      load_index_lots
      return render template: 'lots/index'
    end

    @found_by_code = Lot.where('code LIKE ?', "%#{params[:query]}%")
    @found_by_product = Product.where('name LIKE ?', "%#{params[:query]}%").map(&:lot).compact

    @results = (@found_by_code + @found_by_product).uniq

    @approved_lots_in_progress = []
    @approved_lots_waiting_start = []
    @awaiting_approval_lots = [] if user_signed_in? && current_user.is_admin

    @results.each do |lot|
      if lot.approver.present?
        @approved_lots_in_progress << lot if (lot.start_date <= Date.today) && (lot.end_date >= Date.today)
        @approved_lots_waiting_start << lot if lot.start_date > Date.today
      else
        next unless user_signed_in? && current_user.is_admin

        @awaiting_approval_lots << lot if lot.end_date >= Date.today
      end
    end

    render template: 'lots/index'
  end

  private

  def lot_params
    non_monetary_params = params.require(:lot).permit(:code, :start_date, :end_date)
    monetary_params = {
      min_bid_in_centavos: reais_to_centavos(params[:lot][:min_bid_in_reais]),
      min_diff_between_bids_in_centavos: reais_to_centavos(params[:lot][:min_diff_between_bids_in_reais])
    }

    non_monetary_params.merge(monetary_params)
  end

  def load_index_lots
    @approved_lots_in_progress = Lot.where.not(approver: nil).and(Lot.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)).order(created_at: :desc)
    @approved_lots_waiting_start = Lot.where.not(approver: nil).and(Lot.where('start_date > ?', Date.today)).order(created_at: :desc)

    return unless user_signed_in? && current_user.is_admin

    @awaiting_approval_lots = Lot.where(approver: nil).and(Lot.where('end_date >= ?', Date.today)).order(created_at: :desc)
  end
end
