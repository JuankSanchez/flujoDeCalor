import grafico as gr

# Parametros de la simulacion
N 			= 25
TEMP_BORDE 	= 10.0
TEMP_INICIAL= 0.0
TEMP_FUENTE = 10.0
FUENTE_X 	= 0
FUENTE_Y 	= 0
ITERACIONES	= 10

# Posicion de la fuente de calor y temperatura inicial en la matrix
def iniciar(matrix):
	
	# Temepratura inicial
	bordes=[False for i in range(N*N)]
	
	# Posicion fuente de calor
	matrix[FUENTE_X+FUENTE_Y*N] = TEMP_FUENTE
	bordes[FUENTE_X+FUENTE_Y*N] = True
	
	# Bordes
	for f in range(N) :
		for c in range(N) :
			if f==0 or c==0 or c==N-1 or f==N-1:
				p = f*N+c
				bordes[p] = True
				matrix[p] = TEMP_BORDE		

	return bordes

# Calculo de una iteracion 
def calcular(current,bordes) :
	x=N;next=[0 for i in range(N*N)]
	for p in range(N*N) :
		if bordes[p] :
			next[p] = current[p]
		else :
			next[p] = (current[p+1]+current[p-1]+current[p+N]+current[p-N])*0.25
	return next

# valores iniciales
current = [TEMP_INICIAL for i in range(N*N)]

bordes = iniciar(current)

# Calculo de las iteraciones
for it in range(ITERACIONES) :
	current = calcular(current,bordes)

gr.graficar(current,N)

#print(current)

print("")
