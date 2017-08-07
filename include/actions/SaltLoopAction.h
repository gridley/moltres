#ifndef SALTLOOPACTION_H
#define SALTLOOPACTION_H

#include "Action.h"

class SaltLoopAction : public Action
{
public:
  SaltLoopAction(const InputParameters & params);

  virtual void act();

protected:
};

template <>
InputParameters validParams<SaltLoopAction>();

#endif // SALTLOOPACTION_H
