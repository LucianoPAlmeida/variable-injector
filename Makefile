usr_local ?= /usr/local

bindir = $(usr_local)/bin
libdir = $(usr_local)/libdir

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/variable-injector" "$(bindir)"
	install ".build/release/libSwiftSyntax.dylib" "$(libdir)"
	install_name_tool -change \
		".build/x86_64-apple-macosx10.10/release/libSwiftSyntax.dylib" \
		"$(libdir)/libSwiftSyntax.dylib" \
		"$(bindir)/variable-injector"

uninstall:
	rm -rf "$(bindir)/variable-injector"
	rm -rf "$(libdir)/libSwiftSyntax.dylib"

clean:
	rm -rf .build

.PHONY: build install uninstall clean