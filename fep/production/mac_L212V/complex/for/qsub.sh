#!/bin/csh

# Create Working Directory
set WDIR = $RESULTS/fep_macv_L212V/complex/for
set FDIR = `pwd`

if ( -d $WDIR ) then
  rm -r $WDIR
endif

mkdir -p $WDIR

if ( ! -d $WDIR ) then
  echo $WDIR not created
  exit
endif

cd $WDIR

# Copy Data and Config Files
cp $FDIR/* .

set MPIRUN = /lustre/work/apps/openmpi/bin/mpirun
set NAMD2  = /lustre/work/apps/NAMD_2.9b3_Source/Linux-x86_64-icc/namd2

echo '#\!/bin/bash' > run.q
echo '#$ -cwd' >> run.q
echo '#$ -V' >> run.q
echo '#$ -S /bin/bash' >> run.q
echo '#$ -N fep_pro' >> run.q
echo '#$ -j y' >> run.q
echo '#$ -o fep.log' >> run.q
echo '#$ -e fep.err' >> run.q
echo '#$ -q normal' >> run.q
echo '#$ -pe fill 60' >> run.q
echo '#$ -P hrothgar\n' >> run.q

echo '# Command to run\n' >> run.q
echo 'unset SGE_ROOT\n' >> run.q

echo 'ldd /lustre/work/apps/NAMD_2.9b3_Source/Linux-x86_64-icc/namd2\n' >> run.q

echo  $MPIRUN -np 60 -machinefile 'machinefile.$JOB_ID' $NAMD2 forward-on.namd >> run.q

qsub run.q

