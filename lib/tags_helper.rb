# TODO: Fill in {images_root}
require 'cgi'

module TagsHelper

  def es_upcase(str)
    str.strip.upcase.tr('áéíóúñ','ÁÉÍÓÚÑ')
  end

  def format_tag(raw_tag, person, browser=false)
    tag = raw_tag

    if person.role == "Visitante"
      tag = tag.sub(/\#\{role_bg_color\}/m, "\#fffed2")
    else
      tag = tag.sub(/\#\{role_bg_color\}/m, "\#ffffff")
    end

    if person.role == "Visitante"
      tag = tag.sub(/\#\{name\}/m, "")
      tag = tag.sub(/\#\{role\}/m, es_upcase("#{person.gender_salutation} #{person.name} #{person.lastnames}"))
      tag = tag.sub(/\#\{church_1\}/m, CGI.escapeHTML(person.description))
      tag = tag.sub(/\#\{church_2\}/m, "")
    elsif person.role == "Junta Directiva"
      tag = tag.sub(/\#\{name\}/m, es_upcase("#{person.gender_salutation} #{person.name} #{person.lastnames}"))
      tag = tag.sub(/\#\{role\}/m, person.role)
      tag = tag.sub(/\#\{church_1\}/m, CGI.escapeHTML(person.description))
      tag = tag.sub(/\#\{church_2\}/m, "")
    else
      tag = tag.sub(/\#\{name\}/m, es_upcase("#{person.gender_salutation} #{person.name} #{person.lastnames}"))
      tag = tag.sub(/\#\{role\}/m, person.gender_role)
      if person.church
        long_name = "#{person.church.number_to_word} #{person.church.prefix} #{person.church.name}".strip
        if long_name.length > 42
          tag = tag.sub(/\#\{church_1\}/m, "#{person.church.number_to_word} #{person.church.prefix}".strip)
          tag = tag.sub(/\#\{church_2\}/m, person.church.name)
        else
          tag = tag.sub(/\#\{church_1\}/m, long_name)
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