#include <cassert>

#include "../include/cuda_basis_utils.cuh"
#include "../include/cuda_utils.cuh"

/// Compute the normalization constant of a single primitive Cartesian Gaussian, S-type only.
__device__ double chemtools::normalization_primitive_s(double alpha) {
  return pow(2.0 * alpha / CUDART_PI_D, 3. / 4.);
}

/// Compute the normalization constant of a single primitive Cartesian Gaussian, P-type only
__device__ double chemtools::normalization_primitive_p(double alpha) {
  return sqrt(pow(2.0 * alpha / CUDART_PI_D, 3. / 2.) * 4 * alpha);
}

/// Compute the normalization constant of a single primitive Cartesian Gaussian, D-type only
__device__ double chemtools::normalization_primitive_d(double alpha, int nx, int ny, int nz) {
  // (nx, ny, nz) are the angular components and sum to 2
  if (((nx == 1) & (ny == 1)) | ((nx == 1) & (nz == 1)) | ((ny == 1) & (nz == 1))) {
    return pow(2.0 * alpha / CUDART_PI_D, 3. / 4.) * 4 * alpha;
  } else {
    return sqrt(pow(2.0 * alpha / CUDART_PI_D, 3.0 / 2.0) * pow(4 * alpha, 2) / 3);
  }
}

/// Compute the normalization constant of a single primitive Cartesian Gaussian, F-type only
__device__ double chemtools::normalization_primitive_f(double alpha, int nx, int ny, int nz) {
  // (nx, ny, nz) are the angular components and sum to 3
  bool cond1 = ((nx == 3) & (ny == 0) & (nz == 0)) |
      ((nx == 0) & (ny == 3) & (nz == 0)) |
      ((nx == 0) & (ny == 0) & (nz == 3));
  if (cond1) {
    return sqrt(pow(2.0 * alpha / CUDART_PI_D, 3.0 / 2.0) * pow(4 * alpha, 3) / 15);
  }
  bool cond2 = ((nx == 1) & (ny == 1) & (nz == 1));
  if (cond2) {
    return sqrt(pow(2.0 * alpha / CUDART_PI_D, 3.0 / 2.0) * pow(4 * alpha, 3));
  }
  else {
    return sqrt(pow(2.0 * alpha / CUDART_PI_D, 3.0 / 2.0) * pow(4 * alpha, 3) / 3);
  }
}

/// Compute the normalization constant of a single primitive Cartesian Gaussian, G-type only
__device__ double chemtools::normalization_primitive_g(double alpha, int nx, int ny, int nz) {
  // (nx, ny, nz) are the angular components and sum to 3
  bool cond1 = ((nx == 4) & (ny == 0) & (nz == 0)) |
      ((nx == 0) & (ny == 4) & (nz == 0)) |
      ((nx == 0) & (ny == 0) & (nz == 4));
  double num = pow(2.0 * alpha / CUDART_PI_D, 3.0 / 2.0) * pow(4 * alpha, 4);
  if (cond1) {
    return sqrt(num / 105.0);
  }
  cond1 = ((nx == 2) & (ny == 2) & (nz == 0)) |
      ((nx == 2) & (ny == 0) & (nz == 2)) |
      ((nx == 0) & (ny == 2) & (nz == 2));
  if (cond1) {
    return sqrt(num / 9.0);
  }
  cond1 = ((nx == 2) & (ny == 1) & (nz == 1)) |
      ((nx == 1) & (ny == 2) & (nz == 1)) |
      ((nx == 1) & (ny == 1) & (nz == 2));
  if (cond1) {
    return sqrt(num / 3.0);
  }
  else {
    // (3, 1, 1), (1, 3, 1) etc
    return sqrt(num / 15.0);
  }
}

/// Compute the normalization constant of a single primitive Pure (Spherical Harmonics) Gaussian, D-type only.
__device__ double chemtools::normalization_primitive_pure_d(double alpha) {
  // Angular momentum L is 2 in this case.
  return sqrt(pow(2.0 * alpha / CUDART_PI_D, 1.5) * pow(4.0 * alpha, 2) / 3.0);
}

__device__ double chemtools::normalization_primitive_pure_f(double alpha) {
  // Angular momentum is L is 3 in this case
  // Formula is ((2a / pi)^1.5  *  (4 a)^L  / (2L - 1)!! )^0.5
  return sqrt(pow(2.0 * alpha / CUDART_PI_D, 1.5) * pow(4.0 * alpha, 3) / 15.0);
}

__device__ double chemtools::normalization_primitive_pure_g(double alpha) {
  // Angular momentum is L is 4 in this case
  // Formula is ((2a / pi)^1.5  *  (4 a)^L  / (2L - 1)!! )^0.5
  return sqrt(pow(2.0 * alpha / CUDART_PI_D, 1.5) * pow(4.0 * alpha, 4) / 105.0);
}

/// Compute the Pure/Harmonic basis functions for d-type shells.
__device__ double chemtools::solid_harmonic_function_d(int m, double r_Ax, double r_Ay, double r_Az) {
  //  In the literature, e.g. in the book Molecular Electronic-Structure Theory by Helgaker, Jørgensen and Olsen,
  //          negative magnetic quantum numbers for pure functions are usually referring to sine-like functions.
  // so m=-2,-1 are sin functions.
  // These multiply (-1)^m * r^l by sin(or cos) by the associated Legendere polynomial by the norm constants grouped
  //      these norms the l and m are plugged in. In fact it is sqrt(2(2 - |m|)!/(2 + |m|)!).
  // These are obtained from the table in pg 211 of Helgeker's book.
  if (m == -2) {
    return sqrt(3.) * r_Ax * r_Ay;
  }
  else if (m == -1) {
    return sqrt(3.) * r_Ay * r_Az;
  }
  else if (m == 0) {
    return (2 * pow(r_Az, 2.0) - pow(r_Ax, 2.0) - pow(r_Ay, 2.0)) / 2.0;
  }
  else if (m == 1) {
    return sqrt(3.) * r_Ax * r_Az;
  }
  else if (m == 2) {
    return sqrt(3.0) * (pow(r_Ax, 2.0) -  pow(r_Ay, 2.0)) / 2.0;
  }
  else {
    assert(0);
  }
  assert (0);
  return 0.;
}

/// Compute the Pure/Harmonic basis functions for f-type shells.
__device__ double chemtools::solid_harmonic_function_f(int m, double r_Ax, double r_Ay, double r_Az) {
  //  In the literature, e.g. in the book Molecular Electronic-Structure Theory by Helgaker, Jørgensen and Olsen,
  //          negative magnetic quantum numbers for pure functions are usually referring to sine-like functions.
  // so m=-2,-1 are sin functions.
  // These multiply (-1)^m * r^l by sin(or cos) by the associated Legendere polynomial by the norm constants grouped
  //      these norms the l and m are plugged in. In fact it is sqrt(2(2 - |m|)!/(2 + |m|)!).
  // These are obtained from the table in pg 211 of Helgeker's book.

  if (m == -3) {
    return sqrt(2.5) * (3.0 * pow(r_Ax, 2.0) -  pow(r_Ay, 2.0)) * r_Ay / 2.0;
  }
  else if (m == -2) {
    return sqrt(15.0) * r_Ax * r_Ay * r_Az;
  }
  else if (m == -1) {
    return sqrt(1.5) * (4.0 * pow(r_Az, 2.0) - (pow(r_Ax, 2.0) + pow(r_Ay, 2.0))) * r_Ay / 2.0;
  }
  else if (m == 0) {
    return (2.0 * pow(r_Az, 2.0) - 3.0 * (pow(r_Ax, 2.0) + pow(r_Ay, 2.0))) * r_Az / 2.0;
  }
  else if (m == 1) {
    return sqrt(1.5) * (4.0 * pow(r_Az, 2.0) - (pow(r_Ax, 2.0) + pow(r_Ay, 2.0))) * r_Ax / 2.0;
  }
  else if (m == 2) {
    return sqrt(15.0) * (pow(r_Ax, 2.0) -  pow(r_Ay, 2.0)) * r_Az / 2.0;
  }
  else if (m == 3) {
    return sqrt(2.5) * (pow(r_Ax, 2.0) -  3.0 * pow(r_Ay, 2.0)) * r_Ax / 2.0;
  }
  else {
    assert(0);
  }
  assert (0);
  return 0.;
}


/// Compute the Pure/Harmonic basis functions for g-type shells.
__device__ double chemtools::solid_harmonic_function_g(int m, double r_Ax, double r_Ay, double r_Az) {
  if (m == 4) {
    return sqrt(35.0) * (pow(r_Ax, 4.0) - 6.0 * pow(r_Ax, 2.0) * pow(r_Ay, 2.0) + pow(r_Ay, 4.0)) / 8.0;
  }
  else if (m == 3) {
    return sqrt(35.0 / 2.0) * (pow(r_Ax, 2.0) - 3.0 * pow(r_Ay, 2.0)) * r_Ax * r_Az / 2.0;
  }
  else if (m == 2) {
    return sqrt(5.0) * (6.0 * pow(r_Az, 2.0) -
        (pow(r_Ay, 2.0) + pow(r_Ax, 2.0)))
        * (pow(r_Ax, 2.0) - pow(r_Ay, 2.0)) / 4.0;
  }
  else if (m == 1) {
    return sqrt(2.5) * (4.0 * pow(r_Az, 2.0) - 3.0 * pow(r_Ax, 2.0) - 3.0 * pow(r_Ay, 2.0))
        * r_Ax * r_Az / 2.0;
  }
  else if (m == 0) {
    double rad_sq = (pow(r_Az, 2.0) + pow(r_Ay, 2.0) + pow(r_Ax, 2.0));
    return (
        35.0 * pow(r_Az, 4.0) -
            30.0 * pow(r_Az, 2.0) * rad_sq +
            3.0 * pow(rad_sq, 2.0)
    ) / 8.0;
  }
  else if (m == -1) {
    return sqrt(2.5) * (7.0 * pow(r_Az, 2.0) -
        3.0 *  (pow(r_Az, 2.0) + pow(r_Ay, 2.0) + pow(r_Ax, 2.0)))
        * r_Ay * r_Az / 2.0;
  }
  else if (m == -2) {
    return sqrt(5.0) * (7.0 * pow(r_Az, 2.0) -
        (pow(r_Az, 2.0) + pow(r_Ay, 2.0) + pow(r_Ax, 2.0)))
        * r_Ax * r_Ay / 2.0;
  }
  else if (m == -3) {
    return sqrt(35.0 / 2.0) * (3.0 * pow(r_Ax, 2.0) - pow(r_Ay, 2.0)) * r_Ay * r_Az / 2.0;
  }
  else if (m == -4) {
    return sqrt(35.0) * (pow(r_Ax, 2.0) - pow(r_Ay, 2.0)) * r_Ax * r_Ay / 2.0;
  }
  else {
    assert(0);
  }
  assert (0);
  return 0.;
}
