require 'cgi'
require 'net/http'

module TagsHelper
  TAGS_PER_PAGE = 6
  TAG = File.open(Rails.root.join('app', 'assets', 'images', 'tag.svg').to_s, 'r').read.freeze
  TAGS_PAGE = File.open(
    Rails.root.join('app', 'assets', 'images', 'tags.svg').to_s, 'r'
  ).read.freeze

  def mb_upcase(str)
    # simple upcase is not effective on chars outside of ASCII.
    str.strip.mb_chars.upcase.to_s
  end

  def tag_for(person, browser=false, url=nil)
    # I18n.load_path = Dir[Rails.root.join('config', 'locales', '*.yml').to_s]
    # I18n.locale = 'es'
    # I18n.default_locale = 'es'
    logo_right_base = 'ibpr-logo-right-2022.png'
    logo_left_base = 'ibpr-logo-left-2023.png'
    tag = TAG
    if browser
      logo_right = view_context.image_path(logo_right_base)
      logo_left = view_context.image_path(logo_left_base)
      unless url.nil?
        uri = URI(url)
        logo_right = "#{uri.scheme}://#{uri.host}:#{uri.port}#{logo_right}"
        logo_left = "#{uri.scheme}://#{uri.host}:#{uri.port}#{logo_left}"
      end
    else
      tag = TAG.sub(/^.*<!-- START HERE -->(.*)<!-- END HERE -->.*$/m, '\1')
      logo_right = Rails.root.join('app', 'assets', 'images', logo_right_base).to_s
      logo_left = Rails.root.join('app', 'assets', 'images', logo_left_base).to_s
    end

    role_bg_color = '#ffffff'
    role_bg_color = '#fffed2' if person.role == 5 # Visitante
    name = role = church_1 = church_2 = ''

    if person.role == 5 # Visitante
      name = ''
      role = mb_upcase(person.greetname)
      church_1 = CGI.escapeHTML(person.description)
      church_2 = ''
    elsif person.role == 4 # Junta Directiva
      name = mb_upcase(person.greetname)
      role = person.display_role
      church_1 = person.church ? person.church.short_name : CGI.escapeHTML(person.description)
      church_2 = person.church ? CGI.escapeHTML(person.description) : ''
    else # Delegados
      name = mb_upcase(person.greetname)
      role = person.display_role
      if person.church
        full_church_name = person.church.display_name.strip
        if full_church_name.length > 42
          church_1 = "#{person.church.nth_to_word} #{person.church.prefix}".strip
          church_2 = person.church.name
        else
          # Fix weird problem with í
          church_1 = full_church_name.gsub(/\xc3\xad\xc2\xad/, "\xc3\xad")
          church_2 = ''
        end
      else
        church_1 = ''
        church_2 = ''
      end
    end

    format tag, logo_right:, logo_left:, role_bg_color:, name:, role:, church_1:, church_2:
  end

  def tags_page_for(people, url)
    tags = []
    people.each do |person|
      tags << tag_for(person, true, url)
    end

    if (TAGS_PER_PAGE - tags.size).positive?
      (TAGS_PER_PAGE - tags.size).times do
        tags << ''
      end
    end

    TAGS_PAGE % tags
  end
end
