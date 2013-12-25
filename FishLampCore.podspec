#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |fishlamp|
   
    fishlamp.name         = "FishLampCore"
    fishlamp.version      = "3.0.0"
    fishlamp.summary      = "This is the core pod for the rest of the FishLamp pods"
    fishlamp.homepage     = "http://fishlamp.com"
    fishlamp.license      = 'MIT'
    fishlamp.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    fishlamp.source       = { :git => "https://github.com/fishlamp/fishlamp-cocoa.git", :tag => fishlamp.version.to_s }

    fishlamp.ios.deployment_target = '6.1'
    fishlamp.osx.deployment_target = '10.6'
    fishlamp.requires_arc = false
    
#     fishlamp.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
#     fishlamp.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'

# these are the core pods

	fishlamp.source_files = 'Classes/FishLampCore.h'

	fishlamp.subspec 'Required' do |ss|
		ss.source_files = 'Classes/Required/**/*.{h,m}'
	end

# 	fishlamp.subspec 'Strings' do |ss|
# 		ss.source_files = 'Classes/Strings/**/*.{h,m}'
# 	end

	fishlamp.subspec 'Errors' do |ss|
		ss.dependency 'FishLampCore/Required'
		ss.source_files = 'Classes/Errors/**/*.{h,m}'


# 		ss.dependency 'FishLamp/Cocoa/Core/Strings'
	end

	fishlamp.subspec 'Assertions' do |ss|
		ss.source_files = 'Classes/Assertions/**/*.{h,m}'
		ss.dependency 'FishLampCore/Errors'

# 		ss.dependency 'FishLamp/Cocoa/Core/Strings'
	end

# 	fishlamp.subspec 'SimpleLogger' do |ss|
# 		ss.dependency 'FishLamp/Cocoa/Core/Required'
# 		ss.dependency 'FishLamp/Cocoa/Core/Strings'
# 		ss.dependency 'FishLamp/Cocoa/Core/Errors'
# 		ss.dependency 'FishLamp/Cocoa/Core/Assertions'
# 		ss.source_files = 'Classes/SimpleLogger/**/*.{h,m}'
# 	end
  
end

