require 'printer'

module RegistroConfig
  DUE_PER_DELEGATE = 25
  COST_OF_MATERIALS_FOR_VISITOR = 20 # TODO: Is this needed?
  LIVE_DATE = Time.new(2015, 3, 5)
  INKSCAPE_PATH = "inkscape"
  if not defined?(Rails::Console)
    PRINT_AGENT = Printer.new
    PRINT_AGENT.async.run
  end
end

ActiveRecord::Base.logger = nil
