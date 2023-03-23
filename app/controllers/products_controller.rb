class ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :set_category, only: %i[ show new edit create destroy]
  before_action :set_product, only: %i[ show edit destroy ]

  def mark
    @product = Product.find(params[:id])
    current_user.products << @product
    head :ok
  end

  # GET /products or /products.json
  def index
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      @product = @category.products.includes(:category).paginate(page: params[:page], per_page: 10)
      @name = "#{@category.name} Posts"
    else
      @product = Product.includes(:category).paginate(page: params[:page], per_page: 10)
      @name = "All Posts"
    end
  end


  def profile
  end

  # GET /products/1 or /products/1.json
  def show
    @remark = @product.remarks.new
  end

  # GET /products/new
  def new
    @product = @category.products.new
    @rating = Rating.new
  end

  # GET /products/1/edit
  def edit
    @rating = Rating.new
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    if params[:product][:image].present?
      @product.image.attach(params[:product][:image])
    end
    respond_to do |format|
      if @product.save
        format.js { }
        format.html { redirect_to category_product_url(@category,@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }

      else
        format.js { }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }

      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
      if params[:product][:rating].present?
        @product = Product.find(params[:id])
        @rating = @product.ratings.new(params[:product][:rating][0])
        @rating.value = params[:product][:rating][:value].to_i
        if @rating.save
          redirect_to category_products_path(@product.category_id,@product)
        end

      else
        @category = Category.find(params[:category_id])
        @product = @category.products.find(params[:id])
        if params[:product][:image].present?
          @product.image.attach(params[:product][:image])
        end
        if @product.update(product_params)
          redirect_to category_product_url(@category,@product), notice: "Product was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to category_products_url(@category), notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_category
      @category = Category.find(params[:category_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = @category.products.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :category_id,:image, tags_attributes: [:name], tag_ids:[])
    end
end
