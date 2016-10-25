class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = current_user.review
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)
    current_user.reviews << @review
    respond_to do |format|
      if @review.save
        format.json { render :show, status: :created, location: @review }
      else
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.json { render :show, status: :ok, location: @review }
      else
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = current_user.reviews.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:property_id, :body, :title, :property_rating, :created_at, :updated_at, :landlord_rating, :landlord_comments, :duration, :anonymous, :current_tenant)
    end
end
