# SOCA Internal Modules

This directory contains minimal internal implementations of external dependencies to reduce the reliance on large submodules.

## Contents

- `mom6_minimal/`: Minimal MOM6 modules required for SOCA geometry and domain initialization
- `icepack_minimal/`: Minimal IcePack modules required for sea ice analysis postprocessing

## Purpose

These modules contain only the specific functions and types that SOCA actually uses, extracted from the full MOM6 and IcePack libraries. This reduces build complexity and eliminates the need for git submodules.

## Original Sources

- MOM6: https://github.com/NOAA-EMC/MOM6
- IcePack: https://github.com/CICE-Consortium/Icepack.git

## License

These modules maintain the original licenses from their respective source projects.