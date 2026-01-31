# Stimulus Designer

A Python tool that generates Cadence ADE stimulus files (`.vec`) from Verilog files (`.vh`).

## Overview

This tool automates the creation of stimulus vector files for use with Cadence ADE (Analog Design Environment) by parsing Verilog files and generating the corresponding vector format.

## Usage

```bash
python genvec.py <input_verilog_file> [output_vector_file]
```

### Arguments

- `<input_verilog_file>` **(required)**: Path to the input Verilog file (`.vh`)
- `[output_vector_file]` **(optional)**: Path for the output vector file (`.vec`). If not specified, the output file will use the same name as the input file with a `.vec` extension.

### Examples

```bash
# Generate vector file with default naming
python genvec.py stimulus.vh

# Specify custom output file
python genvec.py stimulus.vh my_vectors.vec
```

## Output

The tool generates a `.vec` file compatible with Cadence ADE for simulation stimulus definition.
