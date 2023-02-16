#ifndef GBASIS_CUDA_INCLUDE_BASIS_TO_GPU_H_
#define GBASIS_CUDA_INCLUDE_BASIS_TO_GPU_H_

#include "contracted_shell.h"
// Stores constant memory for the NVIDIA GPU.

extern __constant__ double g_constant_basis[7500];

namespace gbasis {
/**
 * Puts molecular basis into constant memory of the NVIDIA GPU as a straight array. Useful when one
 *  just wants to iterate through the array in a row fashion, e.g. evaluating electron density/contraction array.
 *  The downside is the inability to jump to any contracted shell.
 *
 * @param[in] basis The molecular basis set information as a collection of contracted shells.
 * @note Every basis-set information is casted to a double.
 * @note Storing it as a decontracted basis, i.e. every contraction shell is segmented, i.e. has only one angular
 *       momentum associated with it, is that it reduced the amount of for-loops inside the cuda function. This
 *       is particularly useful when doing integration like electrostatic potential.
 * @note The following explains how memory is placed is with constant memory.
 *          M := numb_segmented_shell inside contracted shell.
 *          K := Number of primitives per Mth segmented shell.
 *
 *          | numb_contracted_shells | 4 byte blank | atom_coord_x | atom_coord_y | atom_coord_z | M | 4B Blank | K | ...
 *          4B Blank | exponent_1 | ... | exponent_K | angmom_1 | coeff_11 | ... | coeff_K1 | ... | angmom_M | coeff_1M |..
 *          coeff_KM | K2 | 4B Blank | exponent_2 | same pattern repeat...
 *
 *          Segmented Basis mode:
 *  | numb_contracted_shells | 4 byte blank | atom_coord_x | atom_coord_y | atom_coord_z | K | ...
 *     4B Blank | angmom_1 | exponent_1 | ... | exponent_K |  coeff_1 | ... | coeff_K | atom_coord_x | atom_coord_y |
 *     atom_coord_z |  K2 | 4B Blank |  angmom_2 | exponent_1 | ... | exponent_K2 | coeff_1 | same pattern repeat...
 */
__host__ void add_mol_basis_to_constant_memory_array(
    const gbasis::MolecularBasis& basis, bool do_segmented_basis = false, const bool disp = false);

/**
 * Puts molecular basis into constant memory of the NVIDIA GPU as a straight array with consideration
 *  to the fact that one needs to be able to jump to any contracted shell. This puts less strain
 *  under the registers
 *  .
 * @param[in] basis The molecular basis set information as a collection of contracted shells.
 * @note The following explains how memory is placed within constant memory.
 *       N := number of contracted shells.
 *       M_i := numb_segmented_shell inside ith contracted shell where 1 <= i <= N.
 *       K_i := Number of primitives per ith segmented shell where 1 <= i <= N.
*         Number of primitives is consistent inside a contracted hell.
 *  | N | 4 byte blank | M_1 | 4 byte blank | K_1 | 4 byte blank | .... | M_N | 4B | K_N | 4B
 *      | *atom_coord_x | atom_coord_y | atom_coord_z |
 *
 *  The first series of integers from N to K_N, is all the information you need to jump to any contracted shell.
 *      To reach *atom_coord_x, it is precisely the index 1 + 2 * N.
 *
 */
__host__ void add_mol_basis_to_constant_memory_array_access(gbasis::MolecularBasis basis);
}
#endif //GBASIS_CUDA_INCLUDE_BASIS_TO_GPU_H_
