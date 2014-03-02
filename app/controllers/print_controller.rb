class PrintController < ApplicationController

  def index
    @queued = Person.joins(:church).
      order("churches.name", :name, :lastnames).where(print: true)
    @printed = Person.find(RegistroConfig::PRINT_AGENT.last_tags_printed)
  end

  def flush
    # TODO: fix notice based on force param
    flash[:notice] = "Impresión sometida de todos los carnets"
    
    RegistroConfig::PRINT_AGENT.flush(params[:force] || false)

    redirect_to :action => "index"
  end
end