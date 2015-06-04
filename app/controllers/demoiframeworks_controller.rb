class DemoiframeworksController < ApplicationController
  def index
  end

  def show
  	render @url
  end

  def iframe
  	@url = "http://www.tutorialspoint.com"
  end

end