require 'tags_helper'

class PeopleController < ApplicationController
  include TagsHelper

  def index
    sorts = [:name]
    sorts.unshift(params[:order]) if params[:order]

    if params[:church_id]
      church = Church.find(params[:church_id])
      @people = church.people
    elsif params[:order] == 'churches.name'
      @people = Person.joins(:church)
    else
      @people = Person
    end

    if params[:role] && !params[:role].empty?
      @people = @people.where(role: params[:role])
      @role = params[:role]
    end

    @people = @people.order(*sorts.uniq).page(params[:page] || 1)
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    attended = materials = false
    if Time.now >= RegistroConfig::LIVE_DATE
      attended = materials = true
    end

    @person = Person.new(attended: attended, materials: materials, sex: true)
  end

  def create
    @person = Person.new(check_params)
    if @person.save
      path = params[:church_id] ?
        church_person_path(@person.church, @person) :
        person_path(@person)

      if params[:continue]
        path = params[:church_id] ?
          new_church_person_path(@person.church) :
          new_person_path
      end

      redirect_to path,
        notice: I18n.t("flash.person.created",
          name: @person.fullname)
    else
      render 'new'
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update(check_params)
      path = params[:church_id] ?
        church_person_path(@person.church, @person) :
        person_path(@person)

      respond_to do |format|
        format.html {
          redirect_to path
        }
        format.json {
          render json: @person, location: path
        }
      end
    else
      render 'edit'
    end
  end

  def destroy
    @person = Person.find(params[:id])
    church = @person.church
    path = church ? church_path(church) : people_path
    @person.destroy

    flash[:notice] = I18n.t(
      "flash.person.deleted", name: @person.fullname)
    respond_to do |format|
      format.html { redirect_to path }
      format.json { head :ok, location: path }
    end
  end

  def tag
    person = Person.find(params[:id])
    tag = tag_for(person, true)

    render :text => tag, :content_type => 'image/svg+xml'
  end

  private

  def check_params
    params.require(:person).permit(
      :salutation, :name, :lastnames, :sex, :role, :description,
      :attended, :materials, :printed, :church_id, :email)
  end
end
