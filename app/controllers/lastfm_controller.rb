require "active_support/core_ext/hash/except"

class LastfmController < ApplicationController
  def get_request
    response = Lf.get_request(params.except("controller", "action"))
    render json: response
  end
end
