require 'cgi'

module TagsHelper
  TAG = File.open(Rails.root.join('app', 'assets', 'images', 'tag.svg').to_s, 'r').read

  def mb_upcase(str)  # simple upcase is not effective on chars outside of ASCII.
    str.strip.mb_chars.upcase.to_s
  end

  def tag_for(person, browser=false)
    I18n.load_path = Dir[Rails.root.join('config', 'locales', '*.yml').to_s]
    I18n.locale = 'es'
    I18n.default_locale = 'es'
    logo_right_base = 'ibpr-logo-right-2020.png'
    logo_left_base = 'ibpr-logo-left-2021.png'
    if browser
      tag = TAG.dup
      logo_right = view_context.image_path logo_right_base
      logo_left = view_context.image_path logo_left_base
    else
      tag = TAG.sub(/^.*<!-- START HERE -->(.*)<!-- END HERE -->.*$/m,'\1')
      logo_right = Rails.root.join('app', 'assets', 'images', logo_right_base).to_s
      logo_left = Rails.root.join('app', 'assets', 'images', logo_left_base).to_s
    end

    tag = tag.sub(/\#\{logo_right\}/m, logo_right)
    tag = tag.sub(/\#\{logo_left\}/m, logo_left)

    if person.role == 5 # Visitante
      tag = tag.sub(/\#\{role_bg_color\}/m, "\#fffed2")
    else
      tag = tag.sub(/\#\{role_bg_color\}/m, "\#ffffff")
    end

    if person.role == 5 # Visitante
      tag = tag.sub(/\#\{name\}/m, "")
      tag = tag.sub(/\#\{role\}/m, mb_upcase(person.greetname))
      tag = tag.sub(/\#\{church_1\}/m, CGI.escapeHTML(person.description))
      tag = tag.sub(/\#\{church_2\}/m, "")
    elsif person.role == 4 # Junta Directiva
      tag = tag.sub(/\#\{name\}/m, mb_upcase(person.greetname))
      tag = tag.sub(/\#\{role\}/m, person.display_role)
      tag = tag.sub(/\#\{church_1\}/m, person.church ? person.church.short_name : CGI.escapeHTML(person.description))
      tag = tag.sub(/\#\{church_2\}/m, person.church ? CGI.escapeHTML(person.description) : '')
    else # Delegados
      tag = tag.sub(/\#\{name\}/m, mb_upcase(person.greetname))
      tag = tag.sub(/\#\{role\}/m, person.display_role)
      if person.church
        full_church_name = person.church.display_name.strip
        if full_church_name.length > 42
          tag = tag.sub(/\#\{church_1\}/m, "#{person.church.nth_to_word} #{person.church.prefix}".strip)
          tag = tag.sub(/\#\{church_2\}/m, person.church.name)
        else
          tag = tag.sub(/\#\{church_1\}/m, full_church_name.gsub(/\xc3\xad\xc2\xad/,"\xc3\xad")) # Fix weird problem with í
          tag = tag.sub(/\#\{church_2\}/m, "")
        end
      else
          tag = tag.sub(/\#\{church_1\}/m, "")
          tag = tag.sub(/\#\{church_2\}/m, "")
      end
    end

    return tag
  end
end
