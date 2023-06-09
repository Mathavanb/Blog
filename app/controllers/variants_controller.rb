class VariantsController < ApplicationController
  load_and_authorize_resource
  before_action :set_product
  before_action :set_variant, only: %i[ show edit update destroy ]

  # GET /variants or /variants.json
  def index
    @variants = @product.variants.all
  end

  # GET /variants/1 or /variants/1.json
  def show
  end

  # GET /variants/new
  def new
    @variant = @product.variants.new
  end

  # GET /variants/1/edit
  def edit
  end

  # POST /variants or /variants.json
  def create
    @variant = @product.variants.new(variant_params)
    @variant.user_id = current_user.id
    respond_to do |format|
      if @variant.save
        format.html { redirect_to product_variant_url(@product,@variant), notice: "Variant was successfully created." }
        format.json { render :show, status: :created, location: @variant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variants/1 or /variants/1.json
  def update
    respond_to do |format|
      if @variant.update(variant_params)
        format.html { redirect_to product_variant_url(@product,@variant), notice: "Variant was successfully updated." }
        format.json { render :show, status: :ok, location: @variant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variants/1 or /variants/1.json
  def destroy
    @variant.destroy

    respond_to do |format|
      format.html { redirect_to product_variants_url, notice: "Variant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_variant
      @variant = @product.variants.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def variant_params
      params.require(:variant).permit(:colour, :price, :product_id)
    end
end
