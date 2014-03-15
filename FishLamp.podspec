Pod::Spec.new do |s|
   
    s.name         = "FishLamp"
    s.version      = "0.0.2"
    s.summary      = "This is the pod for FishLamp"
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampCore.git", :tag => s.version.to_s }

    s.ios.deployment_target = '7.0'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false
	s.default_subspec = 'Core'
    
#     s.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
#     s.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'


	s.subspec 'Core' do |ss|
	
		ss.source_files = 'Core/Classes/*.h'

		ss.subspec 'ObjcCompiling' do |folder|
			folder.source_files = 'Core/Classes/ObjcCompiling/**/*.{h,m}'
		end

		ss.subspec 'Atomic' do |folder|
			folder.source_files = 'Core/Classes/Atomic/*.{h,m}'
		end

		ss.subspec 'ObjcPropertyDeclaring' do |folder|
			folder.source_files = 'Core/Classes/ObjcPropertyDeclaring/*.{h,m}'
		end

		ss.subspec 'Errors' do |folder|
			folder.source_files = 'Core/Classes/Errors/*.{h,m}'
		end

		ss.subspec 'Exceptions' do |folder|
			folder.source_files = 'Core/Classes/Exceptions/*.{h,m}'
		end

		ss.subspec 'Assertions' do |folder|
			# folder.dependency 'FishLamp/Core/ObjcCompiling'
			folder.source_files = 'Core/Classes/Assertions/*.{h,m}'
		end

		ss.subspec 'Performing' do |folder|
			# folder.dependency 'FishLamp/Core/ObjcCompiling'
			folder.source_files = 'Core/Classes/Performing/*.{h,m}'
		end

		ss.subspec 'StackTrace' do |folder|
			# folder.dependency 'FishLamp/Core/ObjcCompiling'
			folder.source_files = 'Core/Classes/StackTrace/*.{h,m}'
		end

		ss.subspec 'Utils' do |folder|
			folder.source_files = 'Core/Classes/Utils/*.{h,m}'
		end

		ss.subspec 'Versioning' do |folder|
			folder.source_files = 'Core/Classes/Versioning/*.{h,m}'
		end

		ss.subspec 'Strings' do |folder|
			folder.source_files = 'Core/Classes/Strings/*.{h,m}'
		end

		ss.subspec 'SimpleLogger' do |folder|
			folder.source_files = 'Core/Classes/SimpleLogger/*.{h,m}'
		end
	end
	
	s.subspec 'CoreTests' do |ss|
		ss.source_files = 'Core/Tests/**/*.{h,m}'
	end

    s.subspec 'EventBroadcaster' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'EventBroadcaster/Classes/**/*.{h,m}'
    end

    s.subspec 'Timer' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'Timer/Classes/**/*.{h,m}'
    end

    s.subspec 'ByteBuffer' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'ByteBuffer/Classes/**/*.{h,m}'
    end

    s.subspec 'Utils' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'Utils/Classes/**/*.{h,m}'
    end

    s.subspec 'BundleUtils' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'BundleUtils/Classes/**/*.{h,m}'
    end

    s.subspec 'Async' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/EventBroadcaster'
        ss.dependency 'FishLamp/Timer'

        ss.source_files = 'Async/Classes/*.{h,m}'

        ss.subspec 'GCD' do |folder|
            folder.source_files = 'Async/Classes/GCD/*.{h,m}'
        end

        ss.subspec 'OperationQueue' do |folder|
            folder.source_files = 'Async/Classes/OperationQueue/*.{h,m}'
        end

        ss.subspec 'Operations' do |folder|
            folder.source_files = 'Async/Classes/Operations/*.{h,m}'
        end

        ss.subspec 'Results' do |folder|
            folder.source_files = 'Async/Classes/Results/*.{h,m}'
        end

        ss.subspec 'Utils' do |folder|
            folder.source_files = 'Async/Classes/Utils/*.{h,m}'
        end
    end

    s.subspec 'UserPrefs' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'UserPrefs/Classes/**/*.{h,m}'
    end

    s.subspec 'Services' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'Services/Classes/**/*.{h,m}'
    end

    s.subspec 'ObjcRuntime' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'ObjcRuntime/Classes/**/*.{h,m}'
    end

    s.subspec 'MoreStrings' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/Utils'
        ss.source_files = 'MoreStrings/Classes/**/*.{h,m}'
    end

    s.subspec 'Storage' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/Files'
        ss.source_files = 'Storage/Classes/**/*.{h,m}'
    end

    s.subspec 'CommandLineProcessor' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'CommandLineProcessor/Classes/**/*.{h,m}'
    end
    
    s.subspec 'Containers' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'Containers/Classes/**/*.{h,m}'
    end

    s.subspec 'Files' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'Files/Classes/**/*.{h,m}'
    end
    
    s.subspec 'CodeBuilder' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/MoreStrings'
        ss.source_files = 'CodeBuilder/Classes/**/*.{h,m}'
    end
    
    s.subspec 'CodeGenerator' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/CodeBuilder'
        ss.source_files = 'CodeGenerator/Classes/**/*.{h,m}'
    end

    s.subspec 'Keychain' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'Keychain/Classes/**/*.{h,m}'
    end

    s.subspec 'ModelObject' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/ObjcRuntime'
        ss.dependency 'FishLamp/Containers'
        ss.source_files = 'ModelObject/Classes/**/*.{h,m}'
    end

    s.subspec 'Database' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.library = 'sqlite3'
        ss.source_files = 'Database/Classes/**/*.{h,m}'
    end
    
    s.subspec 'ObjectDatabase' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/ModelObject'
        ss.dependency 'FishLamp/ObjcRuntime'
        ss.dependency 'FishLamp/Database'
        ss.dependency 'FishLamp/Storage'
        ss.dependency 'FishLamp/Services'
        ss.dependency 'FishLamp/Async'
        ss.source_files = 'ObjectDatabase/Classes/**/*.{h,m}'
    end

    s.subspec 'Testables' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.source_files = 'Testables/Classes/*.{h,m}'

        ss.subspec 'Async' do |folder|
            folder.source_files = 'Testables/Classes/Async/*.{h,m}'
        end

        ss.subspec 'Discovery' do |folder|
            folder.source_files = 'Testables/Classes/Discovery/*.{h,m}'
        end

        ss.subspec 'Factories' do |folder|
            folder.source_files = 'Testables/Classes/Factories/*.{h,m}'
        end

        ss.subspec 'Lists' do |folder|
            folder.source_files = 'Testables/Classes/Lists/*.{h,m}'
        end

        ss.subspec 'Logging' do |folder|
            folder.source_files = 'Testables/Classes/Logging/*.{h,m}'
        end

        ss.subspec 'Results' do |folder|
            folder.source_files = 'Testables/Classes/Results/*.{h,m}'
        end

        ss.subspec 'Running' do |folder|
            folder.source_files = 'Testables/Classes/Running/*.{h,m}'
        end

        ss.subspec 'Testable' do |folder|
            folder.source_files = 'Testables/Classes/Testable/*.{h,m}'
        end

        ss.subspec 'TestApp' do |folder|
            folder.source_files = 'Testables/Classes/TestApp/*.{h,m}'
        end

        ss.subspec 'TestCase' do |folder|
            folder.source_files = 'Testables/Classes/TestCase/*.{h,m}'
        end

        ss.subspec 'Tests' do |folder|
            folder.source_files = 'Testables/Classes/Tests/*.{h,m}'
        end

        ss.subspec 'Utils' do |folder|
            folder.source_files = 'Testables/Classes/Utils/*.{h,m}'
        end        
    end

    s.subspec 'TestablesOSX' do |ss|
        ss.dependency 'FishLamp/Testables'
        ss.source_files = 'Testables/OSX/**/*.{h,m}'
        ss.resources = ['Testables/OSX/**/*.{png,xib}']
    end

    s.subspec 'Encoding' do |ss|
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/ObjcRuntime'
        ss.dependency 'FishLamp/CodeBuilder'

        ss.source_files  = 'Encoding/Classes/*h'

        ss.subspec 'Xml' do |folder|
            folder.source_files = 'Encoding/Classes/Xml/**/*.{h,m}'
        end

        ss.subspec 'Json' do |folder|
            folder.source_files = 'Encoding/Classes/Json/**/*.{h,m}'
        end

        ss.subspec 'Url' do |folder|
            folder.source_files = 'Encoding/Classes/URL/**/*.{h,m}'
        end

        ss.subspec 'Soap' do |folder|
            folder.source_files = 'Encoding/Classes/Soap/**/*.{h,m}'
        end

        ss.subspec 'Html' do |folder|
            folder.source_files = 'Encoding/Classes/Html/**/*.{h,m}'
        end

        ss.subspec 'Base64' do |folder|
            folder.source_files = 'Encoding/Classes/Base64/**/*.{h,m,c}'
        end
    end

  	s.subspec 'Networking' do |ss|
        ss.dependency 'FishLamp/Core'
		ss.source_files  = 'Networking/Classes/*.h'

		ss.subspec 'Reachability' do |folder|
			folder.ios.frameworks = 'SystemConfiguration'
			folder.osx.frameworks = 'SystemConfiguration'
			folder.source_files = 'Networking/Classes/Reachability/**/*.{h,m}'
		end

		ss.subspec 'Activity' do |folder|
			folder.dependency 'FishLamp/EventBroadcaster'
			folder.source_files = 'Networking/Classes/Activity/**/*.{h,m}'
		end
	   
		ss.subspec 'Authentication' do |folder|
			folder.dependency 'FishLamp/EventBroadcaster'
			folder.dependency 'FishLamp/Keychain'
			folder.source_files = 'Networking/Classes/Authentication/**/*.{h,m}'
		end
		
		ss.subspec 'Errors' do |folder|
			folder.source_files = 'Networking/Classes/Errors/**/*.{h,m}'
		end
	
		ss.subspec 'Sinks' do |folder|
			folder.source_files = 'Networking/Classes/Sinks/**/*.{h,m}'
		end

		ss.subspec 'Utils' do |folder|
            ss.dependency 'FishLamp/Files'
			folder.source_files = 'Networking/Classes/Utils/**/*.{h,m}'
		end

		ss.subspec 'Streams' do |folder|
			folder.dependency 'FishLamp/EventBroadcaster'
			folder.dependency 'FishLamp/Timer'
			folder.dependency 'FishLamp/Async'
			folder.dependency 'FishLamp/Networking/Errors'
			folder.dependency 'FishLamp/Networking/Utils'
			folder.dependency 'FishLamp/Networking/Sinks'
			folder.ios.frameworks = 'CFNetwork'
			folder.osx.frameworks = 'CFNetwork'
			folder.source_files = 'Networking/Classes/Streams/**/*.{h,m}'
		end





		ss.subspec 'Protocol' do |protocol|
			protocol.dependency 'FishLamp/EventBroadcaster'
			protocol.dependency 'FishLamp/Async'
			protocol.dependency 'FishLamp/Timer'
			protocol.dependency 'FishLamp/BundleUtils'
			protocol.dependency 'FishLamp/CodeBuilder'
			protocol.dependency 'FishLamp/ModelObject'
			protocol.dependency 'FishLamp/Services'
			protocol.dependency 'FishLamp/Storage'

			protocol.dependency 'FishLamp/Encoding'
		
			protocol.dependency 'FishLamp/Networking/Errors'
			protocol.dependency 'FishLamp/Networking/Utils'
			protocol.dependency 'FishLamp/Networking/Sinks'
			protocol.dependency 'FishLamp/Networking/Activity'
			protocol.dependency 'FishLamp/Networking/Authentication'
			protocol.dependency 'FishLamp/Networking/Reachability'
			protocol.dependency 'FishLamp/Networking/Streams'
	
			protocol.subspec 'DNS' do |folder|
				folder.source_files = 'Networking/Classes/Protocols/DNS/**/*.{h,m}'
			end

			protocol.subspec 'HTTP' do |folder|
				folder.source_files = 'Networking/Classes/Protocols/HTTP/**/*.{h,m}'
			end

			protocol.subspec 'Json' do |folder|
				folder.dependency 'FishLamp/Networking/Protocol/HTTP'
				folder.source_files = 'Networking/Classes/Protocols/Json/**/*.{h,m}'
			end

			protocol.subspec 'Soap' do |folder|
				folder.dependency 'FishLamp/Networking/Protocol/HTTP'
				folder.source_files = 'Networking/Classes/Protocols/Soap/**/*.{h,m}'
			end

			protocol.subspec 'Oauth' do |folder|
				folder.dependency 'FishLamp/Networking/Protocol/HTTP'
				folder.source_files = 'Networking/Classes/Protocols/Oauth/**/*.{h,m}'
			end

			protocol.subspec 'Tcp' do |folder|
				folder.source_files = 'Networking/Classes/Protocols/Tcp/**/*.{h,m}'
			end

			protocol.subspec 'XmlRpc' do |folder|
				folder.source_files = 'Networking/Classes/Protocols/XmlRpc/**/*.{h,m}'
			end
		end
	end  

    s.subspec 'All' do |ss|
        ss.dependency 'FishLamp/Async'
        ss.dependency 'FishLamp/BundleUtils'
        ss.dependency 'FishLamp/ByteBuffer'
        ss.dependency 'FishLamp/CodeBuilder'
        ss.dependency 'FishLamp/CodeGenerator'
        ss.dependency 'FishLamp/CommandLineProcessor'
        ss.dependency 'FishLamp/Containers'
        ss.dependency 'FishLamp/Database'
        ss.dependency 'FishLamp/Encoding'
        ss.dependency 'FishLamp/EventBroadcaster'
        ss.dependency 'FishLamp/Files'
        ss.dependency 'FishLamp/Keychain'
        ss.dependency 'FishLamp/ModelObject'
        ss.dependency 'FishLamp/MoreStrings'
        ss.dependency 'FishLamp/Networking'
        ss.dependency 'FishLamp/ObjcRuntime'
        ss.dependency 'FishLamp/ObjectDatabase'
        ss.dependency 'FishLamp/Core'
        ss.dependency 'FishLamp/Services'
        ss.dependency 'FishLamp/Storage'
        ss.dependency 'FishLamp/Testables'
        ss.dependency 'FishLamp/Timer'
        ss.dependency 'FishLamp/UserPrefs'

        ss.dependency 'FishLamp/TestablesOSX'
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
