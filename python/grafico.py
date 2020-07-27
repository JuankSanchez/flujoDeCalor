import numpy as np
import matplotlib.pyplot as plt

def graficar(array,N):
	# Array 1D a 2D
	array2 = [[0 for i in range(N)] for i in range(N)]    
	for f in range(N) :
		for c in range(N) :
			array2[f][c] = array[f*N+c] 

	colorinterpolation = 50 # Set colour interpolation and colour map
	colourMap = plt.cm.jet #you can try: colourMap = plt.cm.coolwarm
	X, Y = np.meshgrid(np.arange(0, N), np.arange(0, N))
	plt.title("Grafico mapa de calor")
	plt.contourf(X, Y, array2, colorinterpolation, cmap=colourMap)

	# Seteamos colores
	plt.colorbar()

	# Mostramos el grafico en pantalla
	plt.show()

