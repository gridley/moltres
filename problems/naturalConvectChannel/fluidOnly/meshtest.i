# solve INS in channel, heat conduction on outer edges w/ fixed temperature
[Mesh]
  file = '../unitCell.msh'
[]

[MeshModifiers]
  [./bottom_left]
    type = AddExtraNodeset
    new_boundary = corner
    coord = '0 0 0'
  [../]
[]

[GlobalParams]
  integrate_p_by_parts = false
  gravity = '0 0 -981.0' # cm s^-2
  coord_type = XYZ
[]

[Variables]
  [./ux]
    family = LAGRANGE
    order = SECOND
    block = 'fuel'
  [../]
  [./uy]
    family = LAGRANGE
    order = SECOND
    block = 'fuel'
  [../]
  [./uz]
    family = LAGRANGE
    order = SECOND
    block = 'fuel'
  [../]
  [./p]
    family = LAGRANGE
    order = FIRST
    block = 'fuel'
  [../]
  [./temp]
    family = LAGRANGE
    order = FIRST
    initial_condition = 900 # inlet temperature
    scaling = 1e-4
  [../]
[]

[AuxVariables]
  [./deltaT]
    family = LAGRANGE
    order = FIRST
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
  [./mass]
    type = INSMass
    variable = p
    u = ux
    v = uy
    w = uz
    p = p
    block = 'fuel'
  [../]
  [./x_time_deriv]
    type = INSMomentumTimeDerivative
    variable = ux
    block = 'fuel'
  [../]
  [./y_time_deriv]
    type = INSMomentumTimeDerivative
    variable = uy
    block = 'fuel'
  [../]
  [./z_time_deriv]
    type = INSMomentumTimeDerivative
    variable = uz
    block = 'fuel'
  [../]
  [./x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = ux
    u = ux
    v = uy
    p = p
    component = 0
    block = 'fuel'
  [../]
  [./y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = uy
    u = ux
    v = uy
    p = p
    component = 1
    block = 'fuel'
  [../]
  [./z_momentum_space]
    type = INSMomentumLaplaceForm
    variable = uz
    u = ux
    v = uy
    w = uz
    p = p
    component = 2
    block = 'fuel'
  [../]
  [./tempTimeDeriv]
    type = MatINSTemperatureTimeDerivative
    variable = temp
  [../]
  [./tempAdvectionDiffusion]
    type = INSTemperature
    variable = temp
    u = ux
    v = uy
    w = uz
    block = 'fuel'
  [../]
  [./buoyancy_z]
    # only a uz kernel for Boussinesq is needed since gravity is parallel to z
    type = INSBoussinesqBodyForce
    variable = uz
    dT = deltaT
    component = 2
    temperature = temp
    block = 'fuel'
  [../]
[]

[BCs]

  # no slip condition
  [./ux_dirichlet]
    type = DirichletBC
    boundary = 'fuelBoundary fuelBottom'
    variable = ux
    value = 0
  [../]
  [./uy_dirichlet]
    type = DirichletBC
    boundary = 'fuelBoundary fuelBottom'
    variable = uy
    value = 0
  [../]
  [./uz_dirichlet]
    type = DirichletBC
    boundary = 'fuelBoundary'
    variable = uz
    value = 0
  [../]

  # pin pressure to zero at center of channel bottom
  [./p_zero]
    type = DirichletBC
    boundary = corner
    variable = p
    value = 0
  [../]

  # inlet has some velocity
  [./uz_diri_inlet]
    type = DirichletBC
    boundary = 'fuelBottom'
    variable = uz
    value = 9.0 # cm/s
  [../]

  # no BC BC at the top of the channel
  [./uy_out]
    type = INSMomentumNoBCBCLaplaceForm
    boundary = 'fuelTop'
    variable = uy
    u = ux
    v = uy
    w = uz
    p = p
    component = 1
  [../]
  [./uz_out]
    type = INSMomentumNoBCBCLaplaceForm
    boundary = 'fuelTop'
    variable = uz
    u = ux
    v = uy
    w = uz
    p = p
    component = 2
  [../]

  # heated graphite on outer edges
  [./heatTheEdges]
    type = DirichletBC
    boundary = moderBoundary
    variable = temp
  [../]
[]

[Materials]
[]

[Executioner]
  # run for at least 500 seconds => ~10 transit times
  type = Transient
  num_steps = 12500
  dt = 0.04 # Co ~= 0.4
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_test_display'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu   NONZERO       1e-10'
  # petsc_options_iname = '-snes_type'
  # petsc_options_value = 'test'
   line_search = 'none'
  nl_rel_tol = 1e-12
  nl_max_its = 20
  l_tol = 1e-6
  l_max_its = 500
  dtmin = 1e-5
[]


[Outputs]
[]
