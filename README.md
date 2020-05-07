# ORBIS LIB GENERATOR

[![Actions Status](https://github.com/orbisdev/orbis-libs-gen/workflows/CI/badge.svg)](https://github.com/orbisdev/orbis-libs-gen/actions)

## Description

This is a super fast orbis libs generator, is done in pure `SWIFT`, and as you can guess being opensource it can be executed everywhere.

More info here: https://swift.org/getting-started/

## How it works?
Is not magic, just take a look to the code, and to the [github workflow](https://github.com/orbisdev/orbis-libs-gen/blob/master/.github/workflows/compilation.yml)

## Execution

You require to have previously downloaded the `sprx.json` files under the `ps4libdoc` folder, and finally just run 
```
swift run orbis-parser
```

All the assembly references will be generated in the `output` folder.

## Thanks to OrbisDev group