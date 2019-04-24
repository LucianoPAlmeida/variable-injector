CURRENT_DIR="$PWD"
cd /tmp
curl -OL https://github.com/LucianoPAlmeida/variable-injector/releases/download/0.2.1/x86_64-apple-macosx.zip
unzip x86_64-apple-macosx.zip
cp -f ./x86_64-apple-macosx/release/variable-injector /usr/local/bin/variable-injector

rm ./x86_64-apple-macosx.zip
rm -rf ./x86_64-apple-macosx
rm -rf ./__MACOSX/

cd "$CURRENT_DIR"
