
__kernel void calculo_calor(
		__global float * current,
       __global bool * bordes,
       int N,
       int iteraciones)
{
	float value;
	int p = get_global_id(0);
	while(iteraciones--){
		value = bordes[p]?current[p]:(current[p+1]+current[p-1]+current[p+N]+current[p-N])*0.25;
		barrier(CLK_LOCAL_MEM_FENCE);
		current[p] = value;
		barrier(CLK_LOCAL_MEM_FENCE);
	}
}
