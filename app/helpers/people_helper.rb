module PeopleHelper
  def boolean?(value)
    [TrueClass, FalseClass].include? value.class
  end

  def affirmation(value)
    value ? "positive" : "negative"
  end
end
