# Swift Variable Injector

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/MIT)
[![Travis](https://img.shields.io/travis/LucianoPAlmeida/variable-injector.svg)](https://travis-ci.org/LucianoPAlmeida/variable-injector)
[![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-10.0-blue.svg)](https://developer.apple.com/xcode)
[![SPM](https://img.shields.io/badge/SPM-orange.svg)](https://swift.org/package-manager/)

Variable injector is a very simple project with the goal of inject CI pipelines environment variables values into **Swift** code  static values before compilation and Continuous deployment to a specific environment(Development, Testing or Production) where we can define the values injected for each build and deployment e.g. an API URL that the App uses and is different for each environment. Also, it allows us to not expose our production keys and values in statically in our code.

The project uses [SwiftSyntax](https://github.com/apple/swift-syntax) to perform a reliable replace the static literal strings with the CI environment values. 

## Installation

### Manually Download
We can manually download the binary from the [releases](https://github.com/LucianoPAlmeida/variable-injector/releases) and export to the path on the CI pipeline

```sh
cd /tmp
curl -OL https://github.com/LucianoPAlmeida/variable-injector/releases/download/0.2.0/x86_64-apple-macosx10.10.zip
unzip x86_64-apple-macosx10.10.zip
cp -f x86_64-apple-macosx10.10/release/variable-injector /usr/local/bin/variable-injector
cp -f x86_64-apple-macosx10.10/release/libSwiftSyntax.dylib /usr/local/lib/libSwiftSyntax.dylib
```

Or to install the lastest version just run the [install-binary.sh](scripts/install-binary.sh)

With that installed and on our `bin` folder, now we can use it.


## Usage

You should have a class or struct with your envirionment variables declaration following the $(VAR_NAME) pattern.
Example:
```swift
   struct CI {
      static var serviceAPIKey: String = "$(SERVICE_PROD_KEY)"
      static var otherAPIKey: String = "$(OTHER_PROD_KEY)"
   }
```

With the envirionments static declarations matching the pattern

```sh
variable-injector --file ${SRCROOT}/Envirionment/CI.swift 

```
If environment variables with those names, as in the example you have the `SERVICE_PROD_KEY` and `OTHER_PROD_KEY` are defined on the build machine for this pipeline the injector you replace the string literal with the envirionment variable value.  

Example of the file after the substitution. 

```swift
   struct CI {
      static var serviceAPIKey: String = "h344hjk2h4j3h24jk32h43j2k4h32jk4hkj324h"
      static var otherAPIKey: String = "dsa76d7adas7d6as87d6as78d6aklre423s7d6as8d7s6"
   }
```

We can ignore patterns that match $(ENV_VAR) to avoid the replace. 

```sh
variable-injector --file ${SRCROOT}/Envirionment/CI.swift --ignore OTHER_PROD_KEY

```

And also, to see the logs of variables, values and source output you can use `--verbose` 

**IMPORTANT** 
The verbose mode you print the values of your environment variables on the logs. So you may be careful and use it only for debug porpuses.

```sh
variable-injector --file ${SRCROOT}/Envirionment/CI.swift --verbose

```

After that we can just proceed to the build, archive and other steps of our CI/CD pipeline. 

## Licence
Variable Injector is released under the [MIT License](https://opensource.org/licenses/MIT).
