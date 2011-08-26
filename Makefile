XCODE_WORKSPACE ?= IttyBittyBits.xcworkspace
XCODE_SCHEME ?= IttyBittyBitsTests
CONFIG ?= Debug
SDK ?= iphonesimulator4.3 
KEYCHAIN_NAME ?= Xcode
KEYCHAIN_PASSWORD ?= keychain-password-placeholder
KEYCHAIN_DEFAULT := $(shell security default-keychain)

BUILD_DIR ?= ../build
BUILD_ROOT := $(BUILD_DIR)

OBJROOT := $(BUILD_DIR)/Intermediates
SYMROOT := $(BUILD_DIR)/Products
DSTROOT := $(BUILD_DIR)/Distributables

TEMP_ROOT := $(BUILD_DIR)/Temp
CACHE_ROOT := $(BUILD_DIR)/Cache
SHARED_PRECOMPS_DIR := $(BUILD_DIR)/PrecompiledHeaders

BUILD_OPTS := BUILD_DIR=$(BUILD_DIR) BUILD_ROOT=$(BUILD_ROOT) OBJROOT=$(OBJROOT) SYMROOT=$(SYMROOT) DSTROOT=$(DSTROOT) CACHE_ROOT=$(CACHE_ROOT) SHARED_PRECOMPS_DIR=$(SHARED_PRECOMPS_DIR)

.PHONY: clean build test

default:
	@echo "Available Targets: clean, build, test"

clean:
	xcodebuild -workspace $(XCODE_WORKSPACE) -scheme $(XCODE_SCHEME) -configuration $(CONFIG) -sdk $(SDK) clean $(BUILD_OPTS)
	rm -rf $(BUILD_DIR) 

build:
	GHUNIT_CLI=1 xcodebuild -workspace $(XCODE_WORKSPACE) -scheme $(XCODE_SCHEME) -configuration $(CONFIG) -sdk $(SDK) build $(BUILD_OPTS)

test: unlock-keychain build restore-default-keychain

unlock-keychain:
	security unlock-keychain -p "$(KEYCHAIN_PASSWORD)" "$(HOME)/Library/Keychains/$(KEYCHAIN_NAME).keychain"
	security default-keychain -d user -s "$(HOME)/Library/Keychains/$(KEYCHAIN_NAME).keychain"

restore-default-keychain:
	security default-keychain -d user -s $(KEYCHAIN_DEFAULT)
