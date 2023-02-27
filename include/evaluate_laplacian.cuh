

#ifndef GBASIS_CUDA_INCLUDE_EVALUATE_LAPLACIAN_CUH_
#define GBASIS_CUDA_INCLUDE_EVALUATE_LAPLACIAN_CUH_

#include "cublas_v2.h"

#include "iodata.h"

namespace gbasis {

/**
 * Device helper function for evaluating the sum of second derivative of each contractions
 *
 * Assumes basis set information is stored in GPU constant memory via basis_to_gpu.cu file.
 *
 *
 * @param[in, out] d_contractions_array The device pointer to the contractions array of size (M, N) where M is
 *                  the number of contractions and N is the number of points. This is in row-major order.
 *                  Values should be set to zero before using.
 * @param grid_x The grid point in the x-axis.
 * @param grid_y  The grid point in the y-axis.
 * @param grid_z  The grid point in the z-axis.
 * @param knumb_points  The number of points.
 * @param global_index  The global index of the thread, which also corresponds to the point.
 */
__device__ void evaluate_sum_of_second_derivative_contractions_from_constant_memory(
    double *d_contractions_array, const double &grid_x, const double &grid_y, const double &grid_z,
    const int &knumb_points, unsigned int &global_index
);


__global__ void evaluate_sum_of_second_contractions_from_constant_memory_on_any_grid(
    double* d_contractions_array, const double* const d_points, const int knumb_points
);

/**
 * Evaluate sum of second derivatives of the contractions.
 *
 * @param[in] iodata  The IOData object that stores the molecules basis.
 * @param[in] h_points Array in column-major order that stores the three-dimensional points.
 * @param[in] knumb_points Number of points in d_points.
 * @return Return sum of second derivatives of each contraction this is in row-order (M, N),
 *          where M =number of basis-functions.
 */
__host__ std::vector<double> evaluate_sum_of_second_derivative_contractions(
    gbasis::IOData& iodata, const double* h_points, const int knumb_points
);

/**
 * Helper function for computing the Laplacian.
 *
 *   2 \sum_i \sum_j c_{i, j}  [\sum_k \partial \phi_i^2 \ \partial x_k^2] \phi_j .
 *
 *   where \phi_i is the ith contraction and c_{i, j} are the MO coefficients.
 *
 * @param handle: Cublas handle
 * @param iodata:  The IOData object that stores the molecules basis.
 * @param h_laplacian: Vector whose values are to be replaced.
 * @param h_points: Array in column-major order that stores the three-dimensional points.
 * @param knumb_points: Number of points
 * @param knbasisfuncs: Number of basis-functions.
 */
__host__ void compute_first_term(
    const cublasHandle_t& handle, const gbasis::IOData& iodata, std::vector<double>& h_laplacian,
    const double* const h_points, const int knumb_points, const int knbasisfuncs
);

__host__ std::vector<double> evaluate_laplacian_on_any_grid_handle(
    cublasHandle_t& handle, gbasis::IOData& iodata, const double* h_points, const int knumb_points
);

/**
 * Evaluate the Laplacian of the electorn density on a grid of points.
 *
 * The Laplacian is the sum of the second derivatives of the electron density.
 *
 * @param[in] iodata  The IOData object that stores the molecules basis.
 * @param[in] h_points Array in column-major order that stores the three-dimensional points.
 * @param[in] knumb_points Number of points in d_points.
 * @return h_laplacian The Laplacian of the electron density evaluated on each point.
 */
__host__ std::vector<double> evaluate_laplacian(
    gbasis::IOData& iodata, const double* h_points, const int knumb_points
);
}
#endif //GBASIS_CUDA_INCLUDE_EVALUATE_LAPLACIAN_CUH_