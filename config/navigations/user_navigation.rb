# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|
    primary.dom_class = 'nav nav-pills navbar-left'
    navigation.active_leaf_class = 'active'

    primary.item :main, 'Главная', users_root_path
    primary.item :units, 'Объекты', units_path
  end
end
