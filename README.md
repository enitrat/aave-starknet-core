# Aave Starknet Core

## Installation

To enable pre-commit hook based on `protostar format`, make sure you run the following once:

```bash
./pre-commit-install.sh
```

To install dependencies:

```bash
 protostar install
```

## Building and running tests

```bash
 protostar build
```

To run the tests:

```bash
 protostar test
```

## Deploying on starknet-devnet

While running [starknet-devnet](https://github.com/Shard-Labs/starknet-devnet) with default parameters:

```bash
 # Example with inputs:
 protostar -p devnet deploy ./build/pool.json --inputs "0x69a529e27336e28702b44c7e4143f64969681133ba9c4bd4a88c0ac7326288b"
```
