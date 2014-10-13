module SimpleForm
  module Components
    module SelectsCheckbox

      def selects_checkbox
        @selects_checkbox ||= begin
          options[:selects_checkbox] if options[:selects_checkbox].present?
        end
      end

      def checkbox_text
        @checkbox_text ||= begin
          selects_checkbox[:text].to_s.html_safe if has_selects_checkbox?
        end
      end

      def checkbox_hint
        @checkbox_hint ||= begin
          selects_checkbox[:hint].to_s.html_safe if has_selects_checkbox?
        end
      end

      def has_selects_checkbox?
        selects_checkbox.present?
      end

      def has_checkbox_text?
        checkbox_text.present?
      end

      def has_checkbox_hint?
        checkbox_hint.present?
      end

    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::SelectsCheckbox)