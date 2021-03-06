class DistributionsController < ApplicationController
  before_action :set_distribution, only: [:show, :edit, :update, :destroy]
  before_action :check_for_key, only: [ :update, :destroy, :create ]

  def random
    @playtime_differential = params[:playtime_differential].to_i
    @distribution = Distribution.get_within_limits @playtime_differential
    @distribution_html = render_to_string :partial => "shared/distribution", :locals => { :distribution => @distribution, :playtime_differential => @playtime_differential }
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: { :playtime_differential => @playtime_differential, :distribution_html => @distribution_html } }
    end
  end

  # GET /distributions
  # GET /distributions.json
  def index
    @distributions = Distribution.all
  end

  # GET /distributions/1
  # GET /distributions/1.json
  def show
  end

  # GET /distributions/new
  def new
    @distribution = Distribution.new
  end

  # GET /distributions/1/edit
  def edit
  end

  # POST /distributions
  # POST /distributions.json
  def create
    @distribution = Distribution.new(distribution_params)

    respond_to do |format|
      if @distribution.save
        format.html { redirect_to @distribution, notice: 'Distribution was successfully created.' }
        format.json { render :show, status: :created, location: @distribution }
      else
        format.html { render :new }
        format.json { render json: @distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributions/1
  # PATCH/PUT /distributions/1.json
  def update
    respond_to do |format|
      if @distribution.update(distribution_params)
        format.html { redirect_to @distribution, notice: 'Distribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @distribution }
      else
        format.html { render :edit }
        format.json { render json: @distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributions/1
  # DELETE /distributions/1.json
  def destroy
    @distribution.destroy
    respond_to do |format|
      format.html { redirect_to distributions_url, notice: 'Distribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distribution
      @distribution = Distribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distribution_params
      params.require(:distribution).permit(:description, :minutes, :image, :remote_image_url)
    end

    def check_for_key
      unless params[:key] && params[:key] == SPECIAL_KEY
        redirect_to root_path, :alert => 'You are not allowed in there.'
        return
      end
    end
end
