class PlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan, only: [:show, :update, :destroy]

  # GET /plans
  # GET /plans.json
  def index
    if params[:colortag].present? && Plan::COLOR_TAG.map{|k,v| v}.include?(params[:colortag].to_i)
      @plans = current_user.plans.with_color_tag(params[:colortag].to_i)
    else
      @plans = current_user.plans
      flash.now.notice = '不存在此分类' if params[:colortag].present? && !Plan::COLOR_TAG.map{|k,v| v}.include?(params[:colortag].to_i)
    end
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    # TODO sort task by status
    if params[:colortag].present? && Plan::COLOR_TAG.map{|k,v| v}.include?(params[:colortag].to_i)
      @lists = @plan.lists.with_color_tag(params[:colortag].to_i).includes(:tasks)
    else
      @lists = @plan.lists.includes(:tasks)
      flash.now.notice = '不存在此分类' if params[:colortag].present? && !Plan::COLOR_TAG.map{|k,v| v}.include?(params[:colortag].to_i)
    end
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # TODO catch uniqueness exception and redo
  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)
    @plan.add_ident
    @plan.user_id = current_user.id

    respond_to do |format|
      if @plan.save
        format.html { redirect_to root_url, notice: '计划项已经成功创建 !' }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to root_url, notice: '计划项已经更新 !' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: '计划项删除成功 !' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = current_user.plans.find_by_ident(params[:id])
      unless @plan
        respond_to do |format|
          format.html { redirect_to root_url, alert: '此计划不存在' }
          format.json { render json: {alert: '此计划不存在'} }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:title, :description, :color_tag)
    end
end
