class Package < ActiveRecord::Base
	def self.insert_packages(package_contents)
		if package_contents
			#This can be optimized by separating inserts from updates and doing bulk operation or using upserts in DB like postgres
			package_contents.each do | dependency, _version |
				p = Package.find_or_initialize_by(name: dependency.strip.downcase)
				p.score += 1
				p.save
			end
		end
	end

	def self.import (package_content)
		res = {}
		if (!package_content)
			res[:err] = "Package file not found!!"
		else
			begin
				package_content = JSON.parse(Base64.decode64(package_content))
				begin
					insert_packages(package_content['dependencies'])
					insert_packages(package_content['devDependencies'])
				rescue => e
					res[:err] = "Packages not saved properly #{e.message}"
				end
			rescue
				res[:err] = "Package.json parse error"
			end
		end
		return res
	end
end