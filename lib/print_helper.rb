module PrintHelper
  def print(file)
    if OS.linux?
      require 'cups'
      Cups::PrintJob.new(file).print
    elsif OS.mac?
      `lpr #{file}`
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