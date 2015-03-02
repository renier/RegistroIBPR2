module PrintHelper
  def printit(file)
    if OS.linux?
      #require 'cups'
      #Cups::PrintJob.new(file).print
      `lpr -o scale=100 -o media=letter #{file}`
    elsif OS.mac?
      `lpr -o scale=100 -o media=letter #{file}`
    else # assume Windows
      # TODO
    end
  end
end

module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG["arch"]) != nil
  end

  def OS.mac?
   (/darwin/ =~ RbConfig::CONFIG["arch"]) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end
