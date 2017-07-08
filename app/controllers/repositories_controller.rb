class RepositoriesController < ApplicationController
  include GitConcern
  include RedisConcern

  def index;end

  def search
    redis_response = RedisConcern.get(params[:q])
    if redis_response
      respond_to do | format |
        format.json { render :json => JSON.parse(redis_response) }
      end
    else
    	res = search_repo params[:q]
      result = Repository.filter_response(res)
      respond_to do | format |
        RedisConcern.set(params[:q], JSON.generate(result))
    		format.json { render :json => result }
    	end
    end
  end

  def import
  	repository = Repository.find_or_initialize_by(rid: params[:rid], name: params[:name])
  	package_content = get_contents(params[:rid].to_i, 'package.json')
    response = Package.import(package_content)
  	respond_to do | format |
  		if repository.save
  			format.json { render :json => { msg: response }, :status => 200 }
  		else
  			format.json { render :status => 400 }
  		end
  	end
  end
end
