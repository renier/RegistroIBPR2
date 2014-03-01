module ChurchesHelper
  def display_name
    "#{nth_to_word} #{prefix} #{name}".strip
  end

  def short_name
    roman = ["", "I", "II", "III", "IV", "V"][nth || 0]
    
    "#{name} #{roman}".strip
  end

  def nth_to_word
    if nth.nil? || nth == 0
      ""
    else
      I18n.t("nth")[nth]
    end
  end

  def amount_paid
    if new_record?
      0
    else
      Check.sum("amount", conditions: "church_id = #{id}")
    end
  end

  def balance_due
    if new_record?
      0
    else
      delegates = Person.count(conditions: "role = 'delegate' AND church_id = #{id}")
      (delegates * RegistroConfig::due_per_delegate) - amount_paid
    end
  end

  def towns
    [
      "Adjuntas",
      "Aguas Buenas",
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
      "Mayagüez",
      "Morovis",
      "Naguabo",
      "Naranjito",
      "Orocovis",
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
