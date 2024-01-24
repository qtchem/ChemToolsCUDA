
[![Python Version](https://img.shields.io/badge/python-3.7%2B-blue.svg)](https://docs.python.org/3/whatsnew/3.7.html)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![GitHub contributors](https://img.shields.io/github/contributors/qtchem/gbasis_cuda.svg)](https://github.com/qtchem/gbasis_cuda/graphs/contributors)

## About
GBasisCuda is a free, and open-source C++/CUDA and Python library for computing various quantities efficiently using NVIDIA GPU's 
in quantum chemistry related to the electron density. It is highly-optimized code built around the GPU
and compiler-specific optimization.

It depends on reading Gaussian format check-point files (.fchk) using IOData and supports up-to g-type orbitals. 
The user can use [IOData](https://www.github.com/theochem/iodata) to convert various file-types to fchk format.

To report any issues or ask questions, either [open an issue](
https://github.com/qtchem/gbasis_cuda/issues/new) or email [qcdevs@gmail.com]().

### Features
GbasisCuda can compute the following quantites over the GPU for s,p,d,f Gaussian orbitals over any size of grid-points:

- Molecular orbitals
- Electron density
- Gradient of electron density
- Laplacian of electron density
- Positive definite kinetic energy density
- General kinetic energy density
- Electrostatic potential 

## Requirements

- CMake>=3.24: (https://cmake.org/) 
- Eigen>=3: (https://eigen.tuxfamily.org/index.php?title=Main_Page)
- CUDA/NVCC/CUDA-TOOLKIT: (https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
- Python>=3.7: (http://www.python.org/)
- Pybind11 on python: (https://github.com/pybind/pybind11)
- IOData on python: (https://github.com/theochem/iodata)

For testing the following are required to be installed on the Python system:
- GBasis: (https://github.com/theochem/gbasis)
- Chemtools: (https://github.com/theochem/chemtools)

## Installation

```bash
git clone https://github.com/qtchem/gbasis_cuda

# Get the dependencies in ./libs/ folder
git submodule update --init --recursive
```

In-order to install it need to use:
```bash
pip install -v . 
```
The -v is needed in order to debug by looking at the output of CMake.
If CMake can't find NVCC or C++ compiler, then `CMakeLists.txt` needs to be modified
to find them.

In order to test do
```bash
pytest ./tests/*.py -v 
```

In order to build without the python bindings, useful for debugging purposes,
```bash
cmake -S . -B ./out/build/  
make -C ./out/build/
./out/build/tests/tests  # Run the C++/CUDA tests
```

### Building with CMake

The following can help with compiling this package

1. If CUBLAS, CURAND are not found, add the following flag to the correct path
```bash 
cmake -S . -B ./out/build/ -DCUDAToolkit_ROOT=/some/path 
```
2. If NVCC compiler is not found, add the following flag to correct path
```bash
cmake -S . -B ./out/build/ -DCUDACXX=/some/path/bin/nvcc
```
3. If Eigen is not found, add the following flag to the path containing the Eigen3*.cmake files
```bash
cmake -S . -B ./out/build/ -DEigen3_DIR=/some/path/share/eigen3/cmake/
```
4. If you need to set the correct GPU architecture (e.g. compute capabiltiy 6.0), then change the following line in `CMakeLists.txt`
```bash
#Change set_property(TARGET gbasis_cuda_lib PROPERTY CUDA_ARCHITECTURES native) to
set_property(TARGET gbasis_cuda_lib PROPERTY CUDA_ARCHITECTURES 60)
```
Not setting the correct GPU architecture will result in an error using the constant memory.

## How To Use
```python
import gbasis_cuda

mol = gbasis_cuda.Molecule( FCHK FILE PATH HERE)
mol.basis_set_to_constant_memory(False)

density =  mol.compute_electron_density_on_cubic_grid( CUBIC INFO HERE)
density = mol.compute_electron_density( POINTS )
gradient = mol.compute_electron_density_gradient( POINTS )
laplacian = mol.compute_laplacian_electron_density( POINTS )
kinetic_dens = mol.compute_positive_definite_kinetic_energy_density( POINTS )
general_kin = mol.compute_general_kinetic_energy_density(POINTS, alpha)

# Parameter True needs to be set to use ESP, this will hold true for any integrals
mol.basis_set_to_constant_memory(True)
esp = mol.compute_electrostatic_potential( POINTS )
```
