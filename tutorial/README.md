# Moltres Tutorial

## Intro

This tutorial for moltres will take you through all the steps required to start doing multiphysics analysis on nuclear reactors
with drifting delayed neutron precursors, all the way from group constant generation to postprocessing. In the end, a fully functioning
model of ORNL's molten salt reactor experiment will be ready. The 3D model should be able to be solved in inverse power iteration mode
on a modern desktop computer with over <fill me in> GB of RAM.

Through this tutorial, the tools Serpent 2, PyNE, git, and yt will be used. Group constants could easily be generated in other codes,
but this example utilizes Serpent.  PyNE will be used to parse Serpent output easily.

This tutorial assumes familiarity with some basic reactor physics, and PDEs. For the uninitiated nuclear engineer, a good explanation of group constants can be found in
Duderstadt and Hamilton's chapter on multigroup diffusion theory. More background info will be provided as the tutorial progresses.

