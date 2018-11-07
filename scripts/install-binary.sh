CURRENT_DIR="$PWD"
cd /tmp
curl -OL https://github.com/LucianoPAlmeida/variable-injector/releases/download/0.2.0/x86_64-apple-macosx10.10.zip
unzip x86_64-apple-macosx10.10.zip
cp -f x86_64-apple-macosx10.10/release/variable-injector /usr/local/bin/variable-injector
cp -f x86_64-apple-macosx10.10/release/libSwiftSyntax.dylib /usr/local/lib/libSwiftSyntax.dylib

rm ./x86_64-apple-macosx10.10.zip
rm -rf ./x86_64-apple-macosx10.10
rm -rf ./__MACOSX/

cd "$CURRENT_DIR"
