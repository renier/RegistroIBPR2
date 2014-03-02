require 'socket'
require 'rubygems'
require 'tmpdir'
require 'cups'

PRINT_HOST = 'localhost'
LAST_PRINT_TIMEOUT = 600 # 10 minutes
LAST_SQL_CHECK_TIMEOUT = 120 # 2 minutes
ZZZ = 5
TAG_SET_SIZE = 6
TAGS_BASENAME = Dir.tmpdir + "/registro_tag_page"
TAGS = File.open("#{RAILS_ROOT}/forms_logos/tags.svg", 'r').read
#TAGS = File.open("#{RAILS_ROOT}/forms_logos/tags_nolines.svg", 'r').read
TAG = File.open("#{RAILS_ROOT}/forms_logos/tag.svg", 'r').read

def print_tags_page(tags_page, people) # TODO: This could be threaded
  return if tags_page.nil?
  # write tags to new file
  basefilename = "#{TAGS_BASENAME}.#{Time.now.to_f}"
  tags_file = File.new("#{basefilename}.svg", 'w+')
  tags_file.write(tags_page)
  tags_file.close
  # Convert the file to PDF
  `inkscape -A #{basefilename}.pdf #{basefilename}.svg > /dev/null 2>&1`
  # Print the PDF file
  Cups::PrintJob.new("#{basefilename}.pdf").print
  print "Sent #{basefilename}.pdf to printer. Saving print status..."
  sleep 1 # breathe
  # Update person records as printed
  people.each do |person|
    person.print = false
    person.save
  end
  puts "Done"
end

def print_tags(people, remainder = false)
  tag_set_size = remainder ? TAG_SET_SIZE*1.0 : TAG_SET_SIZE
  puts "Printing #{people.length/tag_set_size} pages"

  pages = [TAGS]
  page_cursor = 0
  people_in_job = []
  # For each person
  (0...people.length).each do |i|
    person = people[i]
    # Read tag file
    tag_master = TAG
    tag = tag_master.sub(/^.*<!-- START HERE -->(.*)<!-- END HERE -->.*$/m,'\1')

    # Substitue values in
    tag = TagsHelper.format_tag(tag, person)

    # Substitue person tag in tags file
    page = pages[page_cursor] || TAGS
    pages[page_cursor] = page.sub(/<!-- TAG #{i%TAG_SET_SIZE+1} -->/m, tag)
    people_in_job.push(person)
    # If a set of 6 has finished
    if i%TAG_SET_SIZE == TAG_SET_SIZE-1
      print_tags_page(pages[page_cursor], people_in_job)
      # Setup next tags page
      page_cursor += 1
      people_in_job = []
    end
  end

  print_tags_page(pages[page_cursor], people_in_job) if remainder
end

def run_print_agent
  last_print = Time.now
  last_sql_check = Time.now - LAST_SQL_CHECK_TIMEOUT
  tags_last_seen = []
  # Init shared variable to hold message/cmd
  message = nil

  Thread.new do
    loop do
      # If we have a message to print now or too much time has passed,
      # then print everything.
      if message == RegistroConfig::MSG_PRINT_ALL or Time.now >= (last_print + LAST_PRINT_TIMEOUT)
        message = nil
        # find tags up for printing
        people = Person.find(:all, :conditions => "print = 1")
        last_sql_check = Time.now # update last_sql_check time
        if people.length > 0
          puts "Timed out waiting for a complete page. Printing remaining tags now"
          print_tags(people, true) # print including the last partial page
          # Collect tags last seen
          tags_last_seen = people.collect {|p| p.id }
          last_print = Time.now # update last_print time
        end
      # Else if enough time has passed, check for unprinted tags
      elsif message == RegistroConfig::MSG_PRINT_COMPLETE_PAGES or Time.now >= (last_sql_check + LAST_SQL_CHECK_TIMEOUT)
        message = nil
        puts "Checking tags queue"
        # find tags up for printing
        people = Person.find(:all, :conditions => "print = 1")
        last_sql_check = Time.now # update last_sql_check time
        if people.length >= TAG_SET_SIZE # If tags fill up a page at least
          puts "Found #{people.length} tags waiting in queue. printing only full pages"
          print_tags(people, false) # print excluding the last partial page
          tags_last_seen = []
          # Collect tags last seen
          upper_bound = TAG_SET_SIZE*(people.length/TAG_SET_SIZE)
          (0...upper_bound).each do |k|
            person = people[k]
            tags_last_seen.push(person.id)
          end
          last_print = Time.now # update last_print time
        end
      end
      sleep ZZZ
    end
  end

  # Start server accepting messages on a loop
  server = TCPServer.new(PRINT_HOST, RegistroConfig::PRINT_PORT)
  loop do
    # store received message in shared variable
    sock = server.accept
    input = sock.gets.chomp
    puts "Received message '#{input}'"
    if input == RegistroConfig::MSG_GET_LAST_SEEN
      sock.puts tags_last_seen.join(",")
    else
      message = input
    end
  end
end

run_print_agent