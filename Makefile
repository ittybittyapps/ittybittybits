WORKSPACE=IttyBittyBits.xcworkspace
SCHEME=IttyBittyBitsTests
CONFIG=Debug
SDK=iphonesimulator4.3 
KEYCHAIN_NAME=Xcode
KEYCHAIN_PASSWORD=keychain-password-placeholder
KEYCHAIN_DEFAULT=$(shell security default-keychain)

.PHONY: clean test

clean:
	GHUNIT_CLI=1 xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration $(CONFIG) -sdk $(SDK) clean

build:
	GHUNIT_CLI=1 xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration $(CONFIG) -sdk $(SDK) build

test: unlock-keychain build restore-default-keychain

unlock-keychain:
	security unlock-keychain -p "$(KEYCHAIN_PASSWORD)" "$(HOME)/Library/Keychains/$(KEYCHAIN_NAME).keychain"
	security default-keychain -s "$(HOME)/Library/Keychains/$(KEYCHAIN_NAME).keychain"

restore-default-keychain:
	security default-keychain -s $(KEYCHAIN_DEFAULT)
