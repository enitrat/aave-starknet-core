# Aave Starknet Core

## Installation

### Environment

Make sure that you have python3.9 available on your computer. We recommand working inside a virtual environment.
To create and enter a virtual environment for cairo development, type:

```bash
python3.9 -m venv ~/cairo_venv
source ~/cairo_venv/bin/activate
```

You'll need to install `cairo-lang` and `cairo-toolkit` inside this virtual environment.

```bash
pip install cairo-lang cairo-toolkit
```

You will also need to install protostar

```bash
curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash
```

### Pre-commit

To enable a pre-commit hook based on `protostar format`, and `cairo-toolkit`, make sure you run the following once:

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
