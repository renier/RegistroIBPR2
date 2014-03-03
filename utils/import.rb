require 'csv'



csv = CSV.read("utils/checks.csv")
csv.shift

csv.each do |c|
  check = Check.new({number: c[1].to_i, amount: c[2].to_f, church_id: c[3].to_i, description: c[6]})
  check.id = c[0].to_i
  check.save
end
