# Лабораторна робота №2

## Мета

Створити невеликий C++ проект з трьома файлами (1 заголовок + 2 cpp), створити Makefile і CMakeLists.txt, зібрати статичну або динамічну бібліотеку та виконуваний файл.

## Хід роботи

### Cтруктура проєкта

```shell
maxim@x540ubr:~/Documents/studying/comp-arch/lab2$ tree
.
├── CMakeLists.txt
├── docker-compose.yml
├── include
│   └── mylib.h
├── Makefile
└── src
    ├── main.cpp
    └── mylib.cpp

3 directories, 7 files
```

### Файли проєкту

#### mylib.h

```cpp
#ifndef MYLIB_H
#define MYLIB_H

int add(int a, int b);

#endif
```

#### main.cpp

```cpp
#include <iostream>
#include "mylib.h"

int main() {
    std::cout << "3 + 4 = " << add(3, 4) << std::endl;
    return 0;
}
```

#### mylib.cpp

```cpp
#include "mylib.h"

int add(int a, int b) {
    return a + b;
}
```

#### Makefile

```makefile
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
```

#### CMakeLists.txt

```txt
cmake_minimum_required(VERSION 3.10)
project(MyProject)

include_directories(include)

add_library(mylib STATIC src/mylib.cpp)

add_executable(myapp src/main.cpp)

target_link_libraries(myapp PRIVATE mylib)
target_include_directories(myapp PRIVATE include)
```

### Перевірка збірки

```shell
root@718b2d0948a6:/workspace# make
g++ -Iinclude -Wall -c src/main.cpp -o main.o
g++ -Iinclude -Wall -c src/mylib.cpp -o mylib.o
ar rcs libmylib.a mylib.o
g++ main.o mylib.o -L. -lmylib -o myapp

root@718b2d0948a6:/workspace# ls
CMakeLists.txt  Makefile  docker-compose.yml  include  libmylib.a
  main.o  myapp  mylib.o  src

root@718b2d0948a6:/workspace# ./myapp
3 + 4 = 7

root@718b2d0948a6:/workspace# make clean
rm -f main.o mylib.o myapp libmylib.a

root@718b2d0948a6:/workspace# ls
CMakeLists.txt  Makefile  docker-compose.yml  include  src
```

### Збірка проєкту

```bash
root@718b2d0948a6:/workspace# cmake -B build -G Ninja
-- The C compiler identification is GNU 13.3.0
-- The CXX compiler identification is GNU 13.3.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done (1.0s)
-- Generating done (0.0s)
-- Build files have been written to: /workspace/build

root@718b2d0948a6:/workspace# cmake --build build
[4/4] Linking CXX executable myapp

root@718b2d0948a6:/workspace# ./build/myapp
3 + 4 = 7
```

## Висновок

У ході виконання лабораторної роботи ознайомився з принципами автоматизованої збірки програмного забезпечення за допомогою Make та CMake. Створив Makefile та CMakeLists.txt для невеликого проекту, зібрав бібліотеку та виконуваний файл, перевірив роботу правил `all` та `clean`, а також зібрав проект за допомогою системи Ninja.
