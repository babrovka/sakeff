# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|
    primary.dom_class = 'nav _left-menu js-left-menu'
    navigation.active_leaf_class = 'active'
    navigation.consider_item_names_as_safe = true

    primary.item :root, '', nil, class: 'brand_logo'

    
    #primary.item :contoller, 'Дашбоард', users_root_path

    primary.item :dashboard, 'Рабочий стол', users_root_path,
                 icon: 'm-dashboard',
                 module: 'dashboard',
                 name: 'all',
                 notification_text: '',
                 if: proc { current_user.has_permission?(:view_desktop) }

    primary.item :dispatcher, 'Диспетчер', control_dashboard_path,
                 icon: 'm-dispatcher',
                 notification_color: lambda { Control::Eve.instance.color_css },
                 if: proc { current_user.has_permission?(:access_dispatcher) }

    primary.item :units, 'Объекты', units_path,
                 icon: 'm-units',
                 module: 'units',
                 name: 'all',
                 notification_text: lambda { UnitBubble.count },
                 if: proc { current_user.has_permission?(:view_units) }

    primary.item :messages, 'Сообщения', '#',
                 icon: 'm-messages',
                 module: 'messages',
                 name: 'all',
                 notification_text: lambda { Im::Message.notifications_for(current_user).count },
                 if: proc { current_user.has_permission?(:read_broadcast_messages) || current_user.has_permission?(:read_organization_messages)} \
                do |second_level|

      second_level.item :broadcast, 'Циркуляр',
                        messages_broadcast_path,
                        module: 'messages',
                        name: 'broadcast',
                        if: proc { current_user.has_permission?(:read_broadcast_messages) }

      second_level.item :dialogues, 'Журналы', dialogues_path,
                        module: 'messages',
                        name: 'all',
                        if: proc { current_user.has_permission?(:read_organization_messages) }
      # second_level.item :all_income, 'Все входящие', '#', class: 'link-green', notification_text: lambda { '4' }
    end

    primary.item :permits, 'Пропуска', '#',
                 icon: 'm-permits',
                 highlights_on: %r(/permits/),
                 if: proc { current_user.has_permission?(:view_permits) || current_user.has_permission?(:edit_permits)} \
                do |second_level|

      second_level.item :human, 'Физические лица', scope_permits_path(type: :human),
                        module: 'permits'

      second_level.item :car, 'Транспортные средства', scope_permits_path(type: :car),
                        module: 'permits'

      second_level.item :once, 'Разовые пропуска', scope_permits_path(type: :once),
                        module: 'permits'

    end
    
    
    primary.item :documents, 'Документы', documents_path,
                 icon: 'm-documents',
                 notification_text: proc { Documents::Document.notifications_for(current_user).count },
                 highlights_on: %r(/documents/),
                 if: proc { current_user.has_permission?(:view_documents) }


    primary.item :tasks, 'Задачи', tasks_module_path,
                 icon: 'm-tasks',
                 notification_text: proc { '-' },
                 if: proc { current_user.has_permission?(:view_tasks) }

  end
end
