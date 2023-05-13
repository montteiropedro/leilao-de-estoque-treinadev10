class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :link_lot]
  before_action :is_admin?, only: [:new, :create, :link_lot]

  def index
    @products = Product.order(created_at: :desc)
  end

  def show
    @product = Product.find(params[:id])
    @lots = Lot.where(approver: nil).and(Lot.where('end_date >= ?', Date.today)).order(created_at: :desc)
  end

  def new
    @product = Product.new
    @categories = Category.order(:name)
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Produto cadastrado com sucesso.'
    else
      @categories = Category.order(:name)
      flash.now[:notice] = 'Falha ao cadastrar o produto.'
      render :new, status: :unprocessable_entity
    end
  end

  def link_lot
    return unless params[:lot_id]

    @product = Product.find(params[:id])
    @lot = Lot.find(params[:lot_id])

    if @product.update!(lot: @lot)
      redirect_to @product, notice: 'Lote vinculado com sucesso.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def unlink_lot
    @product = Product.find(params[:id])
    linked_lot = @product.lot

    if linked_lot.approver.blank? && @product.update!(lot: nil)
      redirect_to @product, notice: 'Lote desvinculado com sucesso.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :weight, :width, :height, :depth, :category_id, :image)
  end
end
