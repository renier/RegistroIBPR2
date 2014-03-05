module PeopleHelper
  def affirmation(value)
    value ? "positive" : "negative"
  end

  def self.queued
    if Time.now >= RegistroConfig::LIVE_DATE
      people = Person.order(:updated_at).where(printed: false);
    else
      people = Person.joins(:church).
                order("churches.name", :name, :lastnames).
                where(printed: false) +
                Person.order(:updated_at).
                  where(printed: false, church_id: nil)
    end
  end
end
