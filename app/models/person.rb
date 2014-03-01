class Person < ActiveRecord::Base
  belongs_to :church

  validates_presence_of :name
  validates_presence_of :lastnames
  validates_presence_of :name
  validates_presence_of :sex
  validates_inclusion_of :role, in: 0..5
  validates_presence_of :church_id, :if => "role != 2 and role != 4 and role != 5",
    :message => I18n.t("church_required")

  def fullname
    "#{name} #{lastnames}"
  end

  def salutation
    I18n.t("salutations.#{sexmf}")[read_attribute(:salutation)]
  end

  def greetname
    "#{salutation} #{fullname}"
  end

  def display_role
    I18n.t("rolemap.#{sexmf}")[role]
  end

  def sexmf
    sex ? "m" : "f"
  end
end
