# solve INS in channel, heat conduction on outer edges w/ fixed temperature

[GlobalParams]
  num_groups = 4 # not used, but makes moltres happy
  num_precursor_groups = 6 # also not used
  use_exp_form = false
  group_fluxes = 'group1 group2 group3 group4' # still not used
  temperature = temp
  sss2_input = true
  pre_concs = 'pre1 pre2 pre3 pre4 pre5 pre6'
  account_delayed = false # not used too
  integrate_p_by_parts = false
  gravity = '0 -981.0 0.0' # cm s^-2
  coord_type = XYZ
[]



[Mesh]
  file = '../2dTiny.msh'
[]
[Variables]
  [./temp]
    family = LAGRANGE
    order = SECOND
    initial_condition = 900 # inlet temperature
    scaling = 1e-4
  [../]
[]

[AuxVariables]
  [./deltaT]
    family = LAGRANGE
    order = SECOND
    block = 'fuel'
  [../]
[]

[AuxKernels]
  [./deltaTCalc]
    type =  ConstantDifferenceAux
    variable = deltaT
    compareVar = temp
    constant = 935 # hopefully average temperature?
    block = 'fuel'
  [../]
[]

[Kernels]
  [./tempTimeDeriv]
    type = MatINSTemperatureTimeDerivative
    variable = temp
  [../]
  [./tempAdvectionDiffusion]
    type = MatDiffusion
    variable = temp
    D_name = 'k'
  [../]
[]

[BCs]


  # inlet temperature
  [./fuelInletTemp]
    type = DirichletBC
    boundary = 'fuelBottom'
    variable = temp
    value = 900.0
  [../]


  # heated graphite on outer edges
  [./heatTheEdges]
    type = DirichletBC
    boundary = moderBoundary
    variable = temp
    value = 970.0
  [../]

  # bottom of graphite held at inlet temperature
  [./coolGraphBottom]
    type = DirichletBC
    boundary = moderBottom
    variable = temp
    value = 900.0
  [../]

[]

[Materials]
  [./fuel]
    type = GenericMoltresMaterial
    prop_names = 'mu              alpha        cp      k'
    prop_values = '8.28495E-05    2.124E-04    1967    0.0553'
    property_tables_root = '../../../property_file_dir/serpMoserChannelFLiBe/B14group_fuel_'
    block = 'fuel'
    interp_type = 'spline'
  [../]
  [./rho_fuel]
    type = DerivativeParsedMaterial
    f_name = rho
    function = '2.146e-3 * exp(-1.8 * 1.18e-4 * (temp - 922))'
    args = 'temp'
    derivative_order = 1
    block = 'fuel'
  [../]
  [./moder]
    type = GenericMoltresMaterial
    property_tables_root = '../../../property_file_dir/serpMoserChannelFLiBe/B14group_moder_'
    interp_type = 'spline'
    prop_names = 'k cp'
    prop_values = '.312 1760' # Cammi 2011 at 908 K
    block = 'moder'
  [../]
  [./rho_moder]
    type = DerivativeParsedMaterial
    f_name = rho
    function = '1.86e-3 * exp(-1.8 * 1.0e-5 * (temp - 922))'
    args = 'temp'
    derivative_order = 1
    block = 'moder'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  [../]
[]

[Executioner]
  # run for at least 500 seconds => ~10 transit times
  type = Transient
  num_steps = 12500
  petsc_options = '-snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu   NONZERO       1e-10'
  nl_rel_tol = 1e-8
  nl_max_its = 20
  l_tol = 1e-6
  l_max_its = 500
  dtmin = 1e-5
  [./TimeStepper]
  dt = 0.02 # Co ~= 0.4
    type = IterationAdaptiveDT
    dt = 1e-3
    cutback_factor = 0.4
    growth_factor = 1.2
    optimal_iterations = 20
  [../]

[]


[Outputs]
  print_perf_log = true
  print_linear_residuals = true
  [./exodus]
    type = Exodus
    file_base = 'fluid'
    execute_on = 'timestep_end'
  [../]
[]
