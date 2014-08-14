# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|
    primary.dom_class = 'nav _left-menu js-left-menu'
    navigation.active_leaf_class = 'active'
    navigation.name_generator = Proc.new { |name, item|
      "<span class='fa'></span>
       <span class='menu-text'>#{name}</span>
       <span class='badge'></span>
       <span class='triangle'></span>"
    }
    navigation.consider_item_names_as_safe = true

    primary.item :contoller, 'Дашбоард', users_root_path

    primary.item :units, 'Объекты', units_path, class: "js-dashboard-menu" do |second_level|
      second_level.item :first, 'Первая ссылка', '#'
      second_level.item :second, 'Вторая ссылка', '#'
      second_level.item :third, 'Третья ссылка', '#'
    end
    primary.item :contoller, 'Диспетчер', control_dashboard_path

    primary.item :unit1, 'Третий пункт', '#' do |second_level|
      second_level.item :first1, 'Первая ссылка', '#'
      second_level.item :second1, 'Вторая ссылка', '#'
      second_level.item :third1, 'Третья ссылка', '#'
      second_level.item :third1, 'Ссылка', '#'
      second_level.item :third1, 'Ссылка', '#'
      second_level.item :third1, 'Ссылка', '#'
      second_level.item :third1, 'Сылка', '#'
    end

    primary.item :unit2, 'Сообщения', messages_path

    primary.item :settings, 'Настройки', '#' do |second_level|
      second_level.item :first3, 'Первая ссылка', '#'
      second_level.item :second3, 'Вторая ссылка', '#'
      second_level.item :third3, 'Третья ссылка', '#'
      second_level.item :third3, 'Ссылка', '#'
      second_level.item :third3, 'Ссылка', '#'
    end
    primary.item :unit4, 'Объекты', '#'
  end
end
