
BIN_DIR=/usr/local/bin
LIB_DIR=/usr/local/lib
SWIFT_PATH=$(shell dirname `xcrun --find swift`)
PLATFORM=$(shell uname -m)

build:
	swift build -c release --disable-sandbox

install: build
	install_name_tool -add_rpath $(LIB_DIR) .build/$(PLATFORM)-apple-macosx/release/variable-injector
	install ".build/$(PLATFORM)-apple-macosx/release/variable-injector" "$(BIN_DIR)"

uninstall:
	rm -rf "$(BIN_DIR)/variable-injector"

clean:
	rm -rf .build

release:
	swift build -c release --triple arm64-apple-macosx
	swift build -c release --triple x86_64-apple-macosx10.15
	rm -f .build/arm64-apple-macosx/build.db
	rm -f .build/x86_64-apple-macosx/build.db
	cd .build && zip -r ./arm64-apple-macosx.zip ./arm64-apple-macosx
	cd .build && zip -r ./x86_64-apple-macosx.zip ./x86_64-apple-macosx
.PHONY: build install uninstall clean release
