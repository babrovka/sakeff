# coding: utf-8
module Documents
  module Tasks
    class ListShowDecorator < Documents::BaseDecorator
      decorates :task
      delegate_all

      # TODO-tagir: как мы говорили уже втроем. Декоратор — это рамка для каждого метода.
      # Взаимоотображение методов — это уже не декоратор, тут надо быть осторожным.
      # Используй для этого либо helper либо partial, который в нужной вьюхе будет цепляться.
      # Это касается всего кода, который ниже
      def task_body
        m=''
        if object.completed
          m ='m-task-completed'
        end
        h.content_tag(:div, class: '_task row content-container ' + m) do
          check + num + title_and_comment + date
        end
      end


      def task_body_completed(i)
        h.content_tag(:div, class: '_task row m-act content-container' ) do
          h.content_tag(:span,i.to_s.html_safe,class: 'col-sm-1  text-right') + title_and_comment + date
        end
      end



      def title_and_comment
        h.content_tag( :div,h.content_tag( :div,title, class: '_task-title ')+comment, class: 'col-sm-8')
      end

      def num
        h.content_tag( :div,object.id.to_s+'.', class: '_task-num col-sm-1')
      end

      def title
        # TODO-tagir: лучше заменить на запись типа
        #     object.title if object.title
        #
        if object.title
          object.title
        end
      end

      def date
        h.content_tag( :span, DateFormatter.new(object.created_at), class: 'span col-sm-2 _task-date text-left')
      end

      def comment
        if object.executor_comment
          h.content_tag( :span, object.executor_comment, class: '_task-comment')
        else
          ''
        end
      end

      def check
        if object.completed #col-sm-8

          h.content_tag( :div, ("<input type='checkbox'  checked='checked'>").html_safe, class: 'checkbox col-sm-1')
        else
          h.content_tag( :div, ("<input type='checkbox'>").html_safe, class: 'checkbox col-sm-1')
        end
      end
    end
  end
end