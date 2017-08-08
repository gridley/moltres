#ifndef SALTLOOPACTION_H
#define SALTLOOPACTION_H

#include "Action.h"

class SaltLoopAction : public Action
{
public:
  SaltLoopAction(const InputParameters & params);

  virtual void act();

protected:
  std::vector<NonlinearVariableName> _prec_variables;
  std::string _my_inp_file_name;
};

template <>
InputParameters validParams<SaltLoopAction>();

#endif // SALTLOOPACTION_H
