Pod::Spec.new do |s|
	s.name         = "FishLampNetworking"
    s.version      = "0.0.1"
    s.summary      = "This is the core functionality of the FishLamp Framework."
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampNetworking.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false

# 	s.source_files  = 'Classes', 'Classes/**/*.{h,m}'

	s.dependency 'FishLampCore'
	s.dependency 'FishLampStrings'
	s.dependency 'FishLampSimpleLogger'

	s.subspec 'Activity' do |ss|
		ss.dependency 'FishLampEventBroadcaster'
		ss.source_files = 'Classes/Activity/**/*.{h,m}'
	end
	
	s.subspec 'Errors' do |ss|
		ss.source_files = 'Classes/Errors/**/*.{h,m}'
	end

	s.subspec 'Reachability' do |ss|
		ss.ios.frameworks = 'SystemConfiguration'
		ss.osx.frameworks = 'SystemConfiguration'

		ss.source_files = 'Classes/Reachability/**/*.{h,m}'
	end

	s.subspec 'Sinks' do |ss|
		ss.source_files = 'Classes/Sinks/**/*.{h,m}'
	end

	s.subspec 'Streams' do |ss|
		ss.dependency 'FishLampEventBroadcaster'
		ss.dependency 'FishLampTimer'
		ss.dependency 'FishLampAsync'
		ss.dependency 'FishLampNetworking/Sinks'

		ss.ios.frameworks = 'CFNetwork'
		ss.osx.frameworks = 'CFNetwork'

		ss.source_files = 'Classes/Streams/**/*.{h,m}'
	end

	s.subspec 'ProtocolSupport' do |ss|
		ss.dependency 'FishLampStrings'
		ss.dependency 'FishLampEventBroadcaster'
		ss.dependency 'FishLampAsync'
		ss.dependency 'FishLampTimer'

		ss.dependency 'FishLampRetryHandler'
		ss.dependency 'FishLampBundleUtils'
		ss.dependency 'FishLampCodeBuilder'
		ss.dependency 'FishLampEncoding'
		ss.dependency 'FishLampModelObject'
		ss.dependency 'FishLampAuthentication'
		ss.dependency 'FishLampServices'

		ss.dependency 'FishLampNetworking/Activity'
		ss.dependency 'FishLampNetworking/Streams'
		ss.dependency 'FishLampNetworking/Sinks'
		ss.dependency 'FishLampNetworking/Reachability'
		ss.dependency 'FishLampNetworking/Errors'
	end

	s.subspec 'DNS' do |ss|
		ss.dependency 'FishLampNetworking/ProtocolSupport'
		ss.source_files = 'Classes/Protocols/DNS/**/*.{h,m}'
	end

	s.subspec 'HTTP' do |ss|
		ss.dependency 'FishLampNetworking/ProtocolSupport'
		ss.source_files = 'Classes/Protocols/HTTP/**/*.{h,m}'
	end

	s.subspec 'Json' do |ss|
		ss.dependency 'FishLampNetworking/HTTP'
		ss.source_files = 'Classes/Protocols/Json/**/*.{h,m}'
	end

	s.subspec 'Soap' do |ss|
		ss.dependency 'FishLampNetworking/HTTP'
		ss.source_files = 'Classes/Protocols/Soap/**/*.{h,m}'
	end

	s.subspec 'Oauth' do |ss|
		ss.dependency 'FishLampNetworking/HTTP'
		ss.source_files = 'Classes/Protocols/Oauth/**/*.{h,m}'
	end

	s.subspec 'Tcp' do |ss|
		ss.dependency 'FishLampNetworking/ProtocolSupport'
		ss.source_files = 'Classes/Protocols/Tcp/**/*.{h,m}'
	end

	s.subspec 'XmlRpc' do |ss|
		ss.dependency 'FishLampNetworking/ProtocolSupport'
		ss.source_files = 'Classes/Protocols/XmlRpc/**/*.{h,m}'
	end

end
