class Repository < ActiveRecord::Base
	def self.filter_response(response)
		if (response.try(:items))
			items = response.items
			final_response = []
			items.each do | item |
				final_response.push({
					id: item.id,
					name: item.name,
					forks: item.forks,
					stars: item.stargazers_count
				})
			end
		else
			final_response = response
		end
		exclude_imported(final_response)
	end

	def self.exclude_imported(items)
		if items.kind_of?(Array)
			items.collect! { |item| ::OpenStruct.new(item) }
			response_ids = items.map(&:id)
			imported_ids = Repository.where(rid: response_ids).map(&:rid)
			items.collect! do | item |
				item.imported = imported_ids.include?(item.id)
				item.to_h
			end
		end
		return items
	end
end
