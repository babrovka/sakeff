# Contains common methods of all api controllers
class Api::BaseController < ApplicationController
  include CustomAuthentication

  before_action :authenticate_anybody!
end