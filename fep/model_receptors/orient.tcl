package require autopsf
package require solvate
package require autoionize
package require Orient

namespace import Orient::orient

mol load pdb junv_v212.pdb

set sel [atomselect top "all"]
set I [draw principalaxes $sel]

set A [orient $sel [lindex $I 2] {0 0 1}]
$sel move $A
set I [draw principalaxes $sel]

set A [orient $sel [lindex $I 2] {0 1 0}]
$sel move $A
set I [draw principalaxes $sel]

$sel writepdb oriented.pdb

