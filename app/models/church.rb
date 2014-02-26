class Church < ActiveRecord::Base
    has_many :people
    has_many :checks

    validates_presence_of :name

    include ChurchesHelper
end
