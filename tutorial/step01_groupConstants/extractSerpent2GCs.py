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

<<<<<<< HEAD
def makePropertiesDir(inmats, outdir, filebase, mapFile, unimapFile, serp1=False, fromMain=False):
    """ Takes in a mapping from branch names to material temperatures,
    then makes a properties directory.
    Serp1 means that the group transfer matrix is transposed."""
=======
def makePropertiesFromSerpentOutput(outfiles, outdir, basename, serp1=False, useB1=False, uni2matname=None, fromMain = False, usen2n=True):
    """ Takes serpent 2 output from a _res.m file, and translates 
    into moltres-compatible neutronics parameters.

    Args:
        outfile -- serpent output, *_res.m. Should have group constants
        outdir  -- the moltres property dir to be created
        basename-- base file name for moltres. This goes in the moltres input file.

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
>>>>>>> daaa08b... trying to write parser to be general.. gettin close

    if serp1:
        raise NotImplementedError("C'mon, just get serpent 2!")

<<<<<<< HEAD
    if not os.path.isdir(outdir):
        os.mkdir(outdir)
    print("Making properties for materials:")
    print(inmats)
    coeList = dict([(mat,sss.parse_coe(mat+'.coe')) for mat in inmats])

    # the constants moltres looks for:
    goodStuff = ['BETA_EFF','CHI','DECAY_CONSTANT','DIFF_COEF','FISSE','GTRANSFXS','NSF','RECIPVEL','REMXS']
    goodMap   = dict([(thing, 'INF_'+thing) for thing in goodStuff])

    # the name for the group transfer XS matrix is different in serpent
    # and moltres, so this gets fixed:
    goodMap['GTRANSFXS'] = 'INF_SP0' # scattering + production in 0 legendre moment
    goodMap['BETA_EFF'] = 'BETA_EFF'
    goodMap['CHI'] = 'INF_CHIP' # include production. chip, chit, or chid???
    goodMap['DECAY_CONSTANT']='LAMBDA'
    goodMap['RECIPVEL'] = 'INF_INVV'
    goodMap['DIFF_COEF'] = 'INF_DIFFCOEF'
    goodMap['FISSE'] = 'INF_KAPPA'

    # map material names to universe names from serpent
    with open(unimapFile) as fh:
        uniMap = []
        for line in fh:
            uniMap.append(tuple(line.split()))
    # this now maps material names to serpent universes
    uniMap = dict(uniMap)

    branch2TempMapping = open(mapFile)
    for line in branch2TempMapping:

        item, temp = tuple(line.split())
        for mat in inmats:
            if mat in item:
                currentMat = mat
                break
        else:
            print('Considered materials: {}'.format(inmats))
            raise Exception('Couldnt find a material corresponding to branch {}'.format(item))

        for coefficient in goodStuff:
            with open(outdir+'/'+filebase+currentMat+'_'+coefficient, 'a') as fh:
                strData = coeList[currentMat][1][uniMap[currentMat]][item]["rod0"][goodMap[coefficient]]
                if coefficient == 'DECAY_CONSTANT' or coefficient == 'BETA_EFF':
                    # some additional formatting is needed here
                    strData = strData[1:7]
                strData = ' '.join([str(dat) for dat in strData]) if isinstance(strData,list) else strData
                fh.write(str(temp)+' '+strData)
                fh.write('\n')

    return None

=======
    # try all the i/o first
    try:
        os.mkdir(outdir)
    except IOError as err:
        print("Looks like some outdir doesn't exist, or you don't have the right")
        print("permissions.")
        print( err )
        quit()

    # list of (mat, temp, output dictionary) for serpent results at each temperature
    dictTempList = []

    nUni = None

    # loop through input files
    for outfile in outfiles:

        infile = open(outfile, 'r')

        # fix me
        isFromBranching = 

        if not isFromBranching:
            
            # if not from branching, the temperature of the material must be read in:
            # following Mr. Lindsay's original form, it should be in the file name
            temp = [ch for ch in outfile if ch.isdigit()]
            temp = float(temp)
            materL= [mat for mat in uni2matname.keys() if mat in outfile]
            if len(materL) != 1:
                raise Exception("couldnt read mat name from outfile {}".format(outfile))
            mater = materL[0]
            print("Temperature of material {} was found to be {} K.".format())

            # load the pyne-parsed dictionary if the sss out isn't from branching
            sssOut = sss.parse_res(infile)
            infile.close()

            dictTempList.append( (mater,temp,sssOut) )
        else:
            # call the new pyne reader
            sssOut = sss.parse_bran(infile)
            infile.close()


        # get materials for each one
        for mat in uni2matname.values():


    # whether to use B1
    # this should only be used if a unit cell was done in serpent
    prefix = 'INF_' if not useB1 else 'B1_'

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
    # FYI, the other scattering matrices, like SP1, S5, etc, are the higher order legendre moment scattering
    
    # now, just loop through the good stuff, and print them in moltres-compatible files
    matname2uni = {k,v for v,k in uni2matname.items()}
    for goodThing in goodStuff:

        for mat in uni2matname.values():

            # get index of mat, ie order it appeared in output file:
            matIndex=sssOut['GC_UNIVERSE_NAME'].index(matname2uni[mat])

            with open(outdir+'/'+basename+'_'+mat+'_'+goodThing+'.txt', 'w') as fh:

                # find temperatures
                for temp, paramDict in zip(temperatures, dictTempList):






    # might as well return something, bc why not (eg debug)
    return sssOut
>>>>>>> daaa08b... trying to write parser to be general.. gettin close

if __name__ == '__main__':

    # make it act like a nice little terminal program
    parser = argparse.ArgumentParser(description='Extracts Serpent 2 group constants, and puts them in a directory suitable for moltres.')
    parser.add_argument('outDir', metavar='o', type=str, nargs=1, help='name of directory to write properties to.')
    parser.add_argument('fileBase', metavar='f', type=str, nargs=1, help='File base name to give moltres')
    parser.add_argument('mapFile' , metavar='b', type=str, nargs=1, help='File that maps branches to temperatures')
    parser.add_argument('universeMap', metavar='u', type=str, nargs=1, help='File that maps material names to serpent universe')
    parser.add_argument('materials', metavar='m', type=str, nargs='+', help='list of moltres material names')
    parser.add_argument('--serp1', dest='serp1', action='store_true', help='use this flag for serpent 1 group transfer matrices')
    parser.set_defaults(serp1=False)

    args = parser.parse_args()

<<<<<<< HEAD
    # these are unpacked, so it fails if they werent passed to the script
    inmats = args.materials
=======
    if len(args.serpentOutputFile)>1 or len(args.outDir)>1:
        raise NotImplementedError("Automatically making several property dirs in the future may be supported, but not now.")

    # these are unpacked,so it fails if they werent passed to the script
    infile = args.serpentOutputFile 
>>>>>>> daaa08b... trying to write parser to be general.. gettin close
    outdir = args.outDir[0]
    fileBase = args.fileBase[0]
    mapfile = args.mapFile[0]
    unimapfile = args.universeMap[0]

<<<<<<< HEAD
    makePropertiesDir(inmats, outdir, fileBase, mapfile,unimapfile, serp1=args.serp1, fromMain = True)
=======

    makePropertiesFromSerpentOutput(infile, outdir, serp1=args.serp1, fromMain = True)
>>>>>>> daaa08b... trying to write parser to be general.. gettin close

    print("Successfully made property files in directory {}.".format(outdir))
