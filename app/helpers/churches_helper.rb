module ChurchesHelper

  # Any church that has a pastor, assoc. pastor, delegate or board member present
  def attending_churches
    churches = (Person.where(attended: true, role: [0,1,3,4]).map do |p|
      if p.role == 4 and p.church
	    if p.church.position == 0
          p.church
	    else
	      nil
	    end
      else
        p.church
      end
    end).uniq
    (churches.reject {|c| c.nil? }).sort {|a,b| a.name <=> b.name }
  end

  def attending_churches_only
    churches = (Person.where(attended: true, role: [0,1,3]).map {|p| p.church }).uniq
    (churches.reject {|c| c.nil? || c.position == 0 }).sort {|a,b| a.name <=> b.name }
  end

  def attending_non_churches
    churches = (Person.where(attended: true, role: 4).map {|p| p.church }).uniq
    (churches.reject {|c| c.nil? || c.position != 0 }).sort {|a,b| a.name <=> b.name }
  end

  # Any church that has registered (pastor, assoc. pastor, delegate),
  # but none are present.
  def registered_churches_not_present
    churches = []
    Church.order(:name).all.each do |church|
      if church.people.size > 0
        people = church.people.select do |p|
          if [0,1,2,3].include?(p.role)
            true
	  elsif p.role == 4 and church.position == 0
	    true
          else
            false
	  end
        end

	if people.size > 0 and people.all? {|p| !p.attended }
          churches << church
        end
      end
    end
    churches
  end

  def towns
    [
      "Adjuntas",
      "Aguas Buenas",
      "Aibonito",
      "Arecibo",
      "Barranquitas",
      "Bayamón",
      "Caguas",
      "Canóvanas",
      "Carolina",
      "Cayey",
      "Cidra",
      "Coamo",
      "Corozal",
      "Dorado",
      "Fajardo",
      "Guánica",
      "Guayama",
      "Guayanilla",
      "Guaynabo",
      "Gurabo",
      "Humacao",
      "Islas Vírgenes",
      "Juncos",
      "Lares",
      "Las Piedras",
      "Loíza",
      "Luquillo",
      "Maunabo",
      "Mayagüez",
      "Morovis",
      "Naguabo",
      "Naranjito",
      "Orocovis",
      "Patillas",
      "Ponce",
      "Quebradillas",
      "Río Grande",
      "San Juan",
      "San Lorenzo",
      "Toa Baja",
      "Trujillo Alto",
      "Yabucoa",
      "Yauco"
    ]
  end
end
