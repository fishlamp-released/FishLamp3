Pod::Spec.new do |s|
   
    s.name         = "FishLamp"
    s.version      = "0.0.2"
    s.summary      = "This is the pod for FishLamp"
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampCore.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false
	s.default_subspec = 'Core'
    
#     s.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
#     s.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'


	s.subspec 'Core' do |ss|
	
		ss.source_files = 'Core/*.h'

		ss.subspec 'ObjcCompiling' do |sss|
			sss.source_files = 'Core/ObjcCompiling/**/*.{h,m}'
		end

		ss.subspec 'Atomic' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.source_files = 'Core/Atomic/*.{h,m}'
		end

		ss.subspec 'ObjcPropertyDeclaring' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.dependency 'FishLampCore/Core/Atomic'
			sss.source_files = 'Core/ObjcPropertyDeclaring/*.{h,m}'
		end

		ss.subspec 'Errors' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.dependency 'FishLampCore/Core/StackTrace'
			sss.source_files = 'Core/Errors/*.{h,m}'
		end

		ss.subspec 'Exceptions' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.dependency 'FishLampCore/Core/Errors'
			sss.source_files = 'Core/Exceptions/*.{h,m}'
		end

		ss.subspec 'Assertions' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.source_files = 'Core/Assertions/*.{h,m}'
		end

		ss.subspec 'Performing' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.source_files = 'Core/Performing/*.{h,m}'
		end

		ss.subspec 'StackTrace' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.source_files = 'Core/StackTrace/*.{h,m}'
		end

		ss.subspec 'Utils' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.source_files = 'Core/Utils/*.{h,m}'
		end

		ss.subspec 'Versioning' do |sss|
			sss.dependency 'FishLampCore/Core/ObjcCompiling'
			sss.source_files = 'Core/Versioning/*.{h,m}'
		end

		ss.subspec 'Strings' do |sss|
			sss.source_files = 'Core/Strings/*.{h,m}'
		end

		ss.subspec 'SimpleLogger' do |sss|
			sss.source_files = 'Core/SimpleLogger/*.{h,m}'
		end
	end
	
	s.subspec 'CoreTests' do |ss|
# 		ss.dependency 'FishLampCore/ss'
		ss.source_files = 'Core/Tests/**/*.{h,m}'
	end

    s.xcconfig = {
        "CLANG_ANALYZER_DEADCODE_DEADSTORES" => "YES",
        "CLANG_ANALYZER_GCD" => "YES",
        "CLANG_ANALYZER_MALLOC" => "YES",
        "CLANG_ANALYZER_MEMORY_MANAGEMENT" => "YES",
        "CLANG_ANALYZER_OBJC_ATSYNC" => "YES",
        "CLANG_ANALYZER_OBJC_CFNUMBER" => "YES",
        "CLANG_ANALYZER_OBJC_COLLECTIONS" => "YES",
        "CLANG_ANALYZER_OBJC_INCOMP_METHOD_TYPES" => "YES",
        "CLANG_ANALYZER_OBJC_NSCFERROR" => "YES",
        "CLANG_ANALYZER_OBJC_RETAIN_COUNT" => "YES",
        "CLANG_ANALYZER_OBJC_SELF_INIT" => "YES",
        "CLANG_ANALYZER_OBJC_UNUSED_IVARS" => "YES",
        "CLANG_ANALYZER_SECURITY_INSECUREAPI_GETPW_GETS" => "YES",
        "CLANG_ANALYZER_SECURITY_INSECUREAPI_MKSTEMP" => "YES",
        "CLANG_ANALYZER_SECURITY_INSECUREAPI_STRCPY" => "YES",
        "CLANG_ANALYZER_SECURITY_INSECUREAPI_UNCHECKEDRETURN" => "YES",
        "CLANG_ANALYZER_SECURITY_INSECUREAPI_VFORK" => "YES",
        "CLANG_ANALYZER_SECURITY_KEYCHAIN_API" => "YES",
        "CLANG_WARN_BOOL_CONVERSION" => "YES",
        "CLANG_WARN_CONSTANT_CONVERSION" => "YES",
        "CLANG_WARN_CXX0X_EXTENSIONS" => "YES",
        "CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS" => "YES",
        "CLANG_WARN_DIRECT_OBJC_ISA_USAGE" => "YES_ERROR",
        "CLANG_WARN_EMPTY_BODY" => "YES",
        "CLANG_WARN_OBJCPP_ARC_ABI" => "YES",
        "CLANG_WARN_OBJC_MISSING_PROPERTY_SYNTHESIS" => "YES",
        "CLANG_WARN_OBJC_RECEIVER_WEAK" => "YES",
        "CLANG_WARN_OBJC_ROOT_CLASS" => "YES",
        "CLANG_WARN__ARC_BRIDGE_CAST_NONARC" => "YES",
        "CLANG_WARN__DUPLICATE_METHOD_MATCH" => "YES",
        "GCC_WARN_64_TO_32_BIT_CONVERSION" => "YES",
        "GCC_WARN_64_TO_32_BIT_CONVERSION" => "YES",
        "GCC_WARN_ABOUT_DEPRECATED_FUNCTIONS" => "YES",
        "GCC_WARN_ABOUT_INVALID_OFFSETOF_MACRO" => "YES",
        "GCC_WARN_ABOUT_MISSING_FIELD_INITIALIZERS" => "YES",
        "GCC_WARN_ABOUT_MISSING_PROTOTYPES" => "YES",
        "GCC_WARN_ABOUT_POINTER_SIGNEDNESS" => "YES",
        "GCC_WARN_ABOUT_RETURN_TYPE" => "YES",
        "GCC_WARN_ALLOW_INCOMPLETE_PROTOCOL" => "YES",
        "GCC_WARN_CHECK_SWITCH_STATEMENTS" => "YES",
        "GCC_WARN_INITIALIZER_NOT_FULLY_BRACKETED" => "YES",
        "GCC_WARN_MISSING_PARENTHESES" => "YES",
        "GCC_WARN_SHADOW" => "YES",
        "GCC_WARN_TYPECHECK_CALLS_TO_PRINTF" => "YES",
        "GCC_WARN_UNDECLARED_SELECTOR" => "YES",
        "GCC_WARN_UNINITIALIZED_AUTOS" => "YES",
        "GCC_WARN_UNUSED_LABEL" => "YES",
        "GCC_WARN_UNUSED_VALUE" => "YES",
        "GCC_WARN_UNUSED_VARIABLE" => "YES",
        "CLANG_ANALYZER_SECURITY_INSECUREAPI_RAND" => "NO",
        "CLANG_WARN__EXIT_TIME_DESTRUCTORS" => "NO",
        "CLANG_WARN_IMPLICIT_SIGN_CONVERSION" => "NO",
        "CLANG_WARN_SUSPICIOUS_IMPLICIT_CONVERSION" => "NO",
        "CLANG_WARN_OBJC_IMPLICIT_ATOMIC_PROPERTIES" => "NO",
        "CLANG_ANALYZER_SECURITY_FLOATLOOPCOUNTER" => "NO",
        "GCC_WARN_ABOUT_MISSING_NEWLINE" => "NO",
        "GCC_TREAT_INCOMPATIBLE_POINTER_TYPE_WARNINGS_AS_ERRORS" => "NO",
        "GCC_WARN_UNKNOWN_PRAGMAS" => "NO",
        "GCC_WARN_FOUR_CHARACTER_CONSTANTS" => "NO",
        "GCC_WARN_HIDDEN_VIRTUAL_FUNCTIONS" => "NO",
        "GCC_WARN_INHIBIT_ALL_WARNINGS" => "NO",
        "GCC_WARN_UNUSED_FUNCTION" => "NO",
        "GCC_WARN_UNUSED_PARAMETER" => "NO",
        "GCC_WARN_MULTIPLE_DEFINITION_TYPES_FOR_SELECTOR" => "NO",
        "GCC_WARN_NON_VIRTUAL_DESTRUCTOR" => "NO",
        "GCC_WARN_PEDANTIC" => "NO",
        "GCC_WARN_SIGN_COMPARE" => "NO",
        "GCC_WARN_STRICT_SELECTOR_MATCH" => "NO",
        "GCC_TREAT_WARNINGS_AS_ERRORS" => "YES"
    }

    s.compiler_flags = '-Werror', '-Waddress', '-Warray-bounds', '-Wc++11-compat', '-Wchar-subscripts', '-Wimplicit-function-declaration', '-Wcomment', '-Wformat', '-Wmain ', '-Wmissing-braces', '-Wnonnull', '-Wparentheses', '-Wpointer-sign', '-Wreorder', '-Wreturn-type', '-Wsequence-point', '-Wsign-compare', '-Wswitch', '-Wtrigraphs'

end
