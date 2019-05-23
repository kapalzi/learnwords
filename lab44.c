#include <stdio.h>
#include <time.h>
typedef struct {
int a; 
int b; 
int c; 
int d;
} vector;

vector getRandomVector()
{
    vector v = { 
    (rand() % 100) + 1,
    (rand() % 100) + 1,
    (rand() % 100) + 1,
    (rand() % 100) + 1 };
    return v;
}

void addSIMD(int n, FILE *file)
{
    double time = 0;
    for(int i = 0; i < n/4; ++i)
    {
        vector result = getRandomVector();
        vector v = getRandomVector();
        clock_t t = clock();
        
        asm(
        "movups %1, %%xmm0 \n"
        "movups %2, %%xmm1 \n"
        "addps %%xmm1, %%xmm0 \n"
        "movups %%xmm0, %0\n"
        : "=g"(result)
        : "g"(result), "g"(v)
        );
        time += ((double)clock() - t)/CLOCKS_PER_SEC;
    }
    fprintf(file, "SIMD add time of %i is %f \n",n,time);
    printf("SIMD add time of %i is %f \n",n,time);
}

void subSIMD(int n, FILE *file)
{
    double time = 0;
    for(int i = 0; i < n/4; ++i)
    {
        vector result = getRandomVector();
        vector v = getRandomVector();
        clock_t t = clock();
        
        asm(
        "movups %1, %%xmm0 \n"
        "movups %2, %%xmm1 \n"
        "subps %%xmm1, %%xmm0 \n"
        "movups %%xmm0, %0\n"
        : "=g"(result)
        : "g"(result), "g"(v)
        );
        time += ((double)clock() - t)/CLOCKS_PER_SEC;
    }
    fprintf(file, "SIMD sub time of %i is %f \n",n,time);
    printf("SIMD sub time of %i is %f \n",n,time);
}

void mulSIMD(int n, FILE *file)
{
    double time = 0;
    for(int i = 0; i < n/4; ++i)
    {
        vector result = getRandomVector();
        vector v = getRandomVector();
        clock_t t = clock();
        
        asm(
        "movups %1, %%xmm0 \n"
        "movups %2, %%xmm1 \n"
        "mulps %%xmm1, %%xmm0 \n"
        "movups %%xmm0, %0\n"
        : "=g"(result)
        : "g"(result), "g"(v)
        );
        time += ((double)clock() - t)/CLOCKS_PER_SEC;
    }
    fprintf(file, "SIMD mul time of %i is %f \n",n,time);
    printf("SIMD mul time of %i is %f \n",n,time);
}

void divSIMD(int n, FILE *file)
{
    double time = 0;
    for(int i = 0; i < n/4; ++i)
    {
        vector result = getRandomVector();
        vector v = getRandomVector();
        clock_t t = clock();
        
        asm(
        "movups %1, %%xmm0 \n"
        "movups %2, %%xmm1 \n"
        "divps %%xmm1, %%xmm0 \n"
        "movups %%xmm0, %0\n"
        : "=g"(result)
        : "g"(result), "g"(v)
        );
        time += ((double)clock() - t)/CLOCKS_PER_SEC;
    }
    fprintf(file, "SIMD div time of %i is %f \n\n",n,time);
    printf("SIMD div time of %i is %f \n\n",n,time);
}

void addSISD(int n, FILE *file)
{
    double time = 0;
    for(int i = 0; i < n; ++i)
    {
        int result = (rand() % 100) + 1;
        int v = (rand() % 100) + 1;
        clock_t t = clock();
        
        asm(
        "mov %1, %%eax \n"
        "mov %2, %%ebx \n"
        "add %%ebx, %%eax \n"
        "mov %%eax, %0\n"
        : "=g"(result)
        : "g"(result), "g"(v)
        : "%eax", "%ebx"
        );
        time += ((double)clock() - t)/CLOCKS_PER_SEC;
    }
    fprintf(file, "SISD add time of %i is %f \n",n,time);
    printf("SISD add time of %i is %f \n",n,time);
}

void subSISD(int n, FILE *file)
{
    double time = 0;
    for(int i = 0; i < n; ++i)
    {
        int result = (rand() % 100) + 1;
        int v = (rand() % 100) + 1;
        clock_t t = clock();
        
        asm(
        "mov %1, %%eax \n"
        "mov %2, %%ebx \n"
        "sub %%ebx, %%eax \n"
        "mov %%eax, %0\n"
        : "=g"(result)
        : "g"(result), "g"(v)
        : "%eax", "%ebx"
        );
        time += ((double)clock() - t)/CLOCKS_PER_SEC;
    }
    fprintf(file, "SISD sub time of %i is %f \n",n,time);
    printf("SISD sub time of %i is %f \n",n,time);
}

void mulSISD(int n, FILE *file)
{
    double time = 0;
    for(int i = 0; i < n; ++i)
    {
        int result = (rand() % 100) + 1;
        int v = (rand() % 100) + 1;
        clock_t t = clock();
        
        asm(
        "mov %1, %%eax \n"
        "mov %2, %%ebx \n"
        "mul %%ebx\n"
        "mov %%eax, %0\n"
        : "=g"(result)
        : "g"(result), "g"(v)
        : "%eax", "%ebx"
        );
        time += ((double)clock() - t)/CLOCKS_PER_SEC;
    }
    fprintf(file, "SISD mul time of %i is %f \n",n,time);
    printf("SISD mul time of %i is %f \n",n,time);
}

void divSISD(int n, FILE *file)
{
    double time = 0;
    for(int i = 0; i < n; ++i)
    {
        int result = (rand() % 100) + 1;
        int v = (rand() % 100) + 1;
        clock_t t = clock();
        
        asm(
        "fldl %1 \n"
        "fdivl %2 \n"   
        : "=g"(result)
        : "g"(result), "g"(v)
        : "%eax", "%ebx"
        );
        time += ((double)clock() - t)/CLOCKS_PER_SEC;
    }
    fprintf(file, "SISD div time of %i is %f \n\n",n,time);
    printf("SISD div time of %i is %f \n\n",n,time);
}

int main() {
    FILE *file;
    file = fopen("wyniki.txt", "w");

    for(int i = 2048; i <= 8192; i*=2) {
        addSIMD(i, file);
        subSIMD(i, file);
        mulSIMD(i, file);
        divSIMD(i, file);
        addSISD(i, file);
        subSISD(i, file);
        mulSISD(i, file);
        divSISD(i, file);
    }
}

// lab44: lab44.c
// 	gcc -o lab44 lab44.c
	
// clear:
// 	rm -f *.o *~