class ChurchesController < ApplicationController
  def index
    sorts = [:name]
    sorts.unshift(params[:order]) if params[:order]
    @churches = Church.order(*sorts.uniq).page(params[:page] || 1)
  end

  def new
    @church = Church.new
  end

  def create
    @church = Church.new(check_params)
    if @church.save
      redirect_to @church,
        notice: I18n.t("flash.church.created",
          name: @church.short_name)
    else
      render 'new'
    end
  end

  def show
    @church = Church.find(params[:id])

    sorts = [:name]
    sorts.unshift(params[:order]) if params[:order]

    @people = @church.people.order(*sorts.uniq).page(params[:page] || 1)

    @payments = @church.total_payments
    @balance = @church.quota - @payments
  end

  def edit
    @church = Church.find(params[:id])
  end

  def update
    @church = Church.find(params[:id])
    if @church.update(check_params)
      redirect_to @church,
        notice: I18n.t("flash.church.updated",
          name: @church.short_name)
    else
      render 'edit'
    end
  end

  def destroy
    @church = Church.find(params[:id])
    @church.destroy

    flash[:notice] = I18n.t("flash.church.deleted",
      name: @church.short_name)
    respond_to do |format|
      format.html { redirect_to churches_path }
      format.json { head :ok, location: churches_path }
    end
  end

  private

  def check_params
    params.require(:church).permit(
      :nth, :position, :prefix, :name, :nickname, :town, :notes)
  end
end
