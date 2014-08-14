seed_models = [
  {super_users: [{email: 'admin@example.com', password: 'password', password_confirmation: 'password', label: 'admin'}]},
  {organizations: [{inn: "2212321223", short_title: "Org", full_title: "Organization title", legal_status: 1}]},
  {users: [
      {username: "admin", password: "password", password_confirmation: 'password', title: "not so admin", organization: Organization.first},
      {username: "loller", password: "qwertyuiop", password_confirmation: 'qwertyuiop', title: "lolguy", organization: Organization.first}
  ]}
]

seed_models.each do |model_hash|
  hash_name = model_hash.keys[0].to_s
  class_name = eval hash_name.camelize.singularize
  seed_records = model_hash.values.flatten

  if class_name.count < seed_records.size
    class_name.create(seed_records)
  end
end


# Rake::Task['dev:org_and_user'].invoke
Rake::Task['excel:permissions'].invoke
Rake::Task['excel:units'].invoke
Rake::Task['dev:import_states'].invoke

# Convert first user to diSPATCHARR
user = User.first
permission = Permission.where(title: "dispatcher")
user.permissions << permission
UserPermission.where(user: user, permission: permission).first.update(result: 1)
