require 'cgi'

module TagsHelper
  TAG = File.open(Rails.root.join('app', 'assets', 'images', 'tag.svg').to_s, 'r').read

  def mb_upcase(str)  # simple upcase is not effective on chars outside of ASCII.
    str.strip.mb_chars.upcase.to_s
  end

  def tag_for(person, browser=false)
    tag = TAG.sub(/^.*<!-- START HERE -->(.*)<!-- END HERE -->.*$/m,'\1')

    if browser
      images_root = "#{app.root_path}/assets"
    else
      images_root = Rails.root.join('app', 'assets', 'images').to_s
    end

    tag = tag.gsub(/\#\{images_root\}/m, images_root)

    if person.role == "Visitante"
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
      tag = tag.sub(/\#\{church_1\}/m, CGI.escapeHTML(person.description))
      tag = tag.sub(/\#\{church_2\}/m, "")
    else # Delegados
      tag = tag.sub(/\#\{name\}/m, mb_upcase(person.greetname))
      tag = tag.sub(/\#\{role\}/m, person.display_role)
      if person.church
        full_church_name = person.church.display_name.strip
        if full_church_name.length > 42
          tag = tag.sub(/\#\{church_1\}/m, "#{person.church.nth_to_word} #{person.church.prefix}".strip)
          tag = tag.sub(/\#\{church_2\}/m, person.church.name)
        else
          tag = tag.sub(/\#\{church_1\}/m, full_church_name)
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