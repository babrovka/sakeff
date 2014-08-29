# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|
    primary.dom_class = 'nav _left-menu js-left-menu'
    navigation.active_leaf_class = 'active'
    # navigation.name_generator = Proc.new { |name, item|
    #   "<span class='fa'></span>
    #    <span class='menu-text'>#{name}</span>
    #    <span class='badge'></span>
    #    <span class='triangle'></span>"
    # }
    navigation.consider_item_names_as_safe = true

    primary.item :contoller, 'БАЛАЛЛА', '#' do |second_level|
      second_level.item :first, 'Ссылка на Дашбоард', '#'
    end

    primary.item :dispatcher, 'Дашбоард', users_root_path

    primary.item :dispatcher, 'Диспетчер', control_dashboard_path, notification_color: lambda { 'badge-green' }

    primary.item :units, 'Объекты', '#', icon: 'fa-building' do |second_level|
      second_level.item :first, 'Первая ссылка', '#'
      second_level.item :second, 'Вторая ссылка', '#', class: 'link-green', notification_text: lambda { '4' }
      second_level.item :third, 'Третья ссылка', '#'
      second_level.item :forth, 'Ссылка на объекты', units_path
      second_level.item :fifth, 'Ссылка с подчерк.', '#', class: 'link'
    end

    primary.item :messages, 'Сообщения', '#', icon: 'fa-comments', notification_text: lambda { Im::Message.count } do |second_level|
      second_level.item :first, 'Ссылка на сообщения', dialogues_path
    end

  end
end
