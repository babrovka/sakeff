# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|
    primary.dom_class = 'nav _left-menu js-left-menu'
    navigation.active_leaf_class = 'active'
    navigation.consider_item_names_as_safe = true

    primary.item :root, 'САКЭ КЗС', nil, class: 'brand_logo'

    
    #primary.item :contoller, 'Дашбоард', users_root_path

    primary.item :dispatcher, 'Диспетчер', control_dashboard_path, notification_color: lambda { 'badge-green' }, if: proc { current_user.has_permission?(:access_dispatcher) }

    primary.item :units, 'Объекты', units_path, icon: 'fa-building',
                 notification_text: lambda { UnitBubble.count }

    primary.item :messages, 'Сообщения', '#',
                 icon: 'fa-comments',
                 notification_text: lambda { Im::Message.count },
                 if: proc { current_user.has_permission?(:read_broadcast_messages) } \
                do |second_level|
      second_level.item :broadcast, 'Циркуляр',
                        messages_broadcast_path,
                        notification_text: lambda { Im::Message.count },
                        if: proc { current_user.has_permission?(:read_broadcast_messages) }
      # second_level.item :all_income, 'Все входящие', '#', class: 'link-green', notification_text: lambda { '4' }
    end
  end
end
