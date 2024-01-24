#include <algorithm>

#include "../include/evaluate_density.cuh"
#include "../include/evaluate_densbased.cuh"
#include "../include/evaluate_gradient.cuh"
#include "../include/evaluate_laplacian.cuh"
#include "../include/cuda_utils.cuh"

__host__ std::vector<double> gbasis::compute_norm_of_3d_vector(double *h_points, const int knumb_pts){
  std::vector<double> h_norm(knumb_pts);
  // Assumes h_points is in column-order.

  // Transfer to GPU memory
  double *d_points;
  gbasis::cuda_check_errors(cudaMalloc((double **) &d_points, sizeof(double) * 3 * knumb_pts));
  gbasis::cuda_check_errors(cudaMemcpy(d_points, h_points,
                                       sizeof(double) * 3 * knumb_pts,
                                       cudaMemcpyHostToDevice));

  // Square the GPU memory
  dim3 threadsPerBlock(320);
  dim3 grid((3 * knumb_pts + threadsPerBlock.x - 1) / (threadsPerBlock.x));
  gbasis::pow_inplace<<<grid, threadsPerBlock>>>(d_points, 2.0, 3 * knumb_pts);

  // Sum the first row with the second row
  dim3 grid2((knumb_pts + threadsPerBlock.x - 1) / (threadsPerBlock.x));
  gbasis::sum_two_arrays_inplace<<<grid2, threadsPerBlock>>>(d_points, &d_points[knumb_pts], knumb_pts);

  // Add the third row
  gbasis::sum_two_arrays_inplace<<<grid2, threadsPerBlock>>>(&d_points[0], &d_points[2 * knumb_pts], knumb_pts);

  // Take square root the GPU memory
  gbasis::square_root<<<grid2, threadsPerBlock>>>(d_points, knumb_pts);

  // Transfer from GPU memory to CPU
  gbasis::cuda_check_errors(cudaMemcpy(h_norm.data(), d_points, sizeof(double) * knumb_pts, cudaMemcpyDeviceToHost));
  cudaFree(d_points);

  return h_norm;
}


__host__ std::vector<double> gbasis::compute_reduced_density_gradient(
    gbasis::IOData& iodata, const double* h_points, const int knumb_points
) {
  std::vector<double> reduced_dens_grad(knumb_points);

  // Compute the density and norm of the gradient (in column-order)
  std::vector<double> density = gbasis::evaluate_electron_density_on_any_grid(iodata, h_points, knumb_points);
  std::vector<double> gradient = gbasis::evaluate_electron_density_gradient(iodata, h_points, knumb_points, false);
  std::vector<double> norm_grad = gbasis::compute_norm_of_3d_vector(gradient.data(), knumb_points);

  // Transfer the norm to the d_reduced_dens_grad GPU
  double *d_reduced_dens_grad;
  gbasis::cuda_check_errors(cudaMalloc((double **) &d_reduced_dens_grad, sizeof(double) * knumb_points));
  gbasis::cuda_check_errors(cudaMemcpy(d_reduced_dens_grad, norm_grad.data(),
                                       sizeof(double) * knumb_points,
                                       cudaMemcpyHostToDevice));

  // Transfer density to GPU
  double *d_density;
  gbasis::cuda_check_errors(cudaMalloc((double **) &d_density, sizeof(double) * knumb_points));
  gbasis::cuda_check_errors(cudaMemcpy(d_density, density.data(),
                                       sizeof(double) *  knumb_points,
                                       cudaMemcpyHostToDevice));

  // Take density to the power of (4 / 3)
  dim3 threadsPerBlock(320);
  dim3 grid((knumb_points + threadsPerBlock.x - 1) / (threadsPerBlock.x));
  gbasis::pow_inplace<<<grid, threadsPerBlock>>>(d_density, 4.0 / 3.0, knumb_points);

  // Divide them with masking
  gbasis::divide_inplace<<<grid, threadsPerBlock>>>(d_reduced_dens_grad, d_density, knumb_points, 1e-20);
  cudaFree(d_density);

  // Multiply by prefactor
  double prefactor = 0.5 / std::pow(3.0 * std::pow(CUDART_PI_D, 2.0), 1.0 / 3.0);
  gbasis::multiply_scalar<<<grid, threadsPerBlock>>>(d_reduced_dens_grad, prefactor, knumb_points);

  // Transfer back to CPU
  // Transfer from GPU memory to CPU
  gbasis::cuda_check_errors(cudaMemcpy(
      reduced_dens_grad.data(), d_reduced_dens_grad, sizeof(double) * knumb_points, cudaMemcpyDeviceToHost
      ));
  cudaFree(d_reduced_dens_grad);

  return reduced_dens_grad;
}

__host__ std::vector<double> gbasis::compute_weizsacker_ked(
    gbasis::IOData& iodata, const double* h_points, const int knumb_points
){
  std::vector<double> weizsacker_ked(knumb_points);

  // Compute the density and norm of the gradient (in column-order)
  std::vector<double> density = gbasis::evaluate_electron_density_on_any_grid(iodata, h_points, knumb_points);
  std::vector<double> gradient = gbasis::evaluate_electron_density_gradient(iodata, h_points, knumb_points, false);

  // Transfer the gradient to GPU
  double *d_gradient;
  gbasis::cuda_check_errors(cudaMalloc((double **) &d_gradient, sizeof(double) * 3 * knumb_points));
  gbasis::cuda_check_errors(cudaMemcpy(d_gradient, gradient.data(),
                                       sizeof(double) * 3 * knumb_points,
                                       cudaMemcpyHostToDevice));
  // Compute the dot-product between gradient
  //    Compute hadamard product between itself
  dim3 threadsPerBlock(320);
  dim3 grid((3 * knumb_points + threadsPerBlock.x - 1) / (threadsPerBlock.x));
  gbasis::hadamard_product<<<grid, threadsPerBlock>>>(d_gradient, d_gradient, 3, knumb_points);

  //   Sum the rows together
  // Sum the first row with the second row
  dim3 grid2((knumb_points + threadsPerBlock.x - 1) / (threadsPerBlock.x));
  gbasis::sum_two_arrays_inplace<<<grid2, threadsPerBlock>>>(d_gradient, &d_gradient[knumb_points], knumb_points);
  // Add the third row
  gbasis::sum_two_arrays_inplace<<<grid2, threadsPerBlock>>>(&d_gradient[0], &d_gradient[2 * knumb_points], knumb_points);

  // Transfer density to GPU
  double *d_density;
  gbasis::cuda_check_errors(cudaMalloc((double **) &d_density, sizeof(double) * knumb_points));
  gbasis::cuda_check_errors(cudaMemcpy(d_density, density.data(),
                                       sizeof(double) *  knumb_points,
                                       cudaMemcpyHostToDevice));

  // Multiply density by 8
  gbasis::multiply_scalar<<<grid2, threadsPerBlock>>>(d_density, 8.0, knumb_points);

  // Divide dot product of gradient with (8 rho)
  gbasis::divide_inplace<<<grid2, threadsPerBlock>>>(d_gradient, d_density, knumb_points, 1e-20);
  cudaFree(d_density);

  // Transfer back to CPU
  gbasis::cuda_check_errors(cudaMemcpy(
      weizsacker_ked.data(), d_gradient, sizeof(double) * knumb_points, cudaMemcpyDeviceToHost
  ));
  cudaFree(d_gradient);

  return weizsacker_ked;
}

__host__ std::vector<double> gbasis::compute_thomas_fermi_energy_density(
    gbasis::IOData& iodata, const double* h_points, int knumb_points
){
  std::vector<double> thomas_fermi(knumb_points);

  // Compute the density
  std::vector<double> density = gbasis::evaluate_electron_density_on_any_grid(iodata, h_points, knumb_points);

  // Transfer density to GPU
  double *d_density;
  gbasis::cuda_check_errors(cudaMalloc((double **) &d_density, sizeof(double) * knumb_points));
  gbasis::cuda_check_errors(cudaMemcpy(d_density, density.data(),
                                       sizeof(double) *  knumb_points,
                                       cudaMemcpyHostToDevice));

  // Take the power to (5.0 / 3.0)
  dim3 threadsPerBlock(320);
  dim3 grid((knumb_points + threadsPerBlock.x - 1) / (threadsPerBlock.x));
  gbasis::pow_inplace<<<grid, threadsPerBlock>>>(d_density, 5.0 / 3.0, knumb_points);

  // Multiply by prefactor
  double prefactor = 0.3 * std::pow(3.0 * std::pow(CUDART_PI_D, 2.0), 2.0 / 3.0);
  gbasis::multiply_scalar<<<grid, threadsPerBlock>>>(d_density, prefactor, knumb_points);

  // Transfer back to CPU
  gbasis::cuda_check_errors(cudaMemcpy(
      thomas_fermi.data(), d_density, sizeof(double) * knumb_points, cudaMemcpyDeviceToHost
  ));
  cudaFree(d_density);

  return thomas_fermi;
}

__host__ std::vector<double> gbasis::compute_ked_gradient_expansion_general(
    gbasis::IOData& iodata, const double* h_points, int knumb_points, double a, double b
) {
  std::vector<double> thomas_fermi_ked = gbasis::compute_thomas_fermi_energy_density(iodata, h_points, knumb_points);
  std::vector<double> weizsacker_ked = gbasis::compute_weizsacker_ked(iodata, h_points, knumb_points);
  std::vector<double> laplacian = gbasis::evaluate_laplacian(iodata, h_points, knumb_points);

  std::transform(weizsacker_ked.begin(), weizsacker_ked.end(), weizsacker_ked.begin(),
                 [&a](auto& c){return c * a;});
  std::transform(laplacian.begin(), laplacian.end(), laplacian.begin(),
                 [&b](auto& c){return c * b;});

  std::transform(thomas_fermi_ked.begin(), thomas_fermi_ked.end(), weizsacker_ked.begin(),
                 thomas_fermi_ked.begin(), std::plus<double>());
  std::transform(thomas_fermi_ked.begin(), thomas_fermi_ked.end(), laplacian.begin(),
                 thomas_fermi_ked.begin(), std::plus<double>());

  return thomas_fermi_ked;
}