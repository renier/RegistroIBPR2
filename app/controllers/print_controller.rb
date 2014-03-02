require 'socket'

class PrintController < ApplicationController

  def index
    @print_people = Person.order(:name, :lastnames).find_by(print: true)
    @printed_people = []

    begin
      t = TCPSocket.new(RegistroConfig::PRINT_HOST, RegistroConfig::PRINT_PORT)
      t.puts RegistroConfig::MSG_GET_LAST_SEEN
      @printed_people = Person.find(t.gets.chomp.split(/,/).collect {|x| x.to_i })
      t.close
    rescue
      flash[:notice] = nil
      flash[:error] = "El servicio de impresión no está corriendo!"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  def flush
    flash[:notice] = "Impresión sometida de todos los carnets"
    begin
      t = TCPSocket.new(RegistroConfig::PRINT_HOST, RegistroConfig::PRINT_PORT)
      t.puts RegistroConfig::MSG_PRINT_ALL
      t.close
    rescue
      flash[:notice] = nil
      flash[:error] = "El servicio de impresión no está corriendo!"
    end

    redirect_to :action => "index"
  end
end