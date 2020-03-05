class ReportsController < ApplicationController
  include ChurchesHelper

  def index
  end

  def present_churches
    @present_churches = attending_churches
  end

  def arriving_churches
    @arriving_churches = registered_churches_not_present
  end

  def missing_churches
    @churches = Church.order(:name).all.select {|c| c.people.size == 0 or (c.position != 0 and c.people.all? {|p| p.role > 3 }) or (c.position == 0 and not c.people.any? {|p| p.role == 4  }) }
  end

  def full_roster
    if params[:all]
      @churches = Church.order(:name).all.reject {|c| c.people.size == 0 or (c.position != 0 and c.people.all? {|p| p.role > 3 }) or (c.position == 0 and not c.people.any? {|p| p.role == 4  }) }
      @all = true
    else
      @churches = attending_churches
    end
  end

  def churches_with_balance
    @churches = Church.order(:name).all.reject {|c| c.balance == 0 }
  end
end
