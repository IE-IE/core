class Memory
	@memory = {}

	def self.read( name )
		@memory[name.to_sym]
	end

	def self.save( name, what )
		@memory[name.to_sym] = what
	end
end