static unsigned int idx(unsigned int x,unsigned int y,unsigned int stride){
	return y * stride + x;
}

__kernel void calculo_calor(
		__global float * current,
       __global float * next,
       __global bool * borders)
{
	int ITERATIONS = 100;
	float value;
	int x = get_global_id(0);
	int y = get_global_id(1);
	int unsigned N = get_global_size(0);
	int p = y*N+x,iteration=0;

	for(iteration; iteration<ITERATIONS; iteration++){
		if(borders[p]) {
			value=current[p];
		}else{
			value = (
				current[idx(x, y-1, N)] +
                      		current[idx(x-1, y, N)] +
                      		current[idx(x+1, y, N)] +
                      		current[idx(x, y+1, N)]
			)/4.0f;
		}
		barrier(CLK_LOCAL_MEM_FENCE);
		current[p] = value;
		barrier(CLK_LOCAL_MEM_FENCE);
	}
}
