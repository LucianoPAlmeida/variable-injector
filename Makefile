
BIN_PATH=/usr/local/bin
LIB_PATH=/usr/local/lib
SWIFT_PATH=$(shell dirname `xcrun --find swift`)
PLATFORM=$(shell uname -m)

build:
	swift build -c release --disable-sandbox

install: build
	sudo cp "$(SWIFT_PATH)/../lib/swift/macosx/lib_InternalSwiftSyntaxParser.dylib" "$(LIB_PATH)/"
	install_name_tool -add_rpath $(LIB_PATH) .build/arm64-apple-macosx/release/variable-injector
	install ".build/$(PLATFORM)-apple-macosx/release/variable-injector" "$(BIN_PATH)"

uninstall:
	rm -rf "$(BIN_PATH)/variable-injector"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
