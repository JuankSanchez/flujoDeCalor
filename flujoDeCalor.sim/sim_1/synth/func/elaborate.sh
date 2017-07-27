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
ExecStep $xv_path/bin/xelab -wto a98be7e6ea464e059e7ebe959c3bf524 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot flujoDeCalor_tb_func_synth xil_defaultlib.flujoDeCalor_tb -log elaborate.log
