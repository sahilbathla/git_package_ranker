class Repository < ActiveRecord::Base
	def self.filter_response(response)
		if (response.try(:items))
			items = response.items
			response_ids = items.map(&:id)
			imported_ids = Repository.where(rid: response_ids).map(&:rid)
			final_response = []
			items.each do | item |
				final_response.push({
					id: item.id,
					name: item.name,
					forks: item.forks,
					stars: item.stargazers_count,
					imported: imported_ids.include?(item.id)
				})
			end
			return final_response
		else
			return response
		end
	end
end
