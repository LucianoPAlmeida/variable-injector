CURRENT_DIR="$PWD"
cd /tmp

# Clone, build from source and install
git clone https://github.com/LucianoPAlmeida/variable-injector.git
cd variable-injector

if [[ ! $TAG ]]; then 
    TAG=$(git describe --tags --abbrev=0)
fi;

git checkout $TAG

make install

# Clean all
cd .. 
rm -rf variable-injector

cd "$CURRENT_DIR"
