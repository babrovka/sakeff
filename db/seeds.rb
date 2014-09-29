def process_hash model_hash
  hash_name = model_hash.keys[0].to_s
  class_name = eval hash_name.camelize.singularize
  seed_records = model_hash.values.flatten

  if class_name.count < seed_records.size
    seed_records.each do |record|
      begin
        class_name.create!(record)
      rescue ActiveRecord::RecordNotUnique
        next
      end
    end
  end
end

process_hash({super_users: [{email: 'admin@example.com', password: 'password', password_confirmation: 'password', label: 'admin'}]})
process_hash({organizations: [{inn: "2212321223", short_title: "Org", full_title: "Organization title", legal_status: 1}]})
process_hash({users: [
      {first_name: "Vasia", last_name: "Ivanov", middle_name: "TestTest", username: "admin", password: "password", password_confirmation: 'password', title: "not so admin", organization: Organization.first},
      {first_name: "Ulia", last_name: "Pupkina", middle_name: "MegaPuker", username: "loller", password: "qwertyuiop", password_confirmation: 'qwertyuiop', title: "lolguy", organization: Organization.first}
]})

# Rake::Task['dev:org_and_user'].invoke
Rake::Task['excel:permissions'].invoke
Rake::Task['excel:units'].invoke
Rake::Task['templates:states'].invoke

user = User.where(username: "admin").first
user.permissions << Permission.all
user.user_permissions.each do |user_permission|
  user_permission.update(result: "granted")
end