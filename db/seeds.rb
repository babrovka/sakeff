# SuperUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', label: 'admin')
# Rake::Task['dev:org_and_user'].invoke
Rake::Task['excel:permissions'].invoke
Rake::Task['excel:units'].invoke

