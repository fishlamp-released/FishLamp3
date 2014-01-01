#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
   
    s.name         = "FishLampAsync"
    s.version      = "0.1.0"
    s.summary      = "This is the core functionality of the FishLamp Framework."
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampPrerelease.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false
    
#     s.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
#     s.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'

	s.dependency 'FishLampCore'
	s.dependency 'FishLampStrings'
	s.dependency 'FishLampSimpleLogger'

	s.dependency 'FishLampPrerelease/Events'
	s.dependency 'FishLampPrerelease/Timer'

	s.source_files = 'Classes/**/*.{h,m}'

end


