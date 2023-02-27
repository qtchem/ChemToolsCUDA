#include "catch.hpp"

#include <random>
#include <algorithm>
#include <iterator>

#include <pybind11/embed.h>
#include <pybind11/numpy.h>

#include "../include/iodata.h"
#include "../include/utils.h"
#include "../include/cuda_utils.cuh"
#include "../include/basis_to_gpu.cuh"
#include "../include/evaluate_kinetic_dens.cuh"

namespace py = pybind11;
using namespace py::literals;


TEST_CASE( "Test Positive Definite Kinetic Energy Density Against gbasis", "[evaluate_posdef_kinetic_energy]" ) {
  //py::initialize_interpreter();  // Open up the python interpretor for this test.
  {  // Need this so that the python object doesn't outline the interpretor.
    // Get the IOdata object from the fchk file.
    std::string fchk_file = GENERATE(
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_01_H_N01_M2_ub3lyp_ccpvtz_g09.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_he.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_be.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_be_f_pure_orbital.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_kr.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_o.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_c_g_pure_orbital.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_mg.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/E948_rwB97XD_def2SVP.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/h2o.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/ch4.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/qm9_000092_HF_cc-pVDZ.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/qm9_000104_PBE1PBE_pcS-3.fchk"
    );
    std::cout << "FCHK FILE %s \n" << fchk_file << std::endl;
    gbasis::IOData iodata = gbasis::get_molecular_basis_from_fchk(fchk_file);

    // Gemerate random grid.
    int numb_pts = 10000;
    std::vector<double> points(3 * numb_pts);
    std::random_device rnd_device;
    std::mt19937  merseene_engine {rnd_device()};
    std::uniform_real_distribution<double> dist {-5, 5};
    auto gen = [&dist, &merseene_engine](){return dist(merseene_engine);};
    std::generate(points.begin(), points.end(), gen);

    // Calculate Kinetic Energy
    gbasis::add_mol_basis_to_constant_memory_array(iodata.GetOrbitalBasis(), false, false);
    std::vector<double> kinetic_dens_result = gbasis::evaluate_positive_definite_kinetic_density(
        iodata, points.data(), numb_pts
        );

    // COnvert them (with copy) to python objects so that they can be transfered.
    pybind11::array_t<double, pybind11::array::c_style | pybind11::array::forcecast>
        py_result = gbasis::as_pyarray_from_vector(kinetic_dens_result);
    pybind11::array_t<double, pybind11::array::c_style | pybind11::array::forcecast>
        py_points = gbasis::as_pyarray_from_vector(points);

    const int nbasis = iodata.GetOrbitalBasis().numb_basis_functions();

    auto locals = py::dict("points"_a = py_points,
                           "true_result"_a = py_result,
                           "fchk_path"_a = fchk_file,
                           "numb_pts"_a = numb_pts,
                           "nbasis"_a = nbasis);
    py::exec(R"(
import numpy as np
from gbasis.evals.density import evaluate_posdef_kinetic_energy_density
from iodata import load_one
from gbasis.wrappers import from_iodata

iodata = load_one(fchk_path)
basis, type = from_iodata(iodata)
rdm = (iodata.mo.coeffs * iodata.mo.occs).dot(iodata.mo.coeffs.T)
points = points.reshape((numb_pts, 3), order="F")
points = np.array(points, dtype=np.float64)

kin_dens = evaluate_posdef_kinetic_energy_density(rdm, basis, points, coord_type=type)
err = np.abs(kin_dens - true_result)
result = np.all(err < 1e-8)
print("Kinetic Density Mean, Max, STD Error ", np.mean(err), np.max(err), np.std(err))
assert result, "Kinetic Energy of Electron Density on GPU doesn't match gbasis."
    )", py::globals(), locals);
  } // Need this so that the python object doesn't outline the interpretor when we close it up.
}


TEST_CASE( "Test General Kinetic Energy Density Against gbasis", "[evaluate_general_kinetic_energy]" ) {
  //py::initialize_interpreter();  // Open up the python interpretor for this test.
  {  // Need this so that the python object doesn't outline the interpretor.
    // Get the IOdata object from the fchk file.
    std::string fchk_file = GENERATE(
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_01_H_N01_M2_ub3lyp_ccpvtz_g09.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_he.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_be.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_be_f_pure_orbital.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_kr.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_o.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_c_g_pure_orbital.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/atom_mg.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/E948_rwB97XD_def2SVP.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/h2o.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/ch4.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/qm9_000092_HF_cc-pVDZ.fchk",
        "/home/ali-tehrani/SoftwareProjects/spec_database/tests/data/qm9_000104_PBE1PBE_pcS-3.fchk"
    );
    std::cout << "FCHK FILE %s \n" << fchk_file << std::endl;
    gbasis::IOData iodata = gbasis::get_molecular_basis_from_fchk(fchk_file);

    // Gemerate random grid.
    int numb_pts = 10000;
    std::vector<double> points(3 * numb_pts);
    std::random_device rnd_device;
    std::mt19937  merseene_engine {rnd_device()};
    std::uniform_real_distribution<double> dist {-5, 5};
    auto gen = [&dist, &merseene_engine](){return dist(merseene_engine);};
    std::generate(points.begin(), points.end(), gen);

    // Calculate General Kinetic Energy at alpha = 0.5
    std::uniform_real_distribution<double> alpha_gen {-5, 5};
    double alpha = alpha_gen(merseene_engine);
    gbasis::add_mol_basis_to_constant_memory_array(iodata.GetOrbitalBasis(), false, false);
    std::vector<double> laplacian_result = gbasis::evaluate_general_kinetic_energy_density(
        iodata, alpha, points.data(), numb_pts
    );

    // COnvert them (with copy) to python objects so that they can be transfered.
    pybind11::array_t<double, pybind11::array::c_style | pybind11::array::forcecast>
        py_result = gbasis::as_pyarray_from_vector(laplacian_result);
    pybind11::array_t<double, pybind11::array::c_style | pybind11::array::forcecast>
        py_points = gbasis::as_pyarray_from_vector(points);

    const int nbasis = iodata.GetOrbitalBasis().numb_basis_functions();

    auto locals = py::dict("points"_a = py_points,
                           "true_result"_a = py_result,
                           "fchk_path"_a = fchk_file,
                           "numb_pts"_a = numb_pts,
                           "nbasis"_a = nbasis,
                           "alpha"_a = alpha);
    py::exec(R"(
import numpy as np
from gbasis.evals.density import evaluate_general_kinetic_energy_density
from iodata import load_one
from gbasis.wrappers import from_iodata

iodata = load_one(fchk_path)
basis, type = from_iodata(iodata)
rdm = (iodata.mo.coeffs * iodata.mo.occs).dot(iodata.mo.coeffs.T)
points = points.reshape((numb_pts, 3), order="F")
points = np.array(points, dtype=np.float64)

kin_dens = evaluate_general_kinetic_energy_density(rdm, basis, points, alpha=alpha, coord_type=type)
err = np.abs(kin_dens - true_result)
result = np.all(err < 1e-8)
print("General Kinetic Density Mean, Max, STD Error ", np.mean(err), np.max(err), np.std(err))
assert result, "General Kinetic Energy of Electron Density on GPU doesn't match gbasis."
    )", py::globals(), locals);
  } // Need this so that the python object doesn't outline the interpretor when we close it up.
}