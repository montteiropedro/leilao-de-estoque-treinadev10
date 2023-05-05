class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :is_admin?, only: [:new, :create]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
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

  private

  def product_params
    params.require(:product).permit(:name, :description, :weight, :width, :height, :depth, :category_id)
  end
end
