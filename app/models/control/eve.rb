# «Мозг» диспетчерской - Ева. Знает все о текущем состоянии системы.
class Control::Eve
  include Singleton

  attr_reader :global_state
  
  def initialize
    reset
  end

  # Меняет глобальный статус на заданный
  # @param state [Control::State] глобальное состояние, которое нужно сделать активным
  # @see Control::State
  # @returns Control::State
  def change_global_state_to state
    @global_state = state
  end

  # Возвращает «суммированный» статус - вернет true, только если на всех объектах, включая «глобальный» - «нормальные» состояния.
  # @returns Boolean
  # @see Boolean
  def overall_state
    return @global_state.is_normal == true if @global_state
    return false
  end

  # Возвращает Еву в начальное состояние
  def reset
    @global_state = Control::State.where(is_normal: true).first || null_state
  end

  # Возвращает все возможные глобальные состояния
  # @returns Array of Control::State
  # @see Control::State
  def available_global_states
    Control::State.all
  end

  # Возвращает строку css-класса для статуса левого меню
  # @returns String of Control::State
  # @see Control::State
  def color_css
    overall_state ? 'badge-green m-important' : 'badge-red m-important'
  end

private

  def null_state
    Control::State.new(
      name: 'Неизвестный статус',
      status_name: :null_state,
      is_normal: false
    )
  end

end