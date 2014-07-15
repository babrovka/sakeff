module Features
  module ChosenHelper
    CHOSEN_SLEEP = 0.1

    def select_from_chosen(label, position=0)
      field_id = find_field(label, visible: false)[:id]
      skip_welcome
      find("##{field_id}_chosen").click
      sleep CHOSEN_SLEEP
      within "##{field_id}_chosen" do
        all('.chosen-results li')[position.to_i].click
        sleep CHOSEN_SLEEP
        execute_script(%Q!$("##{field_id}").trigger('chosen:update')!)
      end
    end

    # def select_from_chosen_with_checkbox(label)
    #  field_id = find_field(label, visible: false)[:id]
    #  find("##{field_id}_chosen").click
    #  find("##{field_id}_chosen").click
    #  sleep 1
    #  within "##{field_id}_chosen" do
    #    find('.chosen-results li:first-child').click
    #    sleep 1
    #    execute_script(%Q!$("##{field_id}").trigger('chosen:update')!)
    #  end
    # end


    # удаляем несколько элементов из multi choosen
    # метод не определяет, можно ли в данном chosen убрать несколько элементов, все на откуп программисту
    # убирает count кол-во первых элементов в списке
    def remove_from_multiple_chosen(opts={}, count=2)
      chosen = find(chosen_name(opts))
      chosen_selected = chosen.find('.chosen-choices').all('li')
      puts "Will remove first #{count} in Multiple-chosen for '#{opts[:label]}'"

      within "#{chosen_name(opts)} .chosen-choices" do
        if chosen_selected.length >= count
          count.times.each do |pos|

            # наводим курсор на объект,
            # потому что кнопка удалить показывается только в этом случае
            chosen_selected[pos].hover
            all('.search-choice-close').first().click

            sleep CHOSEN_SLEEP
            # puts "removed #{pos} element from selected in multiple choosen"
          end
        end
        sleep CHOSEN_SLEEP
      end
      update_chosen_select(chosen_name(opts))
    end

    # выбираем несколько элементов в chosen
    # метод не определяет, можно ли в данном chosen выбрать несколько элементов, все на откуп программисту
    # выбирает count кол-во первых элементов в списке
    # метод не удаляет уже выбранные значения в списке
    def select_from_multiple_chosen(opts={})
      count = opts.delete(:count) || 2
      chosen = find(chosen_name(opts))

      chosen.click
      sleep CHOSEN_SLEEP

      within chosen_name(opts) do
        menu_items = all('.chosen-results li')
        puts "Multiple-chosen for '#{opts[:label]}' have #{menu_items.length} elements. Will select first #{count} of it."
        if menu_items.length >= count
          count.times.each do |pos|
            chosen.click
            sleep CHOSEN_SLEEP

            # choosen настроен так, что если элемент выбран, то он пропадает из общего списка результатов в выпадающем меню.do
            # поэтому клик производим каждый раз по первому элементу в ниспадающем меню
            find('.chosen-results li:first-child').click
            # puts "clicked on #{pos} element from multiple choosen"
          end
        end
        sleep CHOSEN_SLEEP
      end
      update_chosen_select(chosen_name(opts))
    end


    private

    def chosen_name(opts={})
      field_id = find_field(opts[:label].to_s, visible: false)[:id] if opts.has_key?(:label)
      field_id = opts[:id] if opts.has_key?(:id)
      "##{field_id}_chosen"
    end

    def update_chosen_select(name)
      execute_script(%Q!$("#{name.gsub('_chosen', '')}").trigger('chosen:update')!)
    end

  end
end
