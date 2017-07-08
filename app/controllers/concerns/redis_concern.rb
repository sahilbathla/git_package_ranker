module RedisConcern

  def self.client
	@client ||= Redis.new
  end

  def self.set (key, value)
  	client.set(key, value)
  end

  def self.get(key)
  	client.get(key)
  end
end