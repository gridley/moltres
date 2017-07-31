# solve simple diffusion problem on the mesh to make sure BCs work as expected
#
[Mesh]
  file = unitCell.msh
[]

[Variables]
  [./diffused]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff]
   type = MatDiffusion
   variable = diffused
  [../]
[]

[BCs]
  [./bottom]
    type = DirichletBC
    variable = diffused
    boundary = 'fuelBottom moderBottom moderBoundary'
    value = 1
  [../]

  [./top]
    type = DirichletBC
    variable = diffused
    boundary = 'fuelTop moderTop'
    value = 0
  [../]
[]

[Preconditioning]
  [./Newton_SMP]
    type = SMP
    full = true
  [../]
[]


[Materials]
  [./fuel]
    type = GenericConstantMaterial
    prop_names = 'D'
    prop_values = '10.0'
    block = 'fuel'
  [../]
  [./moder]
    type = GenericConstantMaterial
    prop_names = 'D'
    prop_values = '1.0'
    block = 'moder'
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]


