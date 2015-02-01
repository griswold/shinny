class RinksController < ApplicationController
  def index
    @rinks = Rink.ordered
  end

  def show
    @rink = Rink.find(params[:id])
  end
end
