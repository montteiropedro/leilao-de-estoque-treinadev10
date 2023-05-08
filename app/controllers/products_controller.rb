class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :link_batch]
  before_action :is_admin?, only: [:new, :create, :link_batch]

  def index
    @products = Product.order(created_at: :desc)
  end

  def show
    @product = Product.find(params[:id])
    @batches = Batch.order(created_at: :desc)
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

  def link_batch
    return unless params[:batch_id]

    @product = Product.find(params[:id])
    @batch = Batch.find(params[:batch_id])

    if @product.update!(batch: @batch)
      redirect_to @product, notice: 'Lote vinculado com sucesso.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def unlink_batch
    @product = Product.find(params[:id])

    if @product.update!(batch: nil)
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
