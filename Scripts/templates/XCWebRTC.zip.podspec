Pod::Spec.new do |s|  
s.name              = 'XCWebRTC'
s.version           = 'X.Y.Z'
s.summary           = 'XCWebRTC Framework'
s.homepage          = 'https://facekom.net'

s.author            = { 'Name' => 'info@techteamer.com' }
s.license           = { :type => 'MIT', :file => 'LICENSE' }

s.source            = { :http => 'SOURCE_URL' }

s.swift_version = '5.2'
s.platforms = { :ios => "11.0", :osx => "10.5" }
s.pod_target_xcconfig = { "SWIFT_VERSION" => "5.2" }

s.vendored_frameworks = 'WebRTC.xcframework'
end  
