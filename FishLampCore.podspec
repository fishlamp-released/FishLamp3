#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
   
    s.name         = "FishLampCore"
    s.version      = "0.1.0"
    s.summary      = "This is the core pod for the rest of the FishLamp pods"
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampCore.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false
    
#     s.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
#     s.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'

	s.source_files = 'Classes/FishLampCore.h', 'Classes/FishLampRequired.h', 'Classes/FishLampCoreRequired.h'

	s.subspec 'ObjcCompiling' do |ss|
		ss.source_files = 'Classes/ObjcCompiling/**/*.{h,m}'
	end

	s.subspec 'Atomic' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.source_files = 'Classes/Atomic/**/*.{h,m}'
	end

	s.subspec 'ObjcPropertyDeclaring' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.dependency 'FishLampCore/Atomic'
		ss.source_files = 'Classes/ObjcPropertyDeclaring/**/*.{h,m}'
	end

	s.subspec 'Errors' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.dependency 'FishLampCore/StackTrace'
		ss.source_files = 'Classes/Errors/**/*.{h,m}'
	end

	s.subspec 'Exceptions' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.dependency 'FishLampCore/Errors'
		ss.source_files = 'Classes/Exceptions/**/*.{h,m}'
	end

	s.subspec 'Assertions' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.source_files = 'Classes/Assertions/**/*.{h,m}'
	end

	s.subspec 'Performing' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.source_files = 'Classes/Performing/**/*.{h,m}'
	end

	s.subspec 'StackTrace' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.source_files = 'Classes/StackTrace/**/*.{h,m}'
	end

	s.subspec 'Utils' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.source_files = 'Classes/Utils/**/*.{h,m}'
	end

	s.subspec 'Versioning' do |ss|
		ss.dependency 'FishLampCore/ObjcCompiling'
		ss.source_files = 'Classes/Versioning/**/*.{h,m}'
	end




# 	s.subspec 'Assertions' do |ss|
# 		ss.source_files = 'Classes/Assertions/**/*.{h,m}'
# 		ss.dependency 'FishLampCore/Errors'
# 
#  		ss.dependency 'FishLamp/Cocoa/Core/Strings'
# 	end

# 	s.subspec 'SimpleLogger' do |ss|
# 		ss.dependency 'FishLamp/Cocoa/Core/Required'
# 		ss.dependency 'FishLamp/Cocoa/Core/Strings'
# 		ss.dependency 'FishLamp/Cocoa/Core/Errors'
# 		ss.dependency 'FishLamp/Cocoa/Core/Assertions'
# 		ss.source_files = 'Classes/SimpleLogger/**/*.{h,m}'
# 	end
  
end

