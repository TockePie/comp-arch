CXX = g++
CXXFLAGS = -Iinclude -Wall -c

SRC = src/main.cpp src/mylib.cpp
OBJ = main.o mylib.o
LIB = libmylib.a
TARGET = myapp

all: $(TARGET)

$(TARGET): $(OBJ) $(LIB)
	$(CXX) $(OBJ) -L. -lmylib -o $(TARGET)

$(LIB): mylib.o
	ar rcs $(LIB) mylib.o

main.o: src/main.cpp
	$(CXX) $(CXXFLAGS) src/main.cpp -o main.o

mylib.o: src/mylib.cpp
	$(CXX) $(CXXFLAGS) src/mylib.cpp -o mylib.o

clean:
	rm -f $(OBJ) $(TARGET) $(LIB)

.PHONY: all clean
