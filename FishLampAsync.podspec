Pod::Spec.new do |s|
   
    s.name         = "FishLampAsync"
    s.version      = "0.1.0"
    s.summary      = "This is the core functionality of the FishLamp Framework."
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampAsync.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false

	s.dependency 'FishLampCore'
	s.dependency 'FishLampStrings'
	s.dependency 'FishLampSimpleLogger'
	s.dependency 'FishLampEvents'
	s.dependency 'FishLampTimer'

	s.source_files = 'Classes/*.{h,m}'

	s.subspec 'GCD' do |ss|
		ss.source_files = 'Classes/GCD/*.{h,m}'
	end

	s.subspec 'OperationQueue' do |ss|
		ss.source_files = 'Classes/OperationQueue/*.{h,m}'
	end

	s.subspec 'Operations' do |ss|
		ss.source_files = 'Classes/Operations/*.{h,m}'
	end

	s.subspec 'Results' do |ss|
		ss.source_files = 'Classes/Results/*.{h,m}'
	end

	s.subspec 'Utils' do |ss|
		ss.source_files = 'Classes/Utils/*.{h,m}'
	end

end


