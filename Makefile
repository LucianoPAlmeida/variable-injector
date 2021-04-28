
BIN_DIR=/usr/local/bin
LIB_DIR=/usr/local/lib
SWIFT_PATH=$(shell dirname `xcrun --find swift`)
PLATFORM=$(shell uname -m)

build:
	swift build -c release --disable-sandbox

install: build
	sudo cp "$(SWIFT_PATH)/../lib/swift/macosx/lib_InternalSwiftSyntaxParser.dylib" "$(LIB_DIR)/"
	install_name_tool -add_rpath $(LIB_DIR) .build/$(PLATFORM)-apple-macosx/release/variable-injector
	install ".build/$(PLATFORM)-apple-macosx/release/variable-injector" "$(BIN_DIR)"

uninstall:
	rm -rf "$(BIN_DIR)/variable-injector"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
