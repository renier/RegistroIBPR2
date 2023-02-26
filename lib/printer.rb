require 'tmpdir'
require 'tags_helper'
require 'print_helper'
require 'celluloid'
require 'logger'

Celluloid.boot

class Printer
  include TagsHelper
  include PrintHelper
  include Celluloid

  MAX_PRINT_INTERVAL = 1800 # 30 minutes
  DBCHECK_INTERVAL = 60 # 1 minute
  TAGS_PER_PAGE = 6
  PAGE_BASENAME = Dir.tmpdir + "/registroibpr_tag_page"
  TAGS_PAGE = File.open(
    Rails.root.join('app', 'assets', 'images', 'tags.svg').to_s, 'r').read
  ZZZ = 5

  def initialize()
    @last_print = Time.now
    @last_dbcheck = Time.now - DBCHECK_INTERVAL
    @last_tags_printed = []
    @flush = nil

    # Setup our own logger
    f = File.open(Rails.root.join('log', 'printing.log').to_s, File::CREAT | File::WRONLY | File::APPEND)
    f.sync = true
    @logger = ::Logger.new(f)
    @logger.level = ::Logger::DEBUG
  end

  def logger
    @logger
  end

  def flush(force=false)
    @flush = { force: force }
  end

  def last_tags_printed
    @last_tags_printed.dup
  end

  def run
    begin
      loop do
        if Time.now >= (@last_print + MAX_PRINT_INTERVAL)
          flush(true)  # too much time has passed sice last print. force a print.
        elsif Time.now >= (@last_dbcheck + DBCHECK_INTERVAL)
          flush()  # if we have any complete pages needing printing, print them.
        end

        if @flush
          logger.info "Checking queue to see if we have any tags waiting to be printed... "

          people = PeopleHelper.queued
          @last_dbcheck = Time.now
          @last_print = @last_dbcheck if people.size == 0

          logger.info "Found #{people.size} tags waiting to be printed."
          if people.size < TAGS_PER_PAGE and !@flush[:force]
            logger.info "No complete pages, yet. Leaving for later..."
          end
          go_ahead = false

          if @flush[:force] and people.size > 0
            remainder_page = people.size % TAGS_PER_PAGE > 0 ? 1 : 0
            logger.info "Printing all tags (#{(people.size / TAGS_PER_PAGE) + remainder_page} pages)..."
            go_ahead = true
          elsif !@flush[:force] and people.size >= TAGS_PER_PAGE
            logger.info "Printing #{people.size / TAGS_PER_PAGE} complete pages."
            logger.info "Leaving #{people.size % TAGS_PER_PAGE} tag(s) for later..."
            go_ahead = true
          end

          if go_ahead
            @last_tags_printed.clear
            @last_tags_printed += print_tags(people, @flush[:force])
            @last_print = Time.now
          end

          @flush = nil
        end
        sleep ZZZ
      end
    rescue ActiveRecord::StatementInvalid => error
      if "#{error}".include? "does not exist"
        puts "Migrations have not yet run. Ignoring error from print loop: #{error}"
      else
        raise error
      end
    end
  end

  def print_tags(people, force=false)
    printed_ids = []
    if (force and people.size < 1) or (!force and people.size < TAGS_PER_PAGE)
      return printed_ids
    end

    # Figure out how many svg pages we need
    total_pages = people.size / TAGS_PER_PAGE
    total_pages += 1 if force and people.size % TAGS_PER_PAGE > 0
    pages = Array.new(total_pages, TAGS_PAGE)

    pages.each do |page|
      batch = people.shift(TAGS_PER_PAGE)
      break if !force and batch.size < TAGS_PER_PAGE

      batch.each do |person|
        current_tag = tag_for(person)

        # Put tag in tags page
        page = page.sub(/<!-- TAG [0-5] -->/m, current_tag)

        printed_ids << person.id
      end

      print_page(page, batch)
    end

    printed_ids
  end

  def print_page(page, people)
    if File.exists? Rails.root.join('noprint').to_s
      sleep 1
      return
    end

    basename = "#{PAGE_BASENAME}.#{Time.now.to_f}"
    svg_file = "#{basename}.svg"
    pdf_file = "#{basename}.pdf"

    File.open(svg_file, 'w') {|f| f.write(page) }  # Save the SVG into a file.

    # Convert SVG to a PDF for printing.
    logger.debug `#{RegistroConfig::SVG2PDF_CMD % { input: svg_file, output: pdf_file }}`

    printit(pdf_file)
    logger.debug "Sent #{pdf_file} to printer. Updating print status in database."
    # update person records as not needing printing
    people.each do |person|
      person.send(:instance_variable_set, :@readonly, false)
      person.update(printed: true)
    end
    sleep 1 # breathe
  end
end
