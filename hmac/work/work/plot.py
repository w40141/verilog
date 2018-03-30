import math
import numpy as np
from matplotlib import pyplot

pi = math.pi

x = np.linspace(0, 2*pi, 100)
y = np.sin(x)

pyplot.plot(x, y)
pyplot.show()
