module GitConcern
  extend ActiveSupport::Concern

  def client
	  @client ||= Octokit::Client.new(:login => Rails.application.secrets.user_name, :password => Rails.application.secrets.password)
  end

  def search_repo(query)
  	res = client.search_repositories query, { :page => 1, :per_page => 25 }
  	if res.total_count > 0
  		return res
  	else
  		return { :err => 'No results found' }
  	end
  end

  def get_contents(repo_id, file_name)
    begin
      return client.contents(repo_id, :path => file_name).content
    rescue
      Rails.logger.error "Could not parse #{ file_name } in repository id #{ repo_id }"
      return false
    end
  end
end