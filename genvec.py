import re

def separator(msg):
    return "\n; " + "-"*10 + f" {msg} " + "-"*10 + "\n" 

def parse_verilog_line(verilog_line, time_factor=1):
  var_dict = {}
  try:
    verilog_line = verilog_line.strip().split("//")[0]
    if verilog_line == "": return var_dict, 0

    # if first charcter is #, then it's a time step line
    if verilog_line.startswith("#"):
      time_increment = int(verilog_line.replace("#", "").split(";")[0])
      # print(f"Time increment: {time_increment}")
      return var_dict, time_increment * time_factor

    verilog_line = verilog_line.strip()
    parts = re.split(r"=|'b", verilog_line)
    # print(parts)

    if len(parts) != 3: 
      print(f"[WARNING] Skipped line: '{verilog_line}'. Not applicable for vector file.")
      return var_dict, 0
    
    var_name = parts[0].replace(" ", "")
    var_bits = parts[1].replace(" ", "")
    var_value = parts[2].strip(";")

    var_dict[var_name] = {'bits': int(var_bits), 'value': var_value}

    return var_dict, 0
  except Exception as e:
    print(f"[WARNING] Skipped line: '{verilog_line}'. Runtime error: {e}")
    return var_dict, 0
  
def generate_header(state_dict):
    radix_parts = []
    vname_parts = []
    io_parts = []
    header = []

    for name, info in state_dict.items():
        bits = info['bits']
        
        # 1. Handle Radix & IO
        if bits == 1:
            r_str = "1"
        else:
            # Assuming bits are multiples of 4 for the '4' radix
            r_str = "4" * (bits // 4)
        
        radix_parts.append(r_str)
        io_parts.append("i" * len(r_str))
        
        # 2. Handle Vname
        header.append(name)
        if bits > 1:
            vname_parts.append(f"{name}<[{bits-1}:0]>")
        else:
            vname_parts.append(name)

    # Output formatting
    output = ""
    output += separator("signal definitions")
    output += f"radix {' '.join(radix_parts)}\n"
    output += f"vname {' '.join(vname_parts)}\n"
    output += f"io {' '.join(io_parts)}\n"

    output += separator("timing / electrical settings")
    output += (
        "tunit 1ps\n"
        "trise 10\n"
        "tfall 10\n"
        "vih 1.2\n"
        "vil 0.0\n"
        "voh 1.1\n"
        "vol 0.1\n"
    )

    output += separator("vector data")
    output += f"; {' '.join(header)}"

    return output

def bin_to_hex(bin_str, bits):
    # Calculate how many hex characters are needed (4 bits per hex digit)
    hex_width = bits // 4 
    
    # Convert binary string to integer, then to hex string
    # '0>04x' means: pad with zeros, right-aligned, 4 chars wide, lowercase hex
    hex_val = f"{int(bin_str, 2):0>{hex_width}x}"
    
    return hex_val

def generate_vector_line(state_dict, time):
    vector_parts = [time]

    for variable in state_dict.values():
        if variable['bits'] == 1:
            value = variable['value']
        else:
            # Convert binary to hex representation
            value = bin_to_hex(variable['value'], variable['bits'])
        vector_parts.append(value)
    
    # Output the vector line as string
    vector_string = '    '.join(map(str, vector_parts))
    return vector_string

def generate_vec_file(input_file_path, output_file_path):
    state = {}
    time = 0
    with open(input_file_path, "r") as input_file:
        with open(output_file_path, "w") as output_file:
            for line in input_file:
                var_dict, increment = parse_verilog_line(line, time_factor=1000)
                
                for key in var_dict.keys():
                    state[key] = var_dict[key]

                if increment > 0:
                    # print(f"Time: {time}, {state}")
                    if time == 0:
                        output_file.write(generate_header(state) + "\n")
                    time += increment
                    # Generate vector line
                    output_file.write(generate_vector_line(state, time) + "\n")

if __name__ == "__main__":
    # accept input and output file paths from command line arguments
    import sys
    if len(sys.argv) < 2:
        print("Usage: python genvec.py <input_verilog_file> optional:<output_vector_file>")
        sys.exit(1)
    
    input_file_path = sys.argv[1]
    output_file_path = input_file_path.split(".")[0]
    output_file_path = output_file_path + ".vec" if len(sys.argv) == 2 else sys.argv[2]
    generate_vec_file(input_file_path, output_file_path)
    print(f"Vector file successfully generated: {output_file_path}")