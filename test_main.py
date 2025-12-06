from main import add, subtract, calculate_hypotenuse

def test_add():
    assert add(2, 3) == 5

def test_subtract():
    assert subtract(5, 2) == 3

def test_hypotenuse():
    assert calculate_hypotenuse(3, 4) == 5
