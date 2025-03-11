# Cargo support

## Overview  

[detect_product_short] includes two Cargo detectors:

* **Cargo CLI Detector** 
* **Cargo Lockfile Detector**  

## Cargo CLI Detector  

Detector for Cargo projects, extracts **direct and transitive dependencies** using the `cargo tree` command.

**Requirements:**  
* Cargo version 1.44.0+ required to support `cargo tree`.  
* A `Cargo.toml` file must be present in the project.  
* A valid `cargo` executable must be available on the system.

**Behavior:**  
* Executes `cargo tree` to analyze dependencies.  
* Parses the output to construct a hierarchical **dependency graph**.  
* Falls back to the Cargo Lockfile Detector if `cargo tree` is unavailable.

To specify a custom Cargo executable path, use the `detect.cargo.path` property.  

## Cargo Lockfile Detector  

If `cargo tree` is unavailable, [detect_product_short] will default to the Cargo Lockfile Detector, which extracts dependencies by parsing the `Cargo.lock` file.

* If both `Cargo.toml` and `Cargo.lock` are present, the detector uses `Cargo.lock` for dependency information.  
* If `Cargo.lock` is missing, the detector prompts the user to generate it using `cargo generate-lockfile`.  
* Extracts the project’s name and version from `Cargo.toml`. If missing, it derives values from Git or the project directory.
