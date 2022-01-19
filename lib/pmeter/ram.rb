require_relative 'platform'

module PMeter
	RAM = Struct.new *%i[
		reclaimable
		available
		relative
		buffer
		cached
		shared
		total
		free
		used
	] do
		RAM_HASH_REGEXP = /(#{
			%w[
				MemFree MemTotal Buffers Shmem
				Cached MemAvailable KReclaimable
			].join '|'
		}):\s+(\d+).*/
		
		case RUBY_PLATFORM
		when GNU_LINUX, ANDROID
			def update!
				hash = (
					(
						File.read '/proc/meminfo'
					).scan RAM_HASH_REGEXP
				).to_h
				
				self.reclaimable = hash ['KReclaimable'].to_i
				self.available   = hash ['MemAvailable'].to_i
				self.cached      = hash ['Cached'].to_i
				self.shared      = hash ['Shmem'].to_i
				self.buffer      = hash ['Buffer'].to_i
				self.total       = hash ['MemTotal'].to_i
				self.free        = hash ['MemFree'].to_i
				
				self.used = self.total -
					self.free -
					self.buffer -
					self.cached -
					self.reclaimable
				
				self.cached += self.free +
					self.reclaimable -
					self.available
				
				self.relative = self.used.fdiv self.total
			end
		end
	end.new
end
