require_relative 'platform'

module PMeter
	case RUBY_PLATFORM
	when GNU_LINUX
		BATTERY = Struct.new *%i[
			charging
			relative
			percent
			name
		] do
			PATH = %w[
				/sys/class/power_supply/BAT0
				/sys/class/power_supply/BAT1
				/sys/class/power_supply/BAT2
			].find do |file|
				File.exists? file
			end
			
			def update!
				hash = (File.read PATH).lines.to_h {|line|
					name, value = line.split '='
					[name [12..], value]
				}
				
				self.charging = hash ['STATUS'] == 'Charging'
				self.relative = (
					hash ['CHARGE_NOW'].to_i
				).fdiv (
					hash ['CHARGE_FULL'].to_i
				)
				self.percent  = relative * 100.0
				self.name     = hash ['NAME']
			end
		end.new
	when ANDROID
		BATTERY = Struct.new *%i[
			temperature
			charging
			plugged
			percent
			health
		] do
			def self.update
				json JSON.parse `termux-battery-status`
				
				self.temperature = json ['temperature']
				self.charging    = json ['status'].eql? 'CHARGING'
				self.plugged     = json ['plugged'].eql? 'PLUGGED'
				self.percent     = json ['percentage'].to_f
				self.health      = json ['health']
			end
		end
	end
end












