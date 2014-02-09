Pod::Spec.new do |s|
   
    s.name         = "FishLampCore"
    s.version      = "0.0.1"
    s.summary      = "This is the core pod for the rest of the FishLamp pods"
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampCore.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false
	s.default_subspec = 'Classes'
    
#     s.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
#     s.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'


	s.subspec 'Classes' do |classes|
	
		classes.source_files = 'Classes/*.h'

		classes.subspec 'ObjcCompiling' do |ss|
			ss.source_files = 'Classes/ObjcCompiling/**/*.{h,m}'
		end

		classes.subspec 'Atomic' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.source_files = 'Classes/Atomic/**/*.{h,m}'
		end

		classes.subspec 'ObjcPropertyDeclaring' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.dependency 'FishLampCore/Classes/Atomic'
			ss.source_files = 'Classes/ObjcPropertyDeclaring/**/*.{h,m}'
		end

		classes.subspec 'Errors' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.dependency 'FishLampCore/Classes/StackTrace'
			ss.source_files = 'Classes/Errors/**/*.{h,m}'
		end

		classes.subspec 'Exceptions' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.dependency 'FishLampCore/Classes/Errors'
			ss.source_files = 'Classes/Exceptions/**/*.{h,m}'
		end

		classes.subspec 'Assertions' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.source_files = 'Classes/Assertions/**/*.{h,m}'
		end

		classes.subspec 'Performing' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.source_files = 'Classes/Performing/**/*.{h,m}'
		end

		classes.subspec 'StackTrace' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.source_files = 'Classes/StackTrace/**/*.{h,m}'
		end

		classes.subspec 'Utils' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.source_files = 'Classes/Utils/**/*.{h,m}'
		end

		classes.subspec 'Versioning' do |ss|
			ss.dependency 'FishLampCore/Classes/ObjcCompiling'
			ss.source_files = 'Classes/Versioning/**/*.{h,m}'
		end
	end
	
	s.subspec 'Tests' do |ss|
# 		ss.dependency 'FishLampCore/Classes'
	
		ss.source_files = 'Tests/**/*.{h,m}'
	end


end

