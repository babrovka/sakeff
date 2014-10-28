module SimpleForm
  module Components
    module LabelHint
      extend SimpleForm::Components::Labels

      def label_hint
        @label_hint ||= begin
          options[:label_hint].to_s.html_safe if options[:label_hint].present?
        end

      end

      # expand label options by new hint options
      def label_html_options
        label_options = super
        if has_label_hint?
          label_options[:class].push('js-label-hint label-icon-hint')
          label_options[:title] = label_hint
        end
        label_options
      end




      protected

      def label_hint_options
        { title: label_hint }
      end

      def has_label_hint?
        label_hint.present?
      end

    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::LabelHint)