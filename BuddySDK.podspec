Pod::Spec.new do |s|
  s.name                = 'BuddySDK'
  s.version             = '1.9.4'
  s.license             = ''
  s.summary             = 'iOS SDK for the Buddy Platform.'
  s.homepage            = 'http://www.buddy.com'
  s.authors             = { 'Erik Kerber' => 'erik@buddy.com' }
  s.source              = { :git => 'https://github.com/BuddyPlatform/Buddy-iOS-SDK-V2.git', :tag => 'v1.9.4' }
  s.source_files        = 'Src/Lib/BuddySDK/*.{h,m}', 'Src/Lib/BuddySDK/{BaseObjects,BPObjects,BPCollections,Categories,Service}/*.{h,m}', 'Src/Lib/BuddySDK/Vendor/{JAGPropertyConverter,OpenUUID,ObjectiveSugar,AFNetworking,LocationTracking}/*.{h,m}', 'Src/Lib/BuddySDK/Vendor/OpenUUID/*.{h,m}'
  
  s.public_header_files = 'Src/Lib/BuddySDK/**/*.h', 'Src/Lib/BuddySDK/BPCollections/*.{h}', 'Src/Lib/BuddySDK/Service/*.{h}', 'Src/Lib/BuddySDK/Categories/*.{h}', 'Src/Lib/BuddySDK/Vendor/JAGPropertyConverter/*.h'
  s.platform            = :ios, '7.0'
  s.frameworks          = 'CoreLocation'
  s.requires_arc        = true
  s.prefix_header_file  = 'Src/Lib/BuddySDK/BuddySDK-Prefix.pch'
  s.preserve_paths      = 'Src/Lib/BuddySDK/Vendor/CrashReporter.framework'
  s.vendored_frameworks = 'Src/Lib/BuddySDK/Vendor/CrashReporter.framework'
  #s.library             = 'CrashReporter'
#  s.xcconfig            = { 'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/Src/Lib/BuddySDK/Vendor' }    
# s.dependency            'PLCrashReporter', '~> 1.2-rc4'
end