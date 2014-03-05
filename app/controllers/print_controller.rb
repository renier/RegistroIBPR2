class PrintController < ApplicationController

  def index
    @queued = Person.joins(:church).
      order("churches.name", :name, :lastnames).where(printed: false)

    if defined?(RegistroConfig::PRINT_AGENT)
      @printed = Person.find(RegistroConfig::PRINT_AGENT.last_tags_printed)
    else
      @printed = []
    end
  end

  def flush
    if defined?(RegistroConfig::PRINT_AGENT)
      flash[:notice] = I18n.t("forceprintflash")
      RegistroConfig::PRINT_AGENT.flush(true)
    end

    redirect_to action: "index"
  end
end