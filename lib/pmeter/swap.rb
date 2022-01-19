require_relative 'platform'

module PMeter
	SWAP = Struct.new :free, :total, :cached, :amount, :percent do
		SWAP_HASH_REGEXP = /(#{
			%w[SwapFree SwapTotal SwapCached].join '|'
		}):\s+(\d+).*/
		case RUBY_PLATFORM
		when GNU_LINUX, ANDROID
			def update!
				hash = (
					(
						File.read '/proc/meminfo'
					).scan SWAP_HASH_REGEXP
				).to_h
				
				self.cached  = hash ['SwapCached'].to_i
				self.free    = hash ['SwapFree'].to_i
				self.total   = hash ['SwapTotal'].to_i
				
				self.amount  = self.total - self.free - self.cached
				self.percent = self.amount.fdiv self.total
			end
		end
	end.new
end


















