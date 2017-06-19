#include "DirichletPostProcessorBC.h"

template <>
InputParameters
validParams<DirichletPostProcessorBC>()
{
  InputParameters params = validParams<NodalBC>();
  params.addRequiredParam<std::string>("postprocessorName","Name of postProc");

  return params;
}

DirichletPostProcessorBC::DirichletPostProcessorBC(const InputParameters & p)
  : NodalBC(p), _value(getParam<std::string>("postprocessorName"))
{
}

Real
DirichletPostProcessorBC::computeQpResidual()
{
  return _u[_qp] - this->getPostprocessorValue(_value);
}
