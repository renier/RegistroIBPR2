class PrintController < ApplicationController

  def index
    @queued = Person.joins(:church).
      order("churches.name", :name, :lastnames).where(print: true)
    @printed = Person.find(RegistroConfig::PRINT_AGENT.last_tags_printed)
  end

  def flush
    flash[:notice] = I18n.t("forceprintflash")
    
    RegistroConfig::PRINT_AGENT.flush(true)

    redirect_to action: "index"
  end
end