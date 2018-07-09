# For Linux or any machines with gcc compiler
CC = gcc
CFLAGS = -std=c99 -Wall -pedantic -g

# For SunOS
#CFLAGS = -Aa

all: Example

clean:
	/bin/rm *.o Example

OBJ = tiff.o allocate.o randlib.o subroutines.o

Example: Example.o $(OBJ) 
	$(CC) $(CFLAGS) -o Example Example.o $(OBJ) -lm



# 用“.”的话，只需要声明一个结构体。格式是，结构体类型名+结构体名。然后用结构体名加“.”加域名就可以引用域 了。
# 因为自动分配了结构体的内存。如同 int a;一样。

# 用->的话，要声明一个结构体的指针，还要手动开辟一个该结构体的内存，然后把返回的指针给声明的结构体指针。才能用->正确引用。
# 否则内存中只分配了指针的内存，没有分配结构体的内存，想要的结构体实际上是不存在。
# 这时候用->引用自然出错了，因为没有结构体，自然没有结构体的域了。

# "."我直接读做"的”。->我读作"指向的结构体的"。



