import math

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def calculate_hypotenuse(a, b):
    return math.sqrt(a**2 + b**2)

if __name__ == "__main__":
    print("5 + 3 =", add(5, 3))
    print("10 - 4 =", subtract(10, 4))
    print("Гипотенуза треугольника с катетами 3 и 4 =", calculate_hypotenuse(3, 4))
