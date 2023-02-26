class Check < ApplicationRecord
  belongs_to :church

  validates_presence_of :amount
  validates_presence_of :church_id

  validates_numericality_of :amount, :greater_than => 0

  include ActionView::Helpers::NumberHelper
  def display_amount
    number_to_currency(amount)
  end
end
