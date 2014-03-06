class SearchController < ApplicationController
  def index
    q = params[:q]
    terms = q.split(/ /)

    @peoples = []
    terms.each do |term|
      @peoples +=
        Person.fuzzy_search({name: term, lastnames: term, description: term}, false)
    end

    @peoples.uniq!

    @churches = []
    terms.each do |term|
      @churches +=
        Church.fuzzy_search({name: term, nickname: term, town: term}, false)
    end

    @churches.uniq!
  end
end