// calcula la posicion de la matriz
unsigned int idx(unsigned int x, unsigned int y, unsigned int stride);

// Calcula la diferencia de tiempo
double timeval_diff(struct timeval *a, struct timeval *b);

// Guarda la matriz en un ARCHIVO .CSV (generamos el archivo csv)
void saveFileCSV(float * matrix, unsigned int N);

// GRAFICO (generamos el grafico mapa de calor)
void saveFilePPM(float * matrix,unsigned int N);

// Mostramos en pantalla la matriz
void printfMatrix(float * matrix,unsigned int N);
