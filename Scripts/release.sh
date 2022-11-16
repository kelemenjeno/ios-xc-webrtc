#!/bin/bash

#Use: release.sh <version>
repo="https://github.com/TechTeamer/ios-xc-webrtc.git"

#---- Setup -----
function setup {
    scriptPath="$( cd "$(dirname "$0")" ; pwd -P )"
    rootPath=$(echo $(dirname $scriptPath))
    workPath=$scriptPath/tmp
    releasePath="${rootPath}/XCWebRTC/${version}"
    mkdir $workPath
    echo "RootPath: $rootPath"
    echo "ScriptPath: $scriptPath"
    echo "WorkPath: $workPath"
    cd $workPath
}

#---- Pull -----
function pull {
    cd $rootPath
    git pull
}

#---- Copy files -----
function copyFiles {
    mkdir $releasePath
    
    cd $workPath
    zip -r "WebRTC.xcframework.zip" "WebRTC.xcframework"
    mv WebRTC.xcframework.zip ${releasePath}
    
    releaseDate=$(date '+%Y-%m-%d %H:%M')
    #releaseDescription="### $version\nBuild date: $releaseDate"
    releaseDescription="### $version\nBuild date: $releaseDate\nChrome version: M103(Bitcode disabled)"
    sed -i "" "s/## Release/## Release\n\n$releaseDescription/" $rootPath/README.md
    
    rm -rf $rootPath/XCWebRTC.podspec
    
    sourceURL="https://github.com/TechTeamer/ios-xc-webrtc/raw/${version}/XCWebRTC/WebRTC.xcframework.zip"
    sourceChecksum=$(swift package compute-checksum "${releasePath}/WebRTC.xcframework.zip")
    sed "s|X.Y.Z|${version}|g; s|SOURCE_URL|${sourceURL}|g" <$scriptPath/templates/XCWebRTC.zip.podspec >$releasePath/XCWebRTC.podspec
    sed "s|SOURCE_CHECKSUM|${sourceChecksum}|g; s|SOURCE_URL|${sourceURL}|g" <$scriptPath/templates/Package.zip.swift >$rootPath/Package.swift
}

#---- Build -----
function build {
    $scriptPath/build.sh $version
}

#---- Clean -----
function clean {
    rm -rf $workPath
}

#---- Push the changes into the repository -----
function push {
    cd $rootPath
    git lfs untrack "*.zip"
    git lfs untrack "WebRTC.xcframework/ios-arm64/WebRTC.framework/WebRTC"
    rm -rf .gitattributes
    rm -rf "XCWebRTC/1.0.0"
    rm -rf "XCWebRTC/1.0.1"
    
    #remove the last tag if exists
    tags="$(git tag --list)"

    if [ $(git tag -l "${version}") ]; then
        git tag -d ${version}
        git push --delete origin ${version}
    fi
    
    #add
    git add .
    
    #commit & push
    commitMSG="New release: v.${version}"
    commits="$(git reflog)"

    if [[ $commits == *"${commitMSG}"* ]]; then
        git tag ${version}
        git push --force origin master
    else
        if [ -n "$(git status --porcelain)" ]; then
            git commit -m "${commitMSG}"
        fi
    
        git tag ${version}
        git push origin master
    fi
    
    #push tags
    git push --tags origin
}

function run {
    setup
    #pull
    #build
    copyFiles
    clean
    push
}

if [[ $# -eq 0 ]] ; then
    echo 'Missing version, call it with param like: release.sh 1.0.0'
else
    version=$1
    run
fi
