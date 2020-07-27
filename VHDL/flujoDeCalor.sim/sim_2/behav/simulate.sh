#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2017.1"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim matrizDeCarlor3x3v1_tb_behav -key {Behavioral:sim_2:Functional:matrizDeCarlor3x3v1_tb} -tclbatch matrizDeCarlor3x3v1_tb.tcl -view /home/juank/flujoDeCalor/matrizDeCarlor3x3v1_tb_behav.wcfg -log simulate.log
