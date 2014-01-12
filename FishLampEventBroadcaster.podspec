Pod::Spec.new do |s|
   
    s.name         = "FishLampEventBroadcaster"
    s.version      = "0.0.1"
    s.summary      = "This is the core pod for the rest of the FishLamp pods"
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampSimpleLogger.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false
    
	s.dependency 'FishLampCore'
	s.source_files = 'Classes/**/*.{h,m}'
end

