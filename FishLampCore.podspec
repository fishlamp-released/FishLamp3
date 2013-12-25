#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |fishlamp|
   
    fishlamp.name         = "FishLampCore"
    fishlamp.version      = "3.0.0"
    fishlamp.summary      = "This is the core functionality of the FishLamp Framework."
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

	core.source_files = 'FishLampCocoa/Classes/FishLampCore.h'

	core.subspec 'Required' do |ss|
		ss.source_files = 'FishLampCocoa/Classes/Required/**/*.{h,m}'
	end

	core.subspec 'Strings' do |ss|
		ss.source_files = 'FishLampCocoa/Classes/Strings/**/*.{h,m}'
	end

	core.subspec 'Errors' do |ss|
		ss.dependency 'FishLamp/Cocoa/Core/Required'
		ss.dependency 'FishLamp/Cocoa/Core/Strings'
		ss.source_files = 'FishLampCocoa/Classes/Errors/**/*.{h,m}'
	end

	core.subspec 'Assertions' do |ss|
		ss.source_files = 'FishLampCocoa/Classes/Assertions/**/*.{h,m}'
		ss.dependency 'FishLamp/Cocoa/Core/Strings'
		ss.dependency 'FishLamp/Cocoa/Core/Errors'
	end

# 	core.subspec 'SimpleLogger' do |ss|
# 		ss.dependency 'FishLamp/Cocoa/Core/Required'
# 		ss.dependency 'FishLamp/Cocoa/Core/Strings'
# 		ss.dependency 'FishLamp/Cocoa/Core/Errors'
# 		ss.dependency 'FishLamp/Cocoa/Core/Assertions'
# 		ss.source_files = 'FishLampCocoa/Classes/SimpleLogger/**/*.{h,m}'
# 	end
  
end

