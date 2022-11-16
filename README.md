# XCWebRTC
![Platform](https://img.shields.io/badge/Platform-iOS%20&%20macOS-orange.svg)
![Bitcode compatible](https://img.shields.io/badge/Bitcode-compatible-green.svg)
![Apple Silicon compatible](https://img.shields.io/badge/Apple%20Silicon-compatible-green.svg)
![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-green.svg)
![SPM compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-green.svg)<br/>
![Catalyst compatible](https://img.shields.io/badge/Catalyst-incompatible-red.svg)
[![Carthage incompatible](https://img.shields.io/badge/Carthage-incompatible-red.svg?style=flat)](https://github.com/Carthage/Carthage)


## Release

### 1.0.0
Build date: 2020-11-30 16:48<br/>
Commit: '0d863f72a8c747c1b41f2798e5201e1abcdaec2b'

## Installation
### Swift Package Manager
In your Xcode project go to: File -> Swift Packages -> Add Package Dependency<br/>
https://github.com/TechTeamer/ios-xc-webrtc.git


### Cocoapods
Just copy into your podfile, looks like this.<br/>

<br/>------------------------ Podfile ------------------------

source 'https://github.com/CocoaPods/Specs.git'<br/>
source 'https://github.com/TechTeamer/ios-xc-webrtc.git'

  use_frameworks!<br/>
  target 'YourApp' do<br/>
    pod 'XCWebRTC'<br/>
  end
  
<br/>---------------------------------------------------------

run:<br/>
pod repo update<br/>
pod install<br/>

## Description
This is a new generation xcframework is built for Apple machines including iOS/iPadOS/macOS & Silicon processors.
Supports bitcode!

You can find the release commits here:
https://webrtc.googlesource.com/src

You can find the official source here:
https://chromium.googlesource.com/chromium/tools/depot_tools/+/refs/heads/master

Sorry for the Release structure, but the GIT-LFS inside the Xcode 12.2 is NOT supported yet. 🙁

