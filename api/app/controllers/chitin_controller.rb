class ChitinController < ApplicationController
  before_action :load

  def load
    @chitin = Chitin.new( @@chitin_location ) if @@chitin_location
  end

  def set
    @@chitin_location = params[:location]
  end

  def filetypes

  end

  def files

  end

  def full

  end
end
