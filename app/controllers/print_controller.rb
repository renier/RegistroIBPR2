class PrintController < ApplicationController

  def index
    @queued = PeopleHelper.queued
    last_printed_ids = RegistroConfig::PRINT_AGENT.last_tags_printed

    if defined?(RegistroConfig::PRINT_AGENT) && last_printed_ids.size > 0
      if params[:flash]
        flash[:notice] = I18n.t("forceprintflash")
      end
      @printed = Person.where((["id = ?"] * last_printed_ids.size).join(" or "), *last_printed_ids).to_a
    else
      @printed = []
    end
  end

  def flush
    if defined?(RegistroConfig::PRINT_AGENT)
      RegistroConfig::PRINT_AGENT.flush(true)
    end

    redirect_to action: "index"
  end
end
