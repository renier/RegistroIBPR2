class Person < ActiveRecord::Base
  extend Textacular

  belongs_to :church

  validates_presence_of :name
  validates_presence_of :lastnames
  validates_inclusion_of :role, in: 0..5
  validates_presence_of :church_id, :if => "role != 2 and role != 4 and role != 5",
    :message => I18n.t("church_required")

  has_paper_trail

  def fullname
    "#{name.strip} #{lastnames.strip}"
  end

  def salutation
    value = read_attribute(:salutation)
    if value
      I18n.t("salutations.#{sexmf}")[value]
    else
      ""
    end
  end

  def greetname
    "#{salutation} #{fullname}".strip
  end

  def display_role
    I18n.t("rolemap.#{sexmf}")[role]
  end

  def sexmf
    sex ? "m" : "f"
  end

  def self.searchable_language
    'spanish'
  end
end
