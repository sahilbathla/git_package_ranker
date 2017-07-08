class PackagesController < ApplicationController
  def index
  	@top_packages = Package.all.order('score desc').limit(10)
  end
end
