#include "SaltLoopAction.h"

// MOOSE includes
#include "Factory.h"
#include "Parser.h"
#include "Conversion.h"
#include "FEProblem.h"
#include "NonlinearSystemBase.h"

template <>
InputParameters
validParams<SaltLoopAction>()
{
  InputParameters params = validParams<Action>();
  params.addRequiredCoupledVar<NonlinearVariableName>("temperature",
                                                      "Name of temperature variable");
  params.addRequiredParam<std::string>("pre_name_base", "base name of DNP concentration variables");
  params.addRequiredParam<int>("num_pre_groups", "number of DNP concentration variables");
  params.addParam<Real>("temp_scaling", "The amount by which to scale the temperature variable.");
  params.addRequiredParam<bool>(
      "use_exp_form", "Whether concentrations should be in an exponential/logarithmic format.");
  params.addRequiredParam<BoundaryName>("inlet", "Boundary where loop enters core");
  params.addRequiredParam<BoundaryName>("outlet", "Boundary where core feeds loop");
  params.addRequiredParam<std::string>(
      "object_suffix", "", "an optional suffix to avoid name collisions");
  return params;
}

SaltLoopAction::SaltLoopAction(const InputParameters & params)
  : Action(params),
    _outlet_boundary(getParam<BoundaryName>("outlet")),
    _inlet_boundary(getParam<BoundaryName>("inlet")),
    _temperature(getParam<NonlinearVariableName>("temperature")),
    _pre_name_base(getParam<std::string>("pre_name_base")),
    _num_pre_groups(getParam<int>("num_pre_groups")),
    _object_suffix(getParam<std::string>("object_suffix"))
{
  // loop through all given DNP group variable strings and add them to a
  // vector of strings
  std::vector<std::string> _prec_variables(0); // init empty
  mooseAssert(_num_pre_groups >= 1);
  for (int i = 1; i <= _num_pre_groups; ++i)
  {
    _prec_variables.push_back(_pre_name_base + Moose::stringify(i));
  }

  // to make an input file for the subapp, set aside a file name
  std::string _my_inp_file_name = "loopApp"+_object_prefix + ".i";
}

// some variables that exist from FEProblem
// _multi_apps
// _transient_multi_apps
// _transfers


void
SaltLoopAction::act()
{
  if (_current_task == "add_multiapp")
  {
    // set up multiapp params
    InputParameters loop_params = _factory.getValidParams("TransientMultiApp");
    loop_params.set<MooseEnum>("app_type") = "MoltresApp";
    loop_params.set<MultiMooseEnum>("execute_on", "timestep_begin");
    // hopefully will not need multiapp positions, uncomment if they're
    // really, really needed
    // loop_params.set<std::vector<Point>>("positions") = {Point()};

    // add the loop multiapp
    _problem->addMultiApp("MoltresApp", "loopApp"+_object_prefix, multiAppParams);

    // need to do this stuff to the multiapp
    // add precursor variables (w/ DG kernels, through PreAction)
    // add the interface kernel for the HX
    // add left and right BCs
    // add generatedMesh
    // copy fuel material into this app
    // loopEndTemp and coreEndTemp get set elsewhere
    // copy executioner settings from main into this one
    // copy any functions into this one
    // copy any controls into this one
    // set preconditioning to type=SMP, full=true
    // outputs
  }

  if (_current_task == "add_postprocessor")
  {
    for (std::vector<std::string>::iterator it = _prec_variables.begin();
         it != _prec_variables.end();
         ++it)
    {
      // main App receiver of data
      {
        InputParameters p = _factory.getValidParams("Receiver");
        std::vector<std::string> exeOpt(0); // when to execute Receiver from loop
        exeOpt.push_back("initial");
        exeOpt.push_back("timestep_begin");
        p.set<std::vector<std::string>>("execute_on", exeOpt);
        _problem->AddPostprocessor("Receiver", "loopReceiver" + _object_suffix, p);
      }

      // sub app receiver of data
      {
          // yet to do stuff
      }

      // add SideAverageValues for mainapp outlet
      {
        InputParameters p = _factory.getValidParams("SideAverageValue");
      }

      // add SideAverageValues for subapp outlet
      {
        // yet to do stuff
      }
    }
  }

  if (_current_task == "add_bc")
  {
    for (std::vector<std::string>::iterator it = _prec_variables.begin();
         it != _prec_variables.end();
         ++it)
    {
      // add the postprocessor-set dirichlet value in main problem
      {}

      // add the postprocessor-set dirichlet value in sub app
      {
      }
    }
  }
}
