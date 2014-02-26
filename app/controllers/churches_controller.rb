class ChurchesController < ApplicationController
  def index
    @churches = Church.page(params[:page] || 1)
  end

  def new
    @church = Church.new
  end

  def create
    @church = Church.new(post_params)
    if @church.save
      redirect_to @church
    else
      render 'new'
    end
  end

  def show
    @church = Church.find(params[:id])
  end

  private

  def post_params
    params.require(:church).permit(
      :nth, :prefix, :name, :nickname, :town, :notes)
  end
end
