class Api::TextController < ApplicationController
  def string
  	id = params[:id].to_i
  	entry = Memory.read(:text).get_entry(id)
  	string = entry ? entry[:string] : nil

  	result = {}
  	result[:string] = string

  	render json: result
  end
end