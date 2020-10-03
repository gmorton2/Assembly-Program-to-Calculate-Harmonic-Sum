#Garinn Morton 
#Assembly
#Final

rm *.o
rm *.out

nasm -f elf64 -l harmonic.lis -o harmonic.o harmonic.asm
g++ -c -Wall -std=c++14 -o main.o -m64 -no-pie -fno-pie main.cpp
g++ -m64 -std=c++14 main.o -fno-pie -no-pie -o main.out harmonic.o
./main.out