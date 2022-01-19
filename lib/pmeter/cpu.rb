require_relative 'platform'

module PMeter
	Processes = Struct.new :user, :nice, :system, :idle, :iowait
	Core = Struct.new :previous, :current do
		def total
			current.sum - previous.sum
		end
		def get proccess
			current[proccess] - previous[proccess]
		end
		def user
			get :user
		end
		def nice
			get :nice
		end
		def system
			get :system
		end
		def idle
			get :idle
		end
		def time_doing_things
			user + nice + system
		end
		def time_doing_nothing
			idle + iowait
		end
	end
	
	case RUBY_PLATFORM
	when GNU_LINUX
		cores = File.open '/proc/stat' do |file|
			file.readline
			n_cores = 0
			n_cores += 1 while file.readline.start_with? 'cpu'
			
			Array.new n_cores do
				Core.new (
					Processes.new 0, 0, 0, 0, 0
				), (
					Processes.new 0, 0, 0, 0, 0
				)
			end
		end
	when ANDROID
		cores = []
	end
	
	CPU = Struct.new :cores do
		case RUBY_PLATFORM
		when GNU_LINUX
			def update!
				file = File.open '/proc/stat'
				
				cores.each do |core|
					values = file.readline.split.map &:to_i
					values.shift
					
					core.current.each_pair {|name, value|
						core.previous[name] = value
						core.current[name] = values.shift
					}
				end
			end
		when ANDROID
			def update!
				# :c
			end
		end
	end.new cores
end








