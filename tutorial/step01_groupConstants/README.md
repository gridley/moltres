## Group Constants

Here, group constants are taken from example Serpent output using PyNE. These will be used to generate a properties directory, which
can be used by moltres. See extractSerpent2GCs.py for more.

Moltres is *not* a spatially homogenized diffusion code. MOOSE is made for running, **big**, **intense** problems, using modern HPC.
Because there is no desire to homogenize spatially here, the materials that the user would like used in moltres should each fill their
own infinite universe. Then, this universe should have its group constants generated using the "set gcu <material universe numbers>".

It's important that universe 0, the main universe, is not included. Serpent takes tallies for group constants in the first universe
it identifies, so including 0 means that no further universes will be included in GC generation. (please double check this on the serpent
forum).
