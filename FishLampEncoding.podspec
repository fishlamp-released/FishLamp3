Pod::Spec.new do |s|
	s.name         = "FishLampEncoding"
    s.version      = "0.0.1"
    s.summary      = "This is the core functionality of the FishLamp Framework."
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLamps.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false

	s.source_files  = 'Classes/*h'

	s.dependency 'FishLampCore'
	s.dependency 'FishLampStrings'
	s.dependency 'FishLampSimpleLogger'
	s.dependency 'FishLampObjcRuntime'
	s.dependency 'FishLampUtils'
	s.dependency 'FishLampCodeBuilder'

	s.subspec 'Xml' do |ss|
		ss.source_files = 'Classes/Xml/**/*.{h,m}'
	end

	s.subspec 'Json' do |ss|
		ss.source_files = 'Classes/Json/**/*.{h,m}'
	end

	s.subspec 'Url' do |ss|
		ss.source_files = 'Classes/URL/**/*.{h,m}'
	end

	s.subspec 'Soap' do |ss|
		ss.source_files = 'Classes/Soap/**/*.{h,m}'
	end

	s.subspec 'Html' do |ss|
		ss.source_files = 'Classes/Html/**/*.{h,m}'
	end

	s.subspec 'Base64' do |ss|
		ss.source_files = 'Classes/Base64/**/*.{h,m,c}'
	end

	s.xcconfig = { 'GCC_TREAT_WARNINGS_AS_ERRORS' => 'YES' }
end
