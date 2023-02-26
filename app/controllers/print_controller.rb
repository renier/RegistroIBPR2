class PrintController < ApplicationController
  include TagsHelper

  def index
    @queued = PeopleHelper.queued
    @printed = []

    return unless defined?(RegistroConfig::PRINT_AGENT)

    last_printed_ids = RegistroConfig::PRINT_AGENT.last_tags_printed

    return if last_printed_ids.empty?

    flash[:notice] = I18n.t('forceprintflash') if params[:flash]

    @printed = Person.where((['id = ?'] * last_printed_ids.size).join(' or '), *last_printed_ids).to_a
  end

  def flush
    RegistroConfig::PRINT_AGENT.flush(true) if defined?(RegistroConfig::PRINT_AGENT)

    redirect_to action: 'index'
  end

  def page
    people = PeopleHelper.queued
    if people_ids.empty? || (people.size < TAGS_PER_PAGE && (!params.key? :force))
      people_ids = people.collect(&:id).join(',')
      head :no_content, 'App-People-Ids'.to_sym => people_ids
      return
    end

    people = people.slice(0, TAGS_PER_PAGE)
    people_ids = people.collect(&:id).join(',')

    doc = Prawn::Document.new
    doc.scale(0.82) # found by trial and error - unique to prawn-svg
    doc.svg tags_page_for(people, request.original_url), at: [-45, 945], enable_file_requests_with_root: '/'

    response.set_header 'App-People-Ids', people_ids
    send_data doc.render, disposition: 'inline', type: :pdf
  end

  def export
    render inline: %{<!DOCTYPE html><html>
        <body style="height: 100%; width: 100%, overflow: hidden, margin:0px">
          <embed src="/print/page?force=1" width="100%" height="100%" type="application/pdf"
            style="position: absolute; left: 0; top: 0;"/>
        </body>
      </html>
    }
  end
end
