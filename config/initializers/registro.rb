require 'printer'

module RegistroConfig
  DUE_PER_DELEGATE = 25
  COST_OF_MATERIALS_FOR_VISITOR = 20 # TODO: Is this needed?
  LIVE_DATE = Time.new(2014, 3, 6)
  INKSCAPE_PATH = "inkscape"
  if not defined?(Rails::Console)
    #PRINT_AGENT = Printer.new
  end
end

ActiveRecord::Base.logger = nil
