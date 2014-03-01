require 'csv'

csv = CSV.read("utils/churches.csv")
csv.shift

csv.each do |c|
  church = Church.new({ nth: c[1].to_i, prefix: c[2], name: c[3], nickname: c[4], town: c[5], size: c[8].to_i, position: c[10].to_i })
  church.id = c[0].to_i
  church.save
end

csv = CSV.read("utils/people.csv")
csv.shift

roles = ["Pastor(a)", "Pastor(a) Asociado(a)", "Pastor(a) Jubilado(a)", "Delegado(a)", "Junta Directiva", "Visitante"]
rolesmap = Hash[roles.map.with_index.to_a]
salutations = ["Pastor(a)", "Rvdo(a).", "Dr(a).", "Lcdo(a).", "Endosado(a)", "Capellán" ]
salutationsmap = Hash[salutations.map.with_index.to_a]
csv.each do |p|
  person = Person.new(salutation: salutationsmap[p[11]], name: p[1], lastnames: p[2], sex: p[3] == "M", role: rolesmap[p[4]], description: p[5], church_id: p[8].to_i)
  person.id = p[0].to_i
  person.save
end
