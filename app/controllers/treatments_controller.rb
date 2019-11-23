class TreatmentsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_treatment, only: [:show, :edit, :update, :destroy]
  authorize_resource
  include UserActivitiesHelper
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to user_holder_treatments_path(current_user.user_holder), notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  # GET /treatments
  # GET /treatments.json
  def index
    @treatments = @user_holder.treatments
  end

  # GET /treatments/1
  # GET /treatments/1.json
  def show
  end

  # GET /treatments/new
  def new
    @treatment = @user_holder.treatments.build
  end

  # GET /treatments/1/edit
  def edit
  end

  # POST /treatments
  # POST /treatments.json
  def create
    @treatment = @user_holder.treatments.build(treatment_params)

    respond_to do |format|
      if @treatment.save
        format.html { redirect_to user_holder_treatments_path(@user_holder), notice: 'Treatment was successfully created.' }
        format.json { render :show, status: :created, location: @treatment }
        log_create_delete_to_user_activities('treatment', 'create', current_user.user_holder, @user_holder)
      else
        format.html { render :new }
        format.json { render json: @treatment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /treatments/1
  # PATCH/PUT /treatments/1.json
  def update
    respond_to do |format|

      temp_treatment = @treatment.as_json
      if @treatment.update(treatment_params)
        format.html { redirect_to user_holder_treatments_path(@user_holder), notice: 'Treatment was successfully updated.' }
        format.json { render :show, status: :ok, location: @treatment }
        log_change_to_user_activities('treatment', 'edit', current_user.user_holder, @user_holder, temp_treatment, @treatment.as_json)
      else
        format.html { render :edit }
        format.json { render json: @treatment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /treatments/1
  # DELETE /treatments/1.json
  def destroy
    @treatment.destroy
    log_create_delete_to_user_activities('treatment', 'delete', current_user.user_holder, @user_holder)
    respond_to do |format|
      format.html { redirect_to user_holder_treatments_path(@user_holder), notice: 'Treatment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_treatment
      puts "TESTING TREATMENT"
      puts @user_holder.treatments.find(params[:id])
      @treatment = @user_holder.treatments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def treatment_params
      params.require(:treatment).permit(:provider, :name, :location, :status, :description, :user_holder_id)
    end
end