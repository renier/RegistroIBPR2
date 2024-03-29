require 'printer'

module RegistroConfig
  DUE_PER_DELEGATE = 25
  COST_OF_MATERIALS_FOR_VISITOR = 20 # TODO: Is this needed?
  LIVE_DATE = Time.new(2024, 3, 1)
  #SVG2PDF_CMD = "inkscape -A %{output} %{input}"
  SVG2PDF_CMD = "cairosvg %{input} -o %{output}"
  # Uncomment this when you want to print ids
  if not defined?(Rails::Console)
    PRINT_AGENT = Printer.new
    PRINT_AGENT.async.run
  end
end

ActiveRecord::Base.logger = nil
