module PeopleHelper

  module Roles
    PASTOR           = 0
    ASSOCIATE_PASTOR = 1
    RETIRED_PASTOR   = 2
    DELEGATE         = 3
    BOARD_MEMBER     = 4
    VISITOR          = 5
  end

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
