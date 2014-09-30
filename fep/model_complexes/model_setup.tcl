package require autopsf
package require solvate
package require autoionize
package require Orient

namespace import Orient::orient

mol load pdb macv.pdb

set sel [atomselect top "all"]
set I [draw principalaxes $sel]

set A [orient $sel [lindex $I 2] {0 0 1}]
$sel move $A
set I [draw principalaxes $sel]

set A [orient $sel [lindex $I 2] {0 1 0}]
$sel move $A
set I [draw principalaxes $sel]

$sel writepdb oriented.pdb

autopsf oriented.pdb
solvate macv_autopsf.psf macv_autopsf.pdb -o macv_solvate -s WT -minmax {{-45 -45 -45} {45 45 45}}

autoionize -psf macv_solvate.psf -pdb macv_solvate.pdb -o macv_ionized -sc 0.15

