#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#include <stdio.h>
#include <stdlib.h>
#include <CL/cl.h> 
#include <math.h>
#include <time.h>
#include <sys/time.h>
#include "mensajes.h"
//#include "funciones.h"

#define MAX_SOURCE_SIZE 128000

int N 							= 20;
int ITERACIONES 				= 50;
static const float TEMP_BORDE 	= 0.0f;
static const float TEMP_INICIAL	= 0.0f;
static const float TEMP_FUENTE 	= 12.0f;
static const int FUENTE_X 		= 2;
static const int FUENTE_Y 		= 2;

// Calcula la diferencia de tiempo
double timeval_diff(struct timeval *a, struct timeval *b){
  return
    (double)(a->tv_sec + (double)a->tv_usec/1000000) -
    (double)(b->tv_sec + (double)b->tv_usec/1000000);
}

// Inicializacion de la matrix
static void inicializar(float * matrix,bool * bordes) {
     // init
	int p,f,c;

	// seteamos los bordes
	for(f = 0; f < N; ++f) {
		for(c = 0; c < N; ++c) {
			p = f*N+c;
			if (f==0||c==0||c==N-1||f==N-1){
				bordes[p] = true;
				matrix[p] = TEMP_BORDE;
			}else{
				matrix[p] = TEMP_INICIAL;
				bordes[p] = false;
			}
		}
	}

    // colocamos la fuente de calor
	matrix[FUENTE_X+FUENTE_Y*N] = TEMP_FUENTE;
	bordes[FUENTE_X+FUENTE_Y*N] = true;
}

void load_kernel_source(const char *filename, char **src_dst){
    FILE *fp = fopen(filename, "r");
    if(!fp){
        fprintf(stderr, "Failed to load %s.\n", filename);
        exit(1);
    }
    *src_dst = (char*)malloc(MAX_SOURCE_SIZE);
    fread(*src_dst, 1, MAX_SOURCE_SIZE, fp);
    fclose(fp); 
}

// Imprimimos la matriz
static void print_matrix(float * matrix) {
   for (unsigned int f = 0; f < N; ++f) {
        for (unsigned int c = 0; c < N; ++c) {
            printf("%f ",matrix[f*N+c]);
        }
		printf("\n");
   }
}

int main() {

	// SOY EL HOST
	cl_int status;                 // Variable para verificar errores
	cl_uint numPlatform = 0;       // Variable para obtener el numero de plataformas
	cl_uint numDevices = 0;        // Variable para obtener el numero de dispositivos
	size_t globalWorkSize[0];      // Dimension del Kernel 
	cl_uint num_plat = 0;
	cl_event eventKernel,eventBuffer,eventBufferWrite;

   // ------------------------------------
   
   	// Simulation parameters
   	size_t array_size = N * N * sizeof(float);

   	bool *bordes = (bool *)malloc(array_size);
	float *matrix = (float *)malloc(array_size);

	// ------------------------------------

	cl_platform_id *platforms = NULL;
	cl_device_id *devices;
	cl_context context;
	cl_command_queue cmdQueue;
	cl_kernel kernel;
	
	char* programSource;

	// Configurar la platforma - FILMINA 13
	status = clGetPlatformIDs(0, NULL, &numPlatform);
	check_error(status, "clGetPlatformIds");
	platforms = (cl_platform_id*)malloc(numPlatform*sizeof(cl_platform_id));
	status = clGetPlatformIDs(numPlatform, platforms,NULL);
	check_error(status, "clGetPlatformIds");
	PrintPlatInfo(platforms[0], numPlatform, sizeof(cl_platform_id));

	// Configurar el dispositivo - FILMINA 15
	status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, 0, NULL, &numDevices);
	check_error(status, "clGetDeviceIds");
	devices = (cl_device_id*)malloc(numDevices*sizeof(cl_device_id));
	status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, numDevices, devices, NULL);
	check_error(status, "clGetDeviceIds");
	PrintDevInfo(devices[0], numDevices, sizeof(cl_device_id)); 

	// Crear el contexto - FILMINA 19
	context = clCreateContext(NULL,numDevices, devices, NULL, NULL, &status);
	check_error(status, "clCreateContext");

	//Crear la cola - FILMINA 21 + EVENT profile information - FILMINA 2.17
	cmdQueue = clCreateCommandQueue(context, devices[0], CL_QUEUE_PROFILING_ENABLE, &status);
	check_error(status, "clCreateCommandQueue");

	// FILMINA 2.17
	clFinish(cmdQueue);

	//Crear Buffers - FILMINA 27
	cl_mem bufMatrix = clCreateBuffer(context, CL_MEM_READ_WRITE,array_size, NULL, &status);
	cl_mem bufBordes = clCreateBuffer(context, CL_MEM_READ_ONLY,array_size, NULL, &status);
    //cl_mem bufN = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(int), NULL, &status);
    //cl_mem bufIteraciones = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(int), NULL, &status);

	//Crear el programa - FILMINA 37 (cargamos desde un archivo)
	load_kernel_source("matrix.global.cl", &programSource);
	cl_program program = clCreateProgramWithSource(context, 1, (const char**)&programSource,NULL, &status);
	check_error(status, "clCreateProgramWithSource");

	//Compile program - FILMINA 34
	status = clBuildProgram(program, numDevices, devices, NULL, NULL, NULL);
	if (status == -11) {
	  fprintf(stderr, "Non-successful return code %d for clBuildProgram: CL_BUILD_PROGRAM_FAILURE \nLOG:\n",status); 
	  size_t log_size;
	  clGetProgramBuildInfo(program, devices[0], CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size); // Determine the size of the log
	  char *log = (char *) malloc(log_size); // Allocate memory for the log
	  clGetProgramBuildInfo(program, devices[0], CL_PROGRAM_BUILD_LOG, log_size, log, NULL); //Get the log
	  printf("%s\nExiting\n", log); //Print log
	  exit(1);
	} else {
	  check_error(status, "clBuildProgram");
	}

	// Crear Kernel - FILMINA 42 / 45
	kernel = clCreateKernel(program, "calculo_calor", &status);
	check_error(status, "clCreateKernel");

	// Asociar rgumentos al kernel - FILMINA 47
	status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufMatrix);
	check_error(status, "clSetKernelArg_0_");
	status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &bufBordes);
	check_error(status, "clSetKernelArg_1_");
	status = clSetKernelArg(kernel, 2, sizeof(int), &N);
	check_error(status, "clSetKernelArg_2_");
	status = clSetKernelArg(kernel, 3, sizeof(int), &ITERACIONES);
	check_error(status, "clSetKernelArg_3_");

	globalWorkSize[0] = N*N;
	
	int test = 1;

	// tiempo host
    struct timeval t_ini, t_fin;
    double secs;

	FILE *fMediciones;
	
	fMediciones = fopen( "mediciones.csv", "a" );
    if(fMediciones==NULL) {
		fputs ("File error",stderr); 
		exit (1);
    }

	// Medicion de tiempos
	cl_ulong tStart,tEnd;

    // Realizar los siguientes test
    //while(test--){
		printf("test:%i\n",test);

		// inicializacion
		inicializar(matrix,bordes);

	    //gettimeofday(&t_ini, NULL);
/*        clGetEventProfilingInfo(eventBufferWrite, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &tStart, NULL);
        clGetEventProfilingInfo(eventBufferWrite, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &tEnd, NULL);
		printf("tiempo escritura buffer: %0.3f milliseconds\n", (tEnd-tStart)/1.0E6);
*/
		//Comunicacion con el dispositivo - FILMINA 32
		status = clEnqueueWriteBuffer(cmdQueue, bufMatrix, CL_FALSE, 0,array_size, matrix, 0, NULL, NULL);
		check_error(status, "clEnqueueWriteBuffer"); 
		status = clEnqueueWriteBuffer(cmdQueue, bufBordes, CL_FALSE, 0,array_size, bordes, 0, NULL, NULL);
		check_error(status, "clEnqueueWriteBuffer"); 
		/*status = clEnqueueWriteBuffer(cmdQueue, bufN, CL_FALSE, 0,sizeof(int), &N, 0, NULL, NULL);
		check_error(status, "clEnqueueWriteBuffer");
		status = clEnqueueWriteBuffer(cmdQueue, bufIteraciones, CL_FALSE, 0,sizeof(int), &ITERACIONES, 0, NULL, NULL);
		check_error(status, "clEnqueueWriteBuffer"); */

	// medir tiempo del matrix  
	print_matrix(matrix);
		printf("RUNNNN\n");

		// Ejecucion del kernel - FILMINA 67
		status = clEnqueueNDRangeKernel(cmdQueue, kernel, 1, NULL, globalWorkSize, NULL, 0, NULL, &eventKernel);
		check_error(status, "clEnqueueNDRangeKernel");

		printf("clWaitForEvents\n");
		clWaitForEvents(1,&eventKernel);

		// tiempo kernel
		clGetEventProfilingInfo(eventKernel,CL_PROFILING_COMMAND_START,sizeof(tStart),&tStart,NULL);
		clGetEventProfilingInfo(eventKernel,CL_PROFILING_COMMAND_END,sizeof(tEnd),&tEnd,NULL);
		printf("tiempo kernel: %0.3f milliseconds\n", (tEnd-tStart)/ 1.0E6);

		// LEER EL VALOR. Resultado - FILMINA 69
		clEnqueueReadBuffer(cmdQueue, bufMatrix, CL_TRUE, 0, array_size, matrix, 0, NULL, &eventBuffer);

		clWaitForEvents(1,&eventBuffer);
		
		// tiempo buffer
		clGetEventProfilingInfo(eventBuffer,CL_PROFILING_COMMAND_START,sizeof(tStart),&tStart,NULL);
		clGetEventProfilingInfo(eventBuffer,CL_PROFILING_COMMAND_END,sizeof(tEnd),&tEnd,NULL);
		printf("tiempo lectura buffer: %0.3f milliseconds\n", (tEnd-tStart)/ 1.0E6);

	    //gettimeofday(&t_fin, NULL);		
	    //secs = timeval_diff(&t_fin, &t_ini)* 1000.0;
    
		// Guardamos la el tiempo de la medicion
	    fprintf(fMediciones,"%i;%i;%.16g\n",N,100,secs);

    //}

    fclose(fMediciones);

	print_matrix(matrix);

	// get info
	/*struct timeval t_ini, t_fin;
	double secs,tTotal;
	gettimeofday(&t_ini, NULL);
	
	gettimeofday(&t_fin, NULL);
	secs = timeval_diff(&t_fin, &t_ini);*/
	//printf("%.16g milliseconds\n", secs * 1000.0);

	// Release resources - FILMINA 72
	clReleaseKernel(kernel);
	clReleaseProgram(program);
	clReleaseCommandQueue(cmdQueue);
	clReleaseMemObject(bufMatrix);
	clReleaseMemObject(bufBordes);
//	clReleaseMemObject(bufN);
//	clReleaseMemObject(bufIteraciones);
	clReleaseContext(context);

	// Liberar Memoria
	free(platforms);
	free(devices);
	free(matrix);
	free(bordes);
}












