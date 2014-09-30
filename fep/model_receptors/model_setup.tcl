package require autopsf
package require solvate
package require autoionize
package require Orient

namespace import Orient::orient

mol load pdb oriented.pdb

autopsf oriented.pdb

solvate oriented_autopsf.psf oriented_autopsf.pdb -o solvate -s WT -minmax {{-45 -45 -45} {45 45 45}}

autoionize -psf solvate.psf -pdb solvate.pdb -o ionized -sc 0.15

