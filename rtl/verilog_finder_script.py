import os

def find_verilog_files(repo_path, output_file="assignments.tcl"):
    """
    Recursively searches for Verilog (.v) and SystemVerilog (.sv) files within a repository
    and generates a TCL script with 'set_global_assignment' commands.

    Args:
        repo_path (str): The path to the repository (the script will be run inside the rtl folder).
        output_file (str, optional): The name of the output TCL file. Defaults to "assignments.tcl".
    """
    # Ensure the output directory exists
    output_dir = os.path.dirname(output_file)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(output_file, "w") as f:
        for root, _, files in os.walk(repo_path):
            for file in files:
                if file.endswith(".sv"):
                    # Construct the file path relative to the 'rtl' folder.
                    # No need to join with 'rtl' because the script is run *inside* it.
                    file_path = os.path.join(root, file)
                    #  Normalize the path to use forward slashes
                    file_path = file_path.replace("\\", "/")
                    f.write(f'set_global_assignment -name SYSTEMVERILOG_FILE "{file_path}"\n')
                elif file.endswith(".v"):
                    # Construct the file path relative to the 'rtl' folder.
                    #  No need to join with 'rtl' because the script is run *inside* it.
                    file_path = os.path.join(root, file)
                    #  Normalize the path to use forward slashes
                    file_path = file_path.replace("\\", "/")
                    f.write(f'set_global_assignment -name VERILOG_FILE "{file_path}"\n')

    print(f"TCL script generated: {output_file}")


if __name__ == "__main__":
    # Get the current directory, which is assumed to be the 'rtl' directory.
    repo_path = "."  # The script is run inside the rtl folder
    output_file = "assignments.tcl"  # You can change the output file name if needed.
    find_verilog_files(repo_path, output_file)
