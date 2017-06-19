
#ifndef DIRIPOSTPROCBC_H
#define DIRIPOSTPROCBC_H

#include "NodalBC.h"

class DirichletPostProcessorBC;

template <>
InputParameters validParams<DirichletPostProcessorBC>();

/**
 * Boundary condition of a Dirichlet type
 *
 * This one gets its value set by a scalar postprocessor.
 */
class DirichletPostProcessorBC : public NodalBC
{
public:
  DirichletPostProcessorBC(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  /// The value for this BC
  const std::string & _value;
};

#endif /* DIRICHLETBC_H */
