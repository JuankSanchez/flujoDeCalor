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
ExecStep $xv_path/bin/xsim fsm_mem_celdas_tb_behav -key {Behavioral:sim_3:Functional:fsm_mem_celdas_tb} -tclbatch fsm_mem_celdas_tb.tcl -log simulate.log
