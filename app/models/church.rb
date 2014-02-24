class Church < ActiveRecord::Base
    has_many :people
    has_many :checks
end
