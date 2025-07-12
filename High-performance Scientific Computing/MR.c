#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

void copyArray(int n, double *source, double *destination){

	for(int i=0; i<n; i++){
		*(destination+i) = *(source+i);
	}

}

double norm(int n, double *p){

	double sum = 0;
	for (int i=0; i<n; i++){
		sum = sum+p[i]*p[i] ;
	}

	return sqrt(sum) ;
}


void displayMatrix(int n, double **mat){

	for(int i=0; i<n; i++){
		for(int j=0; j<n ;j++){
			printf("matrix(%d, %d) = %.12f \n", i, j, mat[i][j]) ;
		}
	}
	printf("\n");
}

void displayVector(int n, double *p){

        for(int i=0;i<n;i++){
                printf("vector(%d) = %.12f \n", i, *(p+i));
        }
        printf("\n") ;

}

void tranposeMatrix(double **A, int n, double **At){

  
    for(int i = 0;i<n;i++){
        At[i] = (double *)malloc(n*sizeof(double));
    }

    for(int i =0;i<n;i++){
        for(int j=0;j<n;j++){
            At[i][j] = A[j][i];
        }
    }

    
    
}

double vectorVectorProduct(double *u, double *v, int n){
    double sum = 0;

    for(int i =0;i<n;i++){
        sum += u[i]*v[i];
    }
    return sum;

}

void matrixVectorProduct(double **A, double *v, int n, double *vect){

    // displayMatrix(n, A);
    // displayVector(n, v);
    double sum = 0;

    for(int i =0;i<n;i++){
        sum = 0;
        for(int j=0; j<n; j++){
            sum += A[i][j]*v[j];
        }
        vect[i] = sum;
    }
    // displayVector(n, vect);

}

void scalarVectorProduct(double s, double *v, int n, double *vNew){
    
    for(int i =0;i<n;i++){
        vNew[i] = v[i]*s;
    }
}

void vectorVectorAddition(double *u, double *v, int n, double *sum){
  

    for(int i=0;i<n;i++){
        sum[i] = u[i] + v[i];
    }

}


int minimum_residual(int n, double **A, double *b, double *X_0, double *X_sol, double *residual_arr, double conv, int maxIter){

    double *r, *p, *X;
    r = (double *)malloc(n*sizeof(double));
    p = (double *)malloc(n*sizeof(double));
    X = (double *)malloc(n*sizeof(double));


    double *temp, *temp2;
    temp = (double *)malloc(n*sizeof(double));
    temp2 = (double *)malloc(n*sizeof(double));


    copyArray(n, X_0, X);

    matrixVectorProduct(A, X, n, temp); // temp = A*X0
    scalarVectorProduct(-1, temp, n, temp); // temp = -1*temp = -A*X0
    vectorVectorAddition(b, temp, n, r); // r = b + temp => r = b - A*X0

    // displayVector(n, r);
    matrixVectorProduct(A, r, n, p); // p=A*r
    // displayVector(n, p);

    double alpha;
    double residual = 1+conv;
    int iter = 1;


    while(residual>conv){
        // printf("iteration: %d\n", *iterptr);
        if(iter>maxIter){
            printf("method did not converge :(\n");
            break;
        }
        alpha = vectorVectorProduct(p, r, n)/vectorVectorProduct(p, p, n); // alpha = (p.t)*r/((p.t)*p)
        // printf("%0.12f\n", alpha);


        scalarVectorProduct(alpha, r, n, temp); // temp = alpha*r ;
        vectorVectorAddition(X, temp, n, temp2) ; // temp2 = X + temp; 
        copyArray(n, temp2, X); // X = temp2;


        scalarVectorProduct(-alpha, p, n, temp); // temp = -alpha*p
        vectorVectorAddition(r, temp, n, temp2); //temp2 = r + temp
        copyArray(n, temp2, r); // r = temp2 ;


        // displayVector(n, r);
        matrixVectorProduct(A, r, n, p); // p=Ar

        residual = norm(n, r);
        residual_arr[iter] = residual;
        printf("iteration: %d       residual=%0.12f\n", iter, residual);
        iter ++ ;
    }

    // displayVector(n, X_sol);
    // free(r);
    // free(p);
    copyArray(n, X, X_sol);
    return iter ;

}


int main(){

    int n ;

	FILE *fileKinfo = fopen("../problem_data/kinfo.txt", "r");
	if(fileKinfo == NULL){
		printf("unable to read K info file \n");
	}
	fscanf(fileKinfo, "%d", &n);
	fclose(fileKinfo);

	double conv = 1e-6;
	int maxIter = 10000;




    double *b, *X_0, *X_sol;
    b = (double *)malloc(n*sizeof(double));
    X_0 = (double *)malloc(n*sizeof(double));
    X_sol = (double *)malloc(n*sizeof(double));


    double **A;
    A = (double **)malloc(n*sizeof(double *));
    for(int i = 0;i<n;i++){
        A[i] = (double *)malloc(n*sizeof(double));
    }




	FILE *fileA = fopen("../problem_data/Kmat.txt", "r") ;
	if(fileA == NULL){
		printf("Unable to open K matrix file \n");
		return 0;
	}

	for(int i = 0; i<n; i++){
		for(int j = 0;j<n; j++){
			fscanf(fileA, "%lf", &A[i][j]);
		}
	}

	fclose(fileA);


	FILE *fileb = fopen("../problem_data/Fvec.txt", "r");
	if(fileb == NULL){
		printf("unable to open f vector file \n");
	}

	for(int i = 0; i<n; i++){
		fscanf(fileb, "%lf", &b[i]);
	}

	fclose(fileb);



	for(int i = 0; i<n; i++){
       		 X_0[i] = 0;

	}

	// displayMatrix(n, A);
	// displayVector(n, b);
	printf("convergence criteria is : %.12f \n", conv);



    double *residual_arr  ;
    residual_arr = (double *)malloc(maxIter*sizeof(double));
    int numIterations = 0;

    clock_t start, end;
	double cpu_time_used;
	start = clock();
    
    numIterations = minimum_residual(n, A, b, X_0, X_sol, residual_arr, conv, maxIter);

    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

	free(A);
    free(b);
    free(X_0);
	// displayVector(n, X_sol) ;
    printf("hello\n");

	FILE *fileSol = fopen("../solution_data/MR/MRSolution.txt", "w");
	
    if(fileSol == NULL){
		printf("unable to open solution file \n");
	}
	for(int i =0;i<n; i++){
		fprintf(fileSol,"%.12f\n", X_sol[i]);
	}
	fclose(fileSol);

	FILE *fileSolInfo = fopen("../solution_data/MR/MRInfo.txt", "w");
    if(fileSolInfo == NULL){
		printf("unable to open solution info file \n");
	}
	fprintf(fileSolInfo, "%d \n", numIterations) ;
    fprintf(fileSolInfo, "%.12f", cpu_time_used);
	fclose(fileSolInfo);

    FILE *fileSolRes = fopen("../solution_data/MR/MRResidual.txt", "w");
    if(fileSolRes == NULL){
		printf("unable to open residual file \n");
        // return 1;
	}
	for(int i =0;i<numIterations; i++){
        fprintf(fileSolRes,"%.12f\n", residual_arr[i]);
	}
	fclose(fileSolRes);
	

	printf("Number of Iterations = %d\n\n", numIterations);
    printf("Solver execution time = %.12f\n", cpu_time_used);

	return 0;
}
