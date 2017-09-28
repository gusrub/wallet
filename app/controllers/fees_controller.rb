class FeesController < ApplicationController
  before_action :set_fee, only: [:show, :update, :destroy]

  # GET /fees
  # GET /fees.json
  def index
    @fees = paginate(Fee.all)
  end

  # GET /fees/1
  # GET /fees/1.json
  def show
  end

  # POST /fees
  # POST /fees.json
  def create
    @fee = Fee.new(fee_params)

    if @fee.save
      render :show, status: :created, location: @fee
    else
      render json: @fee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fees/1
  # PATCH/PUT /fees/1.json
  def update
    if @fee.update(fee_params)
      render :show, status: :ok, location: @fee
    else
      render json: @fee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fees/1
  # DELETE /fees/1.json
  def destroy
    @fee.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fee
      @fee = Fee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fee_params
      params.require(:fee).permit(:description, :lower_range, :upper_range, :flat_fee, :variable_fee)
    end
end
