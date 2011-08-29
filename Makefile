XCODE_WORKSPACE ?= IttyBittyBits.xcworkspace
XCODE_SCHEME ?= IttyBittyBitsTests
CONFIG ?= Debug
SDK ?= iphonesimulator4.3 
KEYCHAIN_PATH ?= "$(HOME)/Library/Keychains/Xcode.keychain"

BUILD_DIR ?= ../build

include lib/jenkins-xcode-support/project/make/Makefile.include
