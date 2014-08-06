# SuperUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', label: 'admin')
# Rake::Task['dev:org_and_user'].invoke
Rake::Task['excel:permissions'].invoke
Rake::Task['excel:units'].invoke

Control::State.create(name: 'Пожар', system_name: 'fire')
Control::State.create(name: 'Потом', system_name: 'cataclysm')
Control::State.create(name: 'Ясно, можно не волновяться', system_name: 'so_good')