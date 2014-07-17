# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|
    primary.dom_class = 'nav nav-pills navbar-left'
    navigation.active_leaf_class = 'active'

    primary.item :main, 'Главная', super_user_root_path
    primary.item :users, 'Пользователи', super_user_users_path
    primary.item :organization, 'Организации', super_user_organizations_path
    primary.item :roles, 'Роли', super_user_roles_path
  end
end
