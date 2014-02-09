class RinksController < ApplicationController
  def index
    @rinks = Rink.ordered
  end
end
