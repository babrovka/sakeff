# Contains methods and scopes for uuid models
module Uuidable
  extend ActiveSupport::Concern

  included do
    # Original first and last sort by uuid kinda-string value
    scope :created_first, -> { order("created_at").first }
    scope :created_last, -> { order("created_at DESC").first }
  end
end