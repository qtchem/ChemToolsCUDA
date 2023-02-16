#include <stdio.h>
#include <thrust/device_vector.h>

#include "../include/basis_to_gpu.cuh"
#include "../include/cuda_basis_utils.cuh"
#include "../include/cuda_utils.cuh"
#include "../include/evaluate_electrostatic.cuh"
#include "../include/integral_coeffs.cuh"

/**
* @Section Computing the electrostatic potential.
* ----------------------------------------------
**/
// START COMPUTER GENERATED (USING PYTHON) CODE "generate_integrals.py"


__device__ void compute_row_s_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_s_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_s_px_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_s_py_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_s_pz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_s_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_s_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_s_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_s_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_s_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_s_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_s_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_s_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_s_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_s_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_s_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_s_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_s_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_s(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_s_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_px_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_px_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_px_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_py_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_pz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_px_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_px_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_px_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_px_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_px_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_px_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_px_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_px_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_px_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_px_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_px_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_px_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_px_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_px_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_py_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_py_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_py_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_py_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_pz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_py_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_py_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_py_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_py_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_py_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_py_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_py_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_py_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_py_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_py_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_py_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_py_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_py_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_py_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_pz_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_pz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_pz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_pz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_pz_pz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_pz_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_pz_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_pz_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_pz_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_pz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_pz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_pz_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_pz_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_pz_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_pz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_pz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_pz_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_pz_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_p(alpha) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_pz_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_dxx_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_pz_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_dxx_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_dxx_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_dxx_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_dxx_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_dxx_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 2, 0, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_dyy_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_pz_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_dyy_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_dyy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_dyy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_dyy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_dzz_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_pz_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_dxx_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_dyy_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_dzz_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_dzz_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_dzz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_dzz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_dzz_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dzz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dzz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dzz_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_dxy_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_pz_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_dxx_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_dyy_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_dzz_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_dxy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_dxy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_dxy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_dzz_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_dxz_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_pz_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_dxx_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_dyy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_dzz_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_dxy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_dxz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_dxz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_dzz_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_dyz_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        if (pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0) + pow(A.z - B.z, 2.0) < -log(screen_tol) * (alpha + beta) / (alpha * beta))  {
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_s(beta) *
               gbasis::compute_s_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_px_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_py_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_p(beta) *
               gbasis::compute_pz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               gbasis::compute_dxx_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               gbasis::compute_dyy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               gbasis::compute_dzz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               gbasis::compute_dxy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               gbasis::compute_dxz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P);
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               gbasis::compute_dyz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P);
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_dzz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dyz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772 * gbasis::compute_dxy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
        } // End switch
         } // End integral screening 
      }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_c20_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_s(beta) *
               (
               -0.5 * gbasis::compute_s_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_s_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_s_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               -0.5 * gbasis::compute_px_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_px_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_px_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               -0.5 * gbasis::compute_py_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_py_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_py_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               -0.5 * gbasis::compute_pz_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_pz_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_pz_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               (
               -0.5 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               (
               -0.5 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               (
               -0.5 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_dzz_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               (
               -0.5 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_dzz_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               (
               -0.5 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_dzz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               (
               -0.5 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1 * gbasis::compute_dzz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5*-0.5 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*-0.5 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*1 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*-0.5 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5*-0.5 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*1 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1*-0.5 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1*-0.5 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1*1 * gbasis::compute_dzz_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5*1.7320508075688772 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*1.7320508075688772 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1*1.7320508075688772 * gbasis::compute_dzz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5*1.7320508075688772 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*1.7320508075688772 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1*1.7320508075688772 * gbasis::compute_dzz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5*0.8660254037844386 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*-0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.5*-0.8660254037844386 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1*0.8660254037844386 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1*-0.8660254037844386 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               -0.5*1.7320508075688772 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.5*1.7320508075688772 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 1*1.7320508075688772 * gbasis::compute_dzz_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
       }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_c21_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_s(beta) *
               (
               1.7320508075688772 * gbasis::compute_s_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_px_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_py_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_pz_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               (
               1.7320508075688772 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               (
               1.7320508075688772 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               (
               1.7320508075688772 * gbasis::compute_dzz_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               (
               1.7320508075688772 * gbasis::compute_dxy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               (
               1.7320508075688772 * gbasis::compute_dxz_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               (
               1.7320508075688772 * gbasis::compute_dxz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*-0.5 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*-0.5 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*1 * gbasis::compute_dzz_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dxz_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dxz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*0.8660254037844386 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*-0.8660254037844386 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dxy_dxz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
        } // End switch
       }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_s21_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_s(beta) *
               (
               1.7320508075688772 * gbasis::compute_s_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_px_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_py_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_pz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               (
               1.7320508075688772 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               (
               1.7320508075688772 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               (
               1.7320508075688772 * gbasis::compute_dzz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               (
               1.7320508075688772 * gbasis::compute_dxy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               (
               1.7320508075688772 * gbasis::compute_dxz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               (
               1.7320508075688772 * gbasis::compute_dyz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*-0.5 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*-0.5 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*1 * gbasis::compute_dzz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dxz_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dyz_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*0.8660254037844386 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*-0.8660254037844386 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dxy_dyz_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
        } // End switch
       }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_c22_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_s(beta) *
               (
               0.8660254037844386 * gbasis::compute_s_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_s_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               0.8660254037844386 * gbasis::compute_px_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_px_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               0.8660254037844386 * gbasis::compute_py_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_py_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               0.8660254037844386 * gbasis::compute_pz_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_pz_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               (
               0.8660254037844386 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               (
               0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               (
               0.8660254037844386 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               (
               0.8660254037844386 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               (
               0.8660254037844386 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               (
               0.8660254037844386 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386*-0.5 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 0.8660254037844386*-0.5 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 0.8660254037844386*1 * gbasis::compute_dxx_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386*-0.5 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386*-0.5 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386*1 * gbasis::compute_dyy_dzz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386*1.7320508075688772 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386*1.7320508075688772 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386*1.7320508075688772 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386*1.7320508075688772 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386*0.8660254037844386 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + 0.8660254037844386*-0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386*0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + -0.8660254037844386*-0.8660254037844386 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               0.8660254037844386*1.7320508075688772 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
                + -0.8660254037844386*1.7320508075688772 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
       }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_row_s22_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
    const int& point_index, int& i_integral, const int& iconst, int& jconst,
    const int& row_index, const int& npoints,
    const int& numb_contracted_shells, const int& icontr_shell, 
    const double& screen_tol) {
   // Enumerate through second basis set starting right after the contracted shell. 
  for(int jcontr_shell = icontr_shell; jcontr_shell < numb_contracted_shells; jcontr_shell++) {
    double3 B = {g_constant_basis[jconst++], g_constant_basis[jconst++], g_constant_basis[jconst++]};
    int numb_primitives2 = (int) g_constant_basis[jconst++];
    int angmom_2 = (int) g_constant_basis[jconst++];
    // Enumerate through all primitives.
    for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
      double alpha = g_constant_basis[iconst + i_prim1];
      for (int i_prim2 = 0; i_prim2 < numb_primitives2; i_prim2++) {
        double beta = g_constant_basis[jconst + i_prim2];
        double3 P = {(alpha * A.x + beta * B.x) / (alpha + beta),
                     (alpha * A.y + beta * B.y) / (alpha + beta),
                     (alpha * A.z + beta * B.z) / (alpha + beta)};
        switch(angmom_2){
          case 0: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_s(beta) *
               (
               1.7320508075688772 * gbasis::compute_s_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 1: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_px_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_py_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_p(beta) *
               (
               1.7320508075688772 * gbasis::compute_pz_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             break;
          case 2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 2, 0, 0) *
               (
               1.7320508075688772 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 2, 0) *
               (
               1.7320508075688772 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 0, 2) *
               (
               1.7320508075688772 * gbasis::compute_dzz_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 1, 0) *
               (
               1.7320508075688772 * gbasis::compute_dxy_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
               (
               1.7320508075688772 * gbasis::compute_dxy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 5) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_d(beta, 0, 1, 1) *
               (
               1.7320508075688772 * gbasis::compute_dxy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
          case -2: 
             d_point_charge[point_index + (i_integral + 0) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*-0.5 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*-0.5 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*1 * gbasis::compute_dzz_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 1) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dxy_dxz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 2) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dxy_dyz_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             d_point_charge[point_index + (i_integral + 3) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*0.8660254037844386 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
                + 1.7320508075688772*-0.8660254037844386 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(beta, B, alpha, A, pt, P)
               );
             d_point_charge[point_index + (i_integral + 4) * npoints] +=
               g_constant_basis[iconst + numb_primitives1 + i_prim1] *
               g_constant_basis[jconst + numb_primitives2 + i_prim2] *
               gbasis::normalization_primitive_pure_d(alpha) * 
               gbasis::normalization_primitive_pure_d(beta) * 
               (
               1.7320508075688772*1.7320508075688772 * gbasis::compute_dxy_dxy_nuclear_attraction_integral(alpha, A, beta, B, pt, P)
               );
             break;
        } // End switch
       }// End primitive 2
    }// End primitive 1 
    // Update index to go to the next segmented shell.
    switch(angmom_2){
      case 0: i_integral += 1;
        break;
      case 1: i_integral += 3;
        break;
      case 2: i_integral += 6;
        break;
      case -2: i_integral += 5;
        break;
    } // End switch 
  // Update index of constant memory to the next contracted shell of second basis set. 
    jconst += 2 * numb_primitives2;
  }// End contracted shell 2
}

__device__ void compute_diagonal_row_py_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      //py-py
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_p(alpha) *
        gbasis::normalization_primitive_p(beta) *
        gbasis::compute_py_py_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //py-pz
      d_point_charge[point_index + (i_integral + 1) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_p(alpha) *
        gbasis::normalization_primitive_p(beta) *
        gbasis::compute_py_pz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 2;
}

__device__ void compute_diagonal_row_pz_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      //pz-pz
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_p(alpha) *
        gbasis::normalization_primitive_p(beta) *
        gbasis::compute_pz_pz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 1;
}

__device__ void compute_diagonal_row_dyy_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      //dyy-dyy
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
        gbasis::normalization_primitive_d(beta, 0, 2, 0) *
        gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dyy-dzz
      d_point_charge[point_index + (i_integral + 1) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
        gbasis::normalization_primitive_d(beta, 0, 0, 2) *
        gbasis::compute_dyy_dzz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dyy-dxy
      d_point_charge[point_index + (i_integral + 2) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
        gbasis::normalization_primitive_d(beta, 1, 1, 0) *
        gbasis::compute_dyy_dxy_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dyy-dxz
      d_point_charge[point_index + (i_integral + 3) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
        gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
        gbasis::compute_dyy_dxz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dyy-dyz
      d_point_charge[point_index + (i_integral + 4) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 2, 0) *
        gbasis::normalization_primitive_d(beta, 0, 1, 1) *
        gbasis::compute_dyy_dyz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 5;
}

__device__ void compute_diagonal_row_dzz_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      //dzz-dzz
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
        gbasis::normalization_primitive_d(beta, 0, 0, 2) *
        gbasis::compute_dzz_dzz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dzz-dxy
      d_point_charge[point_index + (i_integral + 1) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
        gbasis::normalization_primitive_d(beta, 1, 1, 0) *
        gbasis::compute_dzz_dxy_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dzz-dxz
      d_point_charge[point_index + (i_integral + 2) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
        gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
        gbasis::compute_dzz_dxz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dzz-dyz
      d_point_charge[point_index + (i_integral + 3) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 0, 2) *
        gbasis::normalization_primitive_d(beta, 0, 1, 1) *
        gbasis::compute_dzz_dyz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 4;
}

__device__ void compute_diagonal_row_dxy_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      //dxy-dxy
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
        gbasis::normalization_primitive_d(beta, 1, 1, 0) *
        gbasis::compute_dxy_dxy_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dxy-dxz
      d_point_charge[point_index + (i_integral + 1) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
        gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
        gbasis::compute_dxy_dxz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dxy-dyz
      d_point_charge[point_index + (i_integral + 2) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 1, 1, 0) *
        gbasis::normalization_primitive_d(beta, 0, 1, 1) *
        gbasis::compute_dxy_dyz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 3;
}

__device__ void compute_diagonal_row_dxz_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      //dxz-dxz
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
        gbasis::normalization_primitive_d(beta, 1, 0, 1) * 
        gbasis::compute_dxz_dxz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
      //dxz-dyz
      d_point_charge[point_index + (i_integral + 1) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 1, 0, 1) * 
        gbasis::normalization_primitive_d(beta, 0, 1, 1) *
        gbasis::compute_dxz_dyz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 2;
}

__device__ void compute_diagonal_row_dyz_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      //dyz-dyz
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_d(alpha, 0, 1, 1) *
        gbasis::normalization_primitive_d(beta, 0, 1, 1) *
        gbasis::compute_dyz_dyz_nuclear_attraction_integral(alpha, A, beta, A, pt, P);
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 1;
}

__device__ void compute_diagonal_row_c21_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        1.7320508075688772*1.7320508075688772 * gbasis::compute_dxz_dxz_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
        );
      d_point_charge[point_index + (i_integral + 1) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        1.7320508075688772*1.7320508075688772 * gbasis::compute_dxz_dyz_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
        );
      d_point_charge[point_index + (i_integral + 2) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        1.7320508075688772*0.8660254037844386 * gbasis::compute_dxx_dxz_nuclear_attraction_integral(beta, A, alpha, A, pt, P)
         + 1.7320508075688772*-0.8660254037844386 * gbasis::compute_dyy_dxz_nuclear_attraction_integral(beta, A, alpha, A, pt, P)
        );
      d_point_charge[point_index + (i_integral + 3) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        1.7320508075688772*1.7320508075688772 * gbasis::compute_dxy_dxz_nuclear_attraction_integral(beta, A, alpha, A, pt, P)
        );
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 4;
}

__device__ void compute_diagonal_row_s21_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        1.7320508075688772*1.7320508075688772 * gbasis::compute_dyz_dyz_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
        );
      d_point_charge[point_index + (i_integral + 1) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        1.7320508075688772*0.8660254037844386 * gbasis::compute_dxx_dyz_nuclear_attraction_integral(beta, A, alpha, A, pt, P)
         + 1.7320508075688772*-0.8660254037844386 * gbasis::compute_dyy_dyz_nuclear_attraction_integral(beta, A, alpha, A, pt, P)
        );
      d_point_charge[point_index + (i_integral + 2) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        1.7320508075688772*1.7320508075688772 * gbasis::compute_dxy_dyz_nuclear_attraction_integral(beta, A, alpha, A, pt, P)
        );
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 3;
}

__device__ void compute_diagonal_row_c22_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        0.8660254037844386*0.8660254037844386 * gbasis::compute_dxx_dxx_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
         + 0.8660254037844386*-0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
         + -0.8660254037844386*0.8660254037844386 * gbasis::compute_dxx_dyy_nuclear_attraction_integral(beta, A, alpha, A, pt, P)
         + -0.8660254037844386*-0.8660254037844386 * gbasis::compute_dyy_dyy_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
        );
      d_point_charge[point_index + (i_integral + 1) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        0.8660254037844386*1.7320508075688772 * gbasis::compute_dxx_dxy_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
         + -0.8660254037844386*1.7320508075688772 * gbasis::compute_dyy_dxy_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
        );
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 2;
}

__device__ void compute_diagonal_row_s22_type_integral(const double3& A, const double3& pt,
    const int& numb_primitives1, double* d_point_charge, 
     const int& point_index, int& i_integral, const int& iconst, int& jconst,
     const int& row_index, const int& npoints, const int& icontr_shell) {
  // Enumerate through all primitives.
  for (int i_prim1 = 0; i_prim1 < numb_primitives1; i_prim1++) {
    double alpha = g_constant_basis[iconst + i_prim1];
    for (int i_prim2 = 0; i_prim2 < numb_primitives1; i_prim2++) {
      double beta = g_constant_basis[jconst + i_prim2];
      double3 P = {(alpha * A.x + beta * A.x) / (alpha + beta),
                   (alpha * A.y + beta * A.y) / (alpha + beta),
                   (alpha * A.z + beta * A.z) / (alpha + beta)};
      d_point_charge[point_index + (i_integral + 0) * npoints] +=
        g_constant_basis[iconst + numb_primitives1 + i_prim1] *
        g_constant_basis[jconst + numb_primitives1 + i_prim2] *
        gbasis::normalization_primitive_pure_d(alpha) * 
        gbasis::normalization_primitive_pure_d(beta) * 
        (
        1.7320508075688772*1.7320508075688772 * gbasis::compute_dxy_dxy_nuclear_attraction_integral(alpha, A, beta, A, pt, P)
        );
     }// End primitive 2
   }// End primitive 1 
   // Update index to go to the next segmented shell.
   i_integral += 1;
}


// END COMPUTER GENERATED (USING PYTHON) CODE "generate_integrals.py"


/**
 * TODO: Make the requirement that contracted shells are segmented to reduce the number of for loops.
 */
__global__ void gbasis::compute_point_charge_integrals(
    double* d_point_charge, const double* const d_grid, const int knumb_pts, const int nbasis, const double screen_tol) {
  // Every thread correspond to a grid point, the following is the mapping.
  int point_index = blockIdx.x * blockDim.x + threadIdx.x;
  if (point_index < knumb_pts) {
    // Setup the initial variables.
    double3 pt = {d_grid[point_index], d_grid[point_index + knumb_pts], d_grid[point_index + 2 * knumb_pts]};
    int iconst = 0;                                                          // Index to go over constant memory.
    int i_integral = 0;                                                      // Index to go over integrals, linearly.
    int numb_contracted_shells = (int) g_constant_basis[iconst++];           // Number of contracted shell.
    int row_index = nbasis;                                                  // Used to update different rows.
    // Enumerate through first basis set.
    for(int icontr_shell = 0; icontr_shell < numb_contracted_shells; icontr_shell++) {
      // Second index to go over constant memory. Due to symmetry of integrals, only need to go beyond iconst.
      int jconst = iconst;

      double3 A = {g_constant_basis[iconst++], g_constant_basis[iconst++], g_constant_basis[iconst++]};
      int numb_primitives_1 = (int) g_constant_basis[iconst++];
      int angmom_1 = (int) g_constant_basis[iconst++];
      if (angmom_1 == 0) {
        // These are the rows S-type (one row only)
        // Just enumerate through everything, updating "ipoint_charge" which tells you where in the 2d array you are.
        // Enumerating means that I'm going through all second basis-set right after this one and updating jconst.
        // ipoint_charge is updated based on the second basis-set.
        compute_row_s_type_integral( A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                     jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol
        );
      }
      else if (angmom_1 == 1) {
        // These are the rows P-type (3 rows only). Computing diagonal of px is itself and so there isn't any func forit.
        // Update row Px enumerate all second_shells, and do the integral, then updating "i_integral" for Py-Py.
        compute_row_px_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                     jconst, row_index, knumb_pts, numb_contracted_shells,
                                     icontr_shell, screen_tol);

        // Update row Py enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_py_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                              jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_py_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                     jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

        // Update row Pz enumerate all second_shells, and do the integral, then updating "i_integral" for next segmented.
        jconst = iconst;
        compute_diagonal_row_pz_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                              jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_pz_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                     jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;                // Move the contracted shell back to current.
      }
      else if (angmom_1 == 2) {
        compute_row_dxx_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells,
                                      icontr_shell, screen_tol);
        // Update row dyy enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_dyy_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                               jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_dyy_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

        // Update row dzz enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_dzz_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                               jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_dzz_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

        // Update row dxy enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_dxy_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                              jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_dxy_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                     jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

        // Update row dxz enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_dxz_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                               jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_dxz_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

        // Update row dyz enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_dyz_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                               jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_dyz_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

      }
      else if (angmom_1 == -2) {
        // Order is "c20", "c21", "s21", "c22", "s22"
        compute_row_c20_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells,
                                      icontr_shell, screen_tol);
        // Update row c21 enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_c21_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                               jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_c21_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

        // Update row s21 enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_s21_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                               jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_s21_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

        // Update row c22 enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_c22_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                               jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_c22_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.

        // Update row s22 enumerate all second_shells, and do the integral, then updating "i_integral" for Pz-Pz.
        jconst = iconst;
        compute_diagonal_row_s22_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                               jconst, row_index, knumb_pts, icontr_shell);
        jconst += 2 * numb_primitives_1;  // Move to the next contracted shell
        icontr_shell += 1;                // Move to the next contracted shell
        compute_row_s22_type_integral(A, pt, numb_primitives_1, d_point_charge, point_index, i_integral, iconst,
                                      jconst, row_index, knumb_pts, numb_contracted_shells, icontr_shell, screen_tol);
        icontr_shell -= 1;               // Move the contracted shell back to current.
      }
      // Update index of constant memory to the next contracted shell.
      iconst += 2 * numb_primitives_1;
    }  // End first basis set.
  } // End thread if condition
}


__host__ std::vector<double> gbasis::compute_electrostatic_potential_over_points(
    gbasis::IOData& iodata, double* grid, int knumb_pts, const double screen_tol, const bool disp) {
  // Place it into constant memory. The second argument must be true, as the decontracted basis set must be used.
  gbasis::MolecularBasis molecular_basis = iodata.GetOrbitalBasis();
  int nbasisfuncs = molecular_basis.numb_basis_functions();

  // Define the variables for the sizes in integer or in bytes.
  size_t t_numb_pts = knumb_pts;
  size_t t_nbasis = nbasisfuncs;
  size_t t_dim_rdm = t_nbasis * t_nbasis;
  size_t t_total_numb_integrals = t_numb_pts * t_nbasis * (t_nbasis + 1) / 2;
  size_t t_numb_pts_bytes = t_numb_pts * 3 * sizeof(double);                              // Each point has three double.
  size_t t_total_size_integrals_bytes = sizeof(double) * t_total_numb_integrals;
  size_t t_total_bytes = t_numb_pts_bytes + t_total_size_integrals_bytes * 2;             // Store grid and integrals twice.
  if (disp) {
    printf("Total Basis functions %zu \n", nbasisfuncs);
    printf("Basis Set Squared (RDM size) %zu \n", t_dim_rdm);
    printf("Number of integrals of all points %zu \n ", t_total_numb_integrals);
    printf("Total number of points %zu \n", t_numb_pts);
  }
  // Create the handles for using cublas.
  cublasHandle_t handle;
  cublasCreate(&handle);

  // Allocate one_rdm, identity matrix and the intermediate array called d_final. This is fixed throughout.
  double *d_one_rdm, *d_identity, *d_intermed;
  gbasis::cuda_check_errors(cudaMalloc((double **)&d_one_rdm, sizeof(double) * t_dim_rdm));
  gbasis::cuda_check_errors(cudaMalloc((double **)&d_intermed, sizeof(double) * t_dim_rdm));
  gbasis::cuda_check_errors(cudaMalloc((double **)&d_identity, sizeof(double) * t_dim_rdm));
  if (nbasisfuncs > 1024) {
    std::runtime_error("Number of basis functions is greater than maximum thread per block. Just need to change this");
  }
  dim3 blockDim(nbasisfuncs, nbasisfuncs);
  dim3 gridDim (1, 1);
  gbasis::set_identity_row_major<<<blockDim, gridDim>>>(d_identity, nbasisfuncs, nbasisfuncs);
  gbasis::cublas_check_errors(cublasSetMatrix (t_nbasis, t_nbasis, sizeof(double), iodata.GetMOOneRDM(),
                                               t_nbasis, d_one_rdm, t_nbasis));
  //printf("Print ideti t\n");
  //print_firstt_ten_elements<<<1, 1>>>(d_identity);
  //printf("print  one_Rdm\n");
  //print_firstt_ten_elements<<<1, 1>>>(d_one_rdm);
  //cudaDeviceSynchronize();

  // Set cache perference to L1 and compute the point charge integrals.
  cudaFuncSetCacheConfig(gbasis::compute_point_charge_integrals, cudaFuncCachePreferL1);
  // Allocate electrostatic vector that gets returned.
  std::vector<double> electrostatic(knumb_pts);
  // Calculate how much memory can fit inside a 12 GB (11 GB for safe measures) GPU memory.
  size_t t_numb_chunks = t_total_bytes / 11000000000;
  // Maximal number of points to do each iteration to achieve 11 GB of GPU memory.
  size_t t_numb_pts_of_each_chunk = 11000000000 / (sizeof(double) * (t_nbasis * (t_nbasis + 1) + 3));
  //size_t t_numb_pts_of_each_chunk = 11000000000  / (3 * 8 + 8 * t_nbasis * (t_nbasis + 1));  // Solving 11Gb = Number of Pts * 3 * 8 + 2 * (number of integrals)
  size_t t_index_of_grid_at_ith_iter = 0;
  if (disp) {
    printf("Number of chunks %zu \n", t_numb_chunks);
    printf("Maximal number of points to do each chunk %zu \n", t_numb_pts_of_each_chunk);
  }
  double *d_grid, *d_point_charge, *d_point_charge_transpose;
  double alpha = 1.; double beta = 0.;
  // Iterate through each chunk of the data set.
  //for(size_t i_iter = 0; i_iter < t_numb_chunks + 1; i_iter++) {
  //for(size_t i_iter = t_numb_chunks + 1; i_iter <= t_numb_chunks + 1; i_iter++) {
  size_t i_iter = 0;
  while(t_index_of_grid_at_ith_iter < t_numb_pts) {
    // Figure out how many points to do this iteration.
    size_t t_numb_pts_ith_iter = std::min(t_numb_pts - i_iter * t_numb_pts_of_each_chunk, t_numb_pts_of_each_chunk);
    if (disp) {
      printf("ITH CHUNK %zu and Number of points in ith %zu \n", i_iter, t_numb_pts_ith_iter);
    }
    size_t t_numb_pts_ith_iter_bytes = t_numb_pts_ith_iter * 3 * sizeof(double);    // Calculate number of bytes in this iter.
    size_t t_total_numb_integrals_ith_iter = t_numb_pts_ith_iter * t_nbasis * (t_nbasis + 1) / 2;
    size_t t_total_size_integrals_ith_iter_bytes = sizeof(double) * t_total_numb_integrals_ith_iter;

    // Transfer portion of the grid in row-major order into column-major order stored in portion_grid_col.
    double* portion_grid_col = new double[t_numb_pts_ith_iter * 3];
    int counter = 0;
    for (size_t i = 0; i < 3; i++) {
      for (size_t j = 0; j < t_numb_pts_ith_iter; j++) {
        portion_grid_col[counter] = grid[i + (t_index_of_grid_at_ith_iter + j) * 3];
        counter += 1;
      }
    }

    // Transfer portion of the grid to GPU, this grid needs to be stored in Column-major order.
    gbasis::cuda_check_errors(cudaMalloc((double **)&d_grid, t_numb_pts_ith_iter_bytes));
    gbasis::cuda_check_errors(cudaMemcpy(d_grid, portion_grid_col, t_numb_pts_ith_iter_bytes,
                                         cudaMemcpyHostToDevice));
    delete[] portion_grid_col;
//    printf("Print grid \n");
//    gbasis::print_first_ten_elements<<<1, 1>>>(d_grid);
//    cudaDeviceSynchronize();

    // Allocate one-point charge integral array, stored as integrals then points, and set it to zero.
    gbasis::cuda_check_errors(cudaMalloc((double **)&d_point_charge, t_total_size_integrals_ith_iter_bytes));
    gbasis::cuda_check_errors(cudaMemset(d_point_charge, 0, t_total_size_integrals_ith_iter_bytes));
    // Compute point charge integrals.
    if (disp) {
      printf("Compute point charge integrals\n");
    }
    dim3 threadsPerBlock32(256); // 128, 96 same as 320 speed, 1024 one second slower, 64 is really slow.
    //dim3 grid32 ((t_total_numb_integrals_ith_iter + threadsPerBlock32.x - 1) / (threadsPerBlock32.x));
    dim3 grid32 ((t_numb_pts_ith_iter + threadsPerBlock32.x - 1) / (threadsPerBlock32.x));
    if (disp) {
      printf("Number of threads %d \n", threadsPerBlock32.x);
      printf("Grid size %d \n", grid32.x);
    }
    gbasis::compute_point_charge_integrals<<<grid32, threadsPerBlock32>>>(
        d_point_charge, d_grid, (int) t_numb_pts_ith_iter, nbasisfuncs, screen_tol
        );
//    printf("Print d_point charge \n");
//    gbasis::print_first_ten_elements<<<1, 1>>>(d_point_charge);
//    cudaDeviceSynchronize();
    // Free Grid in Device
    cudaFree(d_grid);

    // Transpose point_charge from (Z, Y, X) (col-major) to (Y, X, Z), where Z=number of points, Y, X are the contractions.
    gbasis::cuda_check_errors(cudaMalloc((double **)&d_point_charge_transpose, t_total_size_integrals_ith_iter_bytes));
    gbasis::cublas_check_errors(cublasDgeam(handle, CUBLAS_OP_T, CUBLAS_OP_T,
                                            nbasisfuncs * (nbasisfuncs + 1) / 2, (int) t_numb_pts_ith_iter,
                                            &alpha, d_point_charge, (int) t_numb_pts_ith_iter,
                                            &beta, d_point_charge, (int) t_numb_pts_ith_iter,
                                            d_point_charge_transpose, nbasisfuncs * (nbasisfuncs + 1) / 2));
    //printf("Print d point charge transpose \n");
    //print_final_ten_elements<<<1, 1>>>(d_point_charge_transpose, t_total_numb_integrals_ith_iter);
//    gbasis::print_first_ten_elements<<<1, 1>>>(d_point_charge_transpose);
//    cudaDeviceSynchronize();
    //print_firstt_ten_elements<<<1, 1>>>(d_point_charge_transpose);

    // Free up d_point_charge
    cudaFree(d_point_charge);
    // The point charge array must be converted from  triangular packed format to
    //  triangular format for matrix-multiplcation.
    double* d_triangular_format;
    gbasis::cuda_check_errors(cudaMalloc((double **)&d_triangular_format, sizeof(double) * t_dim_rdm));
    gbasis::cuda_check_errors(cudaMemset(d_triangular_format, 0, sizeof(double) * t_dim_rdm));
    // Go through each grid point and calculate one component of the electrostatic potential.
    for(size_t i = 0; i < t_numb_pts_ith_iter; i++) {
      //  Conversion from the triangular packed format to the triangular format
      gbasis::cublas_check_errors(cublasDtpttr(handle, CUBLAS_FILL_MODE_LOWER,
                                               nbasisfuncs,
                                               &d_point_charge_transpose[i * t_nbasis * (t_nbasis + 1) / 2],
                                               d_triangular_format,
                                               nbasisfuncs
      ));
      // Symmetric Matrix multiplication by the identity matrix to convert it to a full-matrix
      //  TODO: THIS PART IS SLOW, IT COULD BE SOMEHOW REMOVED>
      gbasis::cublas_check_errors(cublasDsymm(handle, CUBLAS_SIDE_RIGHT, CUBLAS_FILL_MODE_LOWER,
                                              nbasisfuncs, nbasisfuncs,
                                              &alpha, d_triangular_format, nbasisfuncs,  // A
                                              d_identity, nbasisfuncs,                   // B
                                              &beta, d_intermed, nbasisfuncs));
      // Hadamard Product with One RDM
      dim3 threadsPerBlock2(320);
      dim3 grid2 ((t_nbasis * t_nbasis + threadsPerBlock2.x - 1) / (threadsPerBlock2.x));
      gbasis::hadamard_product<<<grid2, threadsPerBlock2>>>(d_intermed, d_one_rdm, nbasisfuncs, nbasisfuncs);

      // Sum over the entire matrix to get the final point_charge.
      thrust::device_ptr<double> deviceVecPtr = thrust::device_pointer_cast(d_intermed);
      electrostatic[t_index_of_grid_at_ith_iter + i] = thrust::reduce(
          deviceVecPtr, deviceVecPtr + nbasisfuncs * nbasisfuncs
      );
    }
    // Update index for the next iteration/chunk of grid.
    t_index_of_grid_at_ith_iter += t_numb_pts_ith_iter;
    i_iter += 1;

    cudaFree(d_point_charge_transpose);
    cudaFree(d_triangular_format);
  }
  cublasDestroy(handle);  // cublas handle is no longer needed infact most of
  cudaFree(d_one_rdm);
  cudaFree(d_identity);
  cudaFree(d_intermed);
  // Subtract by the charge of the nucleus to get the final result.
  for(int i = 0; i < knumb_pts; i++){
    electrostatic[i] *= (-1.);
    for(int j = 0; j < iodata.GetNatoms(); j++) {
      double val = iodata.GetCharges()[j] /
//          std::sqrt(std::pow(grid[i] - iodata.GetCoordAtoms()[j * 3], 2) +
//              std::pow(grid[i + knumb_pts] - iodata.GetCoordAtoms()[j* 3 + 1], 2) +
//              std::pow(grid[i + (knumb_pts * 2)] - iodata.GetCoordAtoms()[j * 3 + 2], 2) );
          std::sqrt(std::pow(grid[i * 3] - iodata.GetCoordAtoms()[j * 3], 2) +
              std::pow(grid[i * 3 + 1] - iodata.GetCoordAtoms()[j* 3 + 1], 2) +
              std::pow(grid[i * 3 + 2] - iodata.GetCoordAtoms()[j * 3 + 2], 2) );
      electrostatic[i] += val;
    }
  }
  return electrostatic;
}
