class Api::UnitBubblesController < Api::BaseController
  respond_to :json

  # @note is used in jstree
  def index
    @collection = UnitBubble.all

    # lol = [{unit_id: "long uuid", bubbles: [
    #         {type: "alarm", bubbles: [
    #             {text: "oh no"},
    #             {text: "terrorists"}
    #         ]},
    #         {type: "normal", bubbles: [
    #             {text: "all good"},
    #             {text: "normal"}
    #         ]},
    #     ]},
    #     {unit_id: "another long uuid", bubbles: [
    #         {type: "normal", bubbles: [
    #             {text: "all ok"},
    #             {text: "normal"}
    #         ]},
    #     ]}
    # ]
  end
  
  def grouped_bubbles_for_all_units
    render json: UnitBubble.grouped_bubbles_for_all_units
  end
end
