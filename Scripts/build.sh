#!/bin/bash

#Use: build.sh <version>

#---- Setup -----
function setup {
    scriptPath="$( cd "$(dirname "$0")" ; pwd -P )"
    rootPath=$(echo $(dirname $scriptPath))
    workPath=$scriptPath/tmp
    #rm -rf $workPath
    #mkdir $workPath
    echo "RootPath: $rootPath"
    echo "ScriptPath: $scriptPath"
    echo "WorkPath: $workPath"
    cd $workPath

    export PATH=$PATH:$workPath/depot_tools
}


#---- Clean -----
function clean {
    cd $workPath
    rm -rf depot_tools
}

#---- Cloning -----
function clone {
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

    cd "$workPath/depot_tools"
    #fetch --nohooks webrtc_ios
    fetch webrtc_ios
    
    git branch -r
    git checkout origin/master
    
    gclient sync
}

#---- Generate iOS and macOS targets -----
function generateTargets {

    cd "$workPath/depot_tools/src"
    
    #Find the commits here: https://webrtc.googlesource.com/src
    git checkout '0d863f72a8c747c1b41f2798e5201e1abcdaec2b'
    #'1620db743e12241e5989f6ca69fde622e67b0d18'
    gclient sync
    #rm -rf ../out/ios_arm64
    
    gn gen ../out/ios_arm64 --args='target_os="ios" target_cpu="arm64" is_component_build=false use_xcode_clang=true is_debug=false  ios_deployment_target="10.0" rtc_libvpx_build_vp9=false use_goma=false ios_enable_code_signing=false enable_stripping=true rtc_enable_protobuf=false enable_ios_bitcode=true treat_warnings_as_errors=false'

    gn gen ../out/ios_simulator_x64 --args='target_os="ios" target_cpu="x64" target_environment="simulator" is_component_build=false use_xcode_clang=true is_debug=true ios_deployment_target="10.0" rtc_libvpx_build_vp9=false use_goma=false ios_enable_code_signing=false enable_stripping=true rtc_enable_protobuf=false enable_ios_bitcode=true treat_warnings_as_errors=false'
    
    gn gen ../out/ios_simulator_arm64 --args='target_os="ios" target_cpu="arm64" target_environment="simulator" is_component_build=false use_xcode_clang=true is_debug=true ios_deployment_target="10.0" rtc_libvpx_build_vp9=false use_goma=false ios_enable_code_signing=false enable_stripping=true rtc_enable_protobuf=false enable_ios_bitcode=true treat_warnings_as_errors=false'
    
    gn gen ../out/macos_x64 --args='target_os="mac" target_cpu="x64" target_environment="catalyst" is_component_build=false is_debug=false  rtc_libvpx_build_vp9=false enable_stripping=true rtc_enable_protobuf=false'
    
    gn gen ../out/macos_arm64 --args='target_os="mac" target_cpu="arm64" target_environment="catalyst" is_component_build=false is_debug=false  rtc_libvpx_build_vp9=false enable_stripping=true rtc_enable_protobuf=false'
    
    #gn gen ../out/Xcode --args='target_os="ios"' --ide=xcode
}
#616,4MB
#---- Build the targets -----
function buildTargets {
    cd "$workPath/depot_tools"
    ninja -C out/ios_arm64 sdk:framework_objc
    ninja -C out/ios_simulator_x64 sdk:framework_objc
    ninja -C out/ios_simulator_arm64 sdk:framework_objc
    ninja -C out/macos_x64 sdk:mac_framework_objc
    ninja -C out/macos_arm64 sdk:mac_framework_objc
}

#---- Merge simulator builds -----
function mergeSimulatorBuilds {
    UNIVERSAL_LIBRARY_DIR="$workPath/depot_tools/out/ios-arm64_x86_64/WebRTC.framework"
    rm -rf "$workPath/depot_tools/out/ios-arm64_x86_64"
    mkdir "$workPath/depot_tools/out/ios-arm64_x86_64"
    mkdir "${UNIVERSAL_LIBRARY_DIR}"

    FRAMEWORK_NAME="WebRTC"
    SIMULATOR_LIBRARY_PATH="$workPath/depot_tools/out/ios_simulator_arm64/WebRTC.framework"
    DEVICE_LIBRARY_PATH="$workPath/depot_tools/out/ios_simulator_x64/WebRTC.framework"

    echo "Make an universal binary"
    lipo "${SIMULATOR_LIBRARY_PATH}/${FRAMEWORK_NAME}" "${DEVICE_LIBRARY_PATH}/${FRAMEWORK_NAME}" -create -output "${UNIVERSAL_LIBRARY_DIR}/${FRAMEWORK_NAME}" | echo

    cp -r "${DEVICE_LIBRARY_PATH}/Headers" "${UNIVERSAL_LIBRARY_DIR}"
    cp "${DEVICE_LIBRARY_PATH}/Info.plist" "${UNIVERSAL_LIBRARY_DIR}"
    cp -r "${DEVICE_LIBRARY_PATH}/Modules" "${UNIVERSAL_LIBRARY_DIR}"
}

#---- Merge mac builds -----
function mergeMacOSBuilds {
    MACOS_UNIVERSAL_LIBRARY_DIR="$workPath/depot_tools/out/macOS-arm64_x86_64/WebRTC.framework"
    rm -rf "$workPath/depot_tools/out/macos-arm64_x86_64"
    mkdir "$workPath/depot_tools/out/macos-arm64_x86_64"
    mkdir "${UNIVERSAL_LIBRARY_DIR}"

    FRAMEWORK_NAME="WebRTC"
    MACOS_X64_LIBRARY_PATH="$workPath/depot_tools/out/macos_x64/WebRTC.framework"
    MACOS_ARM64_LIBRARY_PATH="$workPath/depot_tools/out/macos_arm64/WebRTC.framework"

    cp -R "${MACOS_ARM64_LIBRARY_PATH}" "${MACOS_UNIVERSAL_LIBRARY_DIR}"

    rm "${MACOS_UNIVERSAL_LIBRARY_DIR}/Versions/A/WebRTC"
    
    echo "Make an universal binary"
    lipo "${MACOS_X64_LIBRARY_PATH}/Versions/A/${FRAMEWORK_NAME}"  "${MACOS_ARM64_LIBRARY_PATH}/Versions/A//${FRAMEWORK_NAME}" -create -output "${MACOS_UNIVERSAL_LIBRARY_DIR}/Versions/A/${FRAMEWORK_NAME}" | echo
}

#---- Generate XCFramework -----
function makeXCFramework {
    cd "$workPath/depot_tools"
    
    xcodebuild -create-xcframework \
    -framework out/ios_arm64/WebRTC.framework \
    -framework out/ios-arm64_x86_64/WebRTC.framework \
    -framework out/macos-arm64_x86_64/WebRTC.framework \
    -output out/WebRTC.xcframework
}

#---- Copy files -----
function exportFramework {
    rm -rf $workPath/WebRTC.xcframework
    mv "$workPath/depot_tools/out/WebRTC.xcframework" "$workPath"
    #\cp "${scriptPath}/templates/Info.plist" "${workPath}/WebRTC.xcframework"
}


function run {
    setup
    #clean
    #clone
    generateTargets
    buildTargets
    mergeMacOSBuilds
    mergeSimulatorBuilds
    makeXCFramework
    exportFramework
    #clean
}

if [[ $# -eq 0 ]] ; then
    echo 'Missing version, call it with param like: build.sh 1.0.0'
else
    version=$1
    run
fi
