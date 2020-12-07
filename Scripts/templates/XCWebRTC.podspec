Pod::Spec.new do |s|  
s.name              = 'XCWebRTC'
s.version           = 'X.Y.Z'
s.summary           = 'XCWebRTC Framework'
s.homepage          = 'https://facekom.net'

s.author            = { 'Name' => 'info@techteamer.com' }
s.license           = { :type => 'MIT', :file => 'LICENSE' }

s.source            = { :git => 'SOURCE_URL', :tag => s.version.to_s }

s.swift_version = '5.2'
s.platform          = :ios
s.ios.deployment_target = '11.0'
s.pod_target_xcconfig = { "SWIFT_VERSION" => "5.2" }

s.vendored_frameworks = 'WebRTC.xcframework'
end  
