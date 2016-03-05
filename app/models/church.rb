class Church < ActiveRecord::Base
    has_many :people
    has_many :checks

    validates_presence_of :name

    has_paper_trail

    include ChurchesHelper

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

    def total_payments
      checks.sum(:amount)
    end

    def quota
      for_delegates = people.where(role: [0, 1, 3], attended: true).size *
                        RegistroConfig::DUE_PER_DELEGATE
      for_visitors = people.where(role: 5, attended: true, materials: true).size *
                        RegistroConfig::COST_OF_MATERIALS_FOR_VISITOR
      for_delegates + for_visitors
    end

    def balance
      quota - total_payments
    end

    def self.searchable_language
      'spanish'
    end
end
