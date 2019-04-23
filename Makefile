usr_local ?= /usr/local

bindir = $(usr_local)/bin
libdir = $(usr_local)/lib

build:
	swift build -c release --disable-sandbox
install: build
	install ".build/x86_64-apple-macosx/release/variable-injector" "$(bindir)"
uninstall:
	rm -rf "$(bindir)/variable-injector"
	rm -rf "$(libdir)/libSwiftSyntax.dylib"
clean:
	rm -rf .build

.PHONY: build install uninstall clean
