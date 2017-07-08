class Package < ActiveRecord::Base
	def self.import (package_content)
		if (!package_content)
			return "Package file not found!!"
		else
			begin
				package_content = JSON.parse(Base64.decode64(package_content))
				begin
					#This can be optimized by separating inserts from updates and doing bulk operation or using upserts in DB like postgres
					package_content['dependencies'].each do | dependency, _version |
						p = Package.find_or_initialize_by(name: dependency.strip.downcase)
						p.score += 1
						p.save
					end
				rescue => e
					return "Packages not saved properly #{e.message}"
				end
			rescue
				return "Package.json parse error"
			end
		end
	end
end