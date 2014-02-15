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

	s.dependency 'FishLampCore'

	s.source_files  = 'Classes/*.h'

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
		s
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
