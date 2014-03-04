class DashboardController < ApplicationController
  include ChurchesHelper

  def index
    @people = []
    I18n.t("rolemap.plural").each do |k, v|
      @people << { port: v, octetTotalCount: Person.where(attended: true, role: k).count }
    end

    present = attending_churches.size
    registered = reg_churches.size
    @churches = [
      { port: I18n.t("present"), octetTotalCount: present },
      { port: I18n.t("registered"), octetTotalCount: registered }
    ]
  end
end
