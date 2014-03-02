require 'tmpdir'

class Printer
  include TagsHelper
  include PrintHelper
  include Celluloid

  PRINT_INTERVAL = 600 # 10 minutes
  DBCHECK_INTERVAL = 180 # 3 minutes
  TAGS_PER_PAGE = 6
  TAGS_BASENAME = Dir.tmpdir + "registroibpr_tag_page"
  TAGS_PAGE = File.open("#{RAILS_ROOT}/app/assets/images/tags.svg", 'r').read
  TAG = File.open("#{RAILS_ROOT}/app/assets/images/tag.svg", 'r').read
  ZZZ = 5

  def initialize()
    @last_print = Time.now
    @last_dbcheck = Time.now - DBCHECK_INTERVAL
    @last_tags_printed = []

    async.run
  end

  def flush(force=false)
    @flush = { force: force }
  end

  def last_tags_printed
    @last_tags_printed.dup
  end

  private

  def run
    loop do
      if Time.now >= (@last_print + PRINT_INTERVAL)
        flush(true)  # too much time has passed sice last print. force a print.
      elsif Time.now >= (@last_dbcheck + DBCHECK_INTERVAL)
        flush()  # if we have any complete pages needing printing, print them.
      end

      if @flush
        if @flush[:force] # Got message to force a print of anything in queue
          people = Person.find_by(print: true)
          @last_dbcheck = Time.now
          if people.size > 0
            logger.info "Forced to print anything in queue due to command or timeout."
            print_tags(people, true)
            tags_last_seen += people.collect {|p| p.id }
            @last_print = Time.now
          end
        else  # Let's print if we have complete pages in queue.
        end
        @flush = nil
      end
      sleep ZZZ
    end
  end
end