#!/usr/bin/env python3
# This script extracts group constants from Serpent 2. It should be able to do all of the work, no
# need to specify how many energy groups, or anything like that. Also, this could be imported into
# other python scripts if needed, maybe for parametric studies.

import os
import numpy as np
import argparse
import subprocess

try:
    from pyne import serpent as sss
except ImportError as err:
    print("Sorry, looks like PyNE wasn't able to be loaded. Please check your installation.")
    print("Maybe you only have it for python 2.")
    print( err )
    quit()

def makePropertiesFromSerpentOutput(outfile, outdir, serp1=False, useB1=False, uni2matname=None, fromMain = False, usen2n=True):
    """ Takes serpent 2 output from a _res.m file, and translates 
    into moltres-compatible neutronics parameters.

    Args:
        outfile -- serpent output, *_res.m. Should have group constants
        outdir  -- the moltres property dir to be created

    Kwargs:
        serp1   -- bool. if true, assumes that group scattering matrix is transposed.
                    defaults to false.

        useB1   -- bool. if true, uses B1-generated group constants. These are a
                    spectrum-adjusted technique for making infinite lattice group
                    constants work for whole-core.
                    defaults to false.

        uni2matname -- dict. set this if you're running this function from python, not terminal.
                        makes human-readable input for moltres. Otherwise it would be hard to
                        tell which material is which. Maps a universe name in string form to
                        the new name. e.g. {'1':'fuel','2':'moder'}

        fromMain -- don't use this. for this script's use.

        usen2n -- bool. defaults to true. Whether to include scattering production reactions
                        like (n,2n) in the group scattering matrix.



    Returns:
        tuple[2]-- number of groups found (int)
    """

    if serp1:
        raise NotImplementedError("please have someone eg gavin add this")

    # try all the i/o first
    try:
        infile = open(outfile, 'r')
        os.mkdir(outdir)
    except IOError as err:
        print("Looks like some args don't exist, or you don't have the right")
        print("permissions.")
        print( err )
        quit()

    # a dictionary of serpent output:
    sssOut = sss.parse_res(infile)

    # whether to use B1
    # this should only be used if a unit cell was done in serpent
    prefix = 'INF_' if not useB1 else 'B1_'

    # count how many universes had GCs generated:
    nUni = len(sssOut['GC_UNIVERSE_NAME'])

    # now, map universe names to moltres material names, if desired.
    # this just makes the output prettier.
    if uni2matname == None and fromMain:
        uni2matname = dict.fromkeys(sssOut['GC_UNIVERSE_NAME'], None)
        for uni in uni2matname.keys():
            matName= input("Please give a material name for universe {}, then hit enter:\n".format(uni))
            uni2matname[uni] = matName
    elif unit2matname == None:
        print("See pydoc <thisfile>.makePropertiesFromSerpentOutput")
        raise Exception("If you're running this as a function, set a uni2matname map through the kwargs.")

    # now, look through it for the good stuff (GCs):
    scatMat = 'SP0' if usen2n else 'P0'
    goodStuff = ['REMXS', 'FISSXS', 'NSF', 'FISSE', 'DIFFCOEF', 'RECIPVEL', scatMat]
    # by the way, NSF -> nu * Sigma_{fission}
    





    infile.close()

    # might as well return something, bc why not (eg debug)
    return sssOut

if __name__ == '__main__':

    # make it act like a nice little terminal program
    parser = argparse.ArgumentParser(description='Extracts Serpent 2 group constants, and puts them in a directory suitable for moltres.')
    parser.add_argument('serpentOutputFile', metavar='i', type=str, nargs='+', help='string describing a path to the serp output')
    parser.add_argument('outDir', metavar='o', type=str, nargs='+', help='name of directory to write properties to.')
    parser.add_argument('--serp1', dest='serp1', action='store_true', help='use this flag for serpent 1 group transfer matrices')
    parser.set_defaults(serp1=False)

    args = parser.parse_args()

    if len(args.serpentOutputFile)>1 or len(args.outDir)>1:
        raise NotImplementedError("Automatically making several property dirs in the future may be supported, but not now.")

    # these are unpacked,so it fails if they werent passed to the script
    infile = args.serpentOutputFile[0]
    outdir = args.outDir[0]

    makePropertiesFromSerpentOutput(infile, outdir, serp1=args.serp1, fromMain = True)

    print("Successfully made property files in directory {}.".format(outdir))
