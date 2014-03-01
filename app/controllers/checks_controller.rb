class ChecksController < ApplicationController
  def index
    @church = Church.find(params[:church_id])
    @checks = @church.checks
  end

  def show
    @check = Check.find(params[:id])
  end

  def new
    @church = Church.find(params[:church_id])
    @check = Check.new
  end

  def create
    @church = Church.find(params[:church_id])
    @check = Check.new(check_params)
    if @check.save
      redirect_to church_path(@check.church)
    else
      render 'new'
    end
  end

  def edit
    @church = Church.find(params[:church_id])
    @check = Check.find(params[:id])
  end

  def update
    @church = Church.find(params[:church_id])
    @check = Check.find(params[:id])
    if @check.update(check_params)
      redirect_to church_path(@check.church)
    else
      render 'edit'
    end
  end

  def destroy
    @check = Check.find(params[:id])
    @check.destroy

    respond_to do |format|
      format.html { redirect_to church_path(@check.church) }
      format.json { head :ok, location: church_path(@check.church) }
    end
  end

  private

  def check_params
    params.require(:check).permit(:number, :amount, :description, :church_id)
  end
end
