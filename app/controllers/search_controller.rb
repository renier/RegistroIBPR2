class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    q = params[:q]
    terms = q.split(/ /)

    @peoples = []
    terms.each do |term|
      @peoples +=
        Person.basic_search({name: term, lastnames: term, description: term}, false) +
        Person.fuzzy_search({name: term, lastnames: term, description: term}, false)
    end

    @peoples.uniq!

    @churches = []
    terms.each do |term|
      @churches +=
        Church.basic_search({name: term, nickname: term, town: term}, false) +
        Church.fuzzy_search({name: term, nickname: term, town: term}, false)
    end

    @churches.uniq!

    if @peoples.size == 1 && @churches.size == 0
      redirect_to person_path(@peoples[0])
    elsif @churches.size == 1 && @peoples.size == 0
      redirect_to church_path(@churches[0])
    end
  end
end
