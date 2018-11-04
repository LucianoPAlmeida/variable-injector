# [WIP] Variable Injector

This project is a work in progress not usable yet.

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/MIT)
[![Travis](https://img.shields.io/travis/LucianoPAlmeida/variable-injector.svg)](https://travis-ci.org/LucianoPAlmeida/variable-injector)

Variable injector is a very simple project with the goal of inject CI pipelines envirionment variables values into Swift code static values before compilation and Continuous deployment to a specific envirionment(Development, Testing or Production) where we can define the values injected for each build and deployment e.g. a API url that the App uses and is diferent for each envirionment. Also it allows us to not expose our production keys and values in statically in our code.

## Installation

### Manually Download




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
If envirionment variables with those the name, as in the example you have the `SERVICE_PROD_KEY` and `OTHER_PROD_KEY` defined on the build machine for this pipeline. The injector you replace the string literal with the envirionment variable value. 

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

After that we can just proceed with the build, archive and other steps of our CI/CD pipeline. 

## Licence
Variable Injector is released under the [MIT License](https://opensource.org/licenses/MIT).
