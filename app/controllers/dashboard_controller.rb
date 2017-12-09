class DashboardController < ApplicationController
  include ChurchesHelper

  def index
    @people = []
    I18n.t("rolemap.plural").each do |k, v|
      @people << { port: v, octetTotalCount: Person.where(attended: true, role: k).count }
    end

    present_churches = attending_churches_only.size
    present_non_churches = attending_non_churches.size
    registered = registered_churches_not_present.size
    @churches = [
      { port: I18n.t("present_churches"), octetTotalCount: present_churches },
      { port: I18n.t("present_non_churches"), octetTotalCount: present_non_churches },
      { port: I18n.t("registered"), octetTotalCount: registered }
    ]
  end
end
