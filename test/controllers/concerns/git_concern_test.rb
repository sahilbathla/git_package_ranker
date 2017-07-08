require 'test_helper'

class GitConcernTest < Minitest::Test

  class Dummy
  	include GitConcern
  end

  class DummySearchRepositories
  	attr_accessor :total_count

  	def initialize(query)
  		if query == 'Hello World'
  			@total_count = 1
  		else
  			@total_count = 0
  		end
  	end
  end

  #Ideally we should stub data/methods but I am not doing it as it will give the correct results by making actuall call
  def test_get_contents
	fake_instance = Dummy.new
	#positive test case where repository has package.json in it
	assert fake_instance.get_contents(49970642, 'package.json') != false
	#negative test case where repository id does not have package.json in it
	assert fake_instance.get_contents(1,'package.json') == false
	#negative test case with stringified repository id
	assert fake_instance.get_contents('1','package.json') == false
	#negative test case  with repository id as nil
	assert fake_instance.get_contents(nil,'package.json') == false
  end


  #Stubbing search_repo function here to avoid actual call to github
  def test_search_repo
  	fake_instance = Dummy.new
  	#stubbing call to search_repositories

  	class << fake_instance.client
  		def search_repositories(query, params)
  			return DummySearchRepositories.new (query)
  		end
  	end

  	assert fake_instance.search_repo('Hello World') != { :err => 'No results found' }
  	assert fake_instance.search_repo('Anything Else') == { :err => 'No results found' }
  end
end
