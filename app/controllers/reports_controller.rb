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
    @churches = Church.order(:name).all.reject {|c| c.people.size > 0 }
  end

  def full_roster
    @churches = attending_churches
  end

  def churches_with_balance
    @churches = Church.order(:name).all.reject {|c| c.balance == 0 }
  end
end
