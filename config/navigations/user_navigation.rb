# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|
    primary.dom_class = 'nav _left-menu js-left-menu'
    navigation.active_leaf_class = 'active'
    navigation.consider_item_names_as_safe = true

    primary.item :root, '', nil, class: 'brand_logo'

    
    #primary.item :contoller, 'Дашбоард', users_root_path

    primary.item :dashboard, 'Рабочий стол', dashboard_path,
                 icon: 'dashboard',
                 module: 'dashboard',
                 name: 'all',
                 notification_text: ''

    primary.item :dispatcher, 'Диспетчер', control_dashboard_path, notification_color: lambda { Control::Eve.instance.color_css }, if: proc { current_user.has_permission?(:access_dispatcher) }

    primary.item :units, 'Объекты', units_path,
                 icon: 'm-units',
                 module: 'units',
                 name: 'all',
                 notification_text: lambda { UnitBubble.count }

    primary.item :messages, 'Сообщения', '#',
                 icon: 'm-messages',
                 module: 'messages',
                 name: 'all',
                 notification_text: lambda { Im::Message.notifications_for(current_user).count },
                 if: proc { current_user.has_permission?(:read_broadcast_messages) } \
                do |second_level|

      second_level.item :broadcast, 'Циркуляр',
                        messages_broadcast_path,
                        module: 'messages',
                        name: 'broadcast',
                        if: proc { current_user.has_permission?(:read_broadcast_messages) }

      second_level.item :dialogues, 'Все диалоги', dialogues_path,
                        module: 'messages',
                        name: 'all',
                        if: proc { current_user.has_permission?(:read_organization_messages) }
      # second_level.item :all_income, 'Все входящие', '#', class: 'link-green', notification_text: lambda { '4' }
    end
  end
end
