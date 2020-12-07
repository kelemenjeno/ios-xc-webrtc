Pod::Spec.new do |s|  
s.name              = 'XCWebRTC'
s.version           = '1.0.0'
s.summary           = 'XCWebRTC Framework'
s.homepage          = 'https://facekom.net'

s.author            = { 'Name' => 'info@techteamer.com' }
s.license           = { :type => 'MIT', :file => 'LICENSE' }

s.source            = { :http => 'https://github.com/TechTeamer/ios-xc-webrtc/raw/master/XCWebRTC/1.0.0/WebRTC.xcframework.zip' }

s.swift_version = '5.2'
s.platforms = { :ios => "11.0", :osx => "10.5" }
s.pod_target_xcconfig = { "SWIFT_VERSION" => "5.2" }

s.vendored_frameworks = 'WebRTC.xcframework'
end  
