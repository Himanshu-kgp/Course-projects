#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
     

void copyArray(int n, double *source, double *destination){

	for(int i=0; i<n; i++){
		*(destination+i) = *(source+i);
	}

}

double norm(int n, double *p, double *q){

	double sum = 0;
	for (int i=0; i<n; i++){
		sum = sum+(p[i]-q[i])*(p[i]-q[i]) ;
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
                printf("element %d  = %.12f \n", i, *(p+i));
        }
        printf("\n") ;

}



int SOR(int n, double *b, double **A, double *X_0, double conv, double *X_sol, double *err_arr, int maxIter, double w){
	
	//displayMatrix(n, A) ;
	//displayVector(n, b);	

	double X[n];

	copyArray(n, X_0, X);

	//displayVector(n, X);

	int iter = 0;
	double err = 1.0 + conv;

	double sum = 0;
	double res = 0;

	while(err>conv){

		if(iter > maxIter){	
			printf("solution did not converge \n") ;
			break;
		}
		for(int i=0; i<n; i++){
			sum = 0;
			for(int j = 0; j<i; j++){
				sum = sum + A[i][j]*X[j] ;
			}

			for(int j=i; j<n; j++){
				sum = sum + A[i][j]*X_0[j] ;
			}
			
			//printf("A(%d, %d) = %lf\n", i, i, A[i][i]) ;
			res = b[i] - sum ;
			//printf("residual: %lf \n", res);
			X[i] = X_0[i] + w*res/((double)A[i][i]) ;
		}

		//displayVector(n, X);
		err = norm(n, X_0, X);
		err_arr[iter] = err;
		copyArray(n, X, X_0) ;
		iter ++ ;
		printf("iteration: %d , err: %.12f  \n", iter, err) ;

	}
	
	printf("\n");
	//displayVector(n, X);	
	copyArray(n, X, X_sol) ;


	return iter;
}



int main(){
	int n ;
	
	FILE *fileKinfo = fopen("../problem_data/kinfo.txt", "r");
	if(fileKinfo == NULL){
		printf("unable to read K info file \n");
	}
	fscanf(fileKinfo, "%d", &n);
	fclose(fileKinfo);

	double conv = 1e-3;
	int maxIter = 100;
	double w ;
	
	FILE *fileOptOmega = fopen("../solution_data/SOR/optimumOmega.txt", "r");
	if(fileOptOmega == NULL){
		printf("unable to read optimum omega file \n");
	}
	fscanf(fileOptOmega, "%lf", &w);
	fclose(fileOptOmega);
	

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


	printf("convergence criteria is : %.12f \n", conv);
	double *err_arr;
	err_arr = (double *)malloc(maxIter*sizeof(double));

	clock_t start, end;
	double cpu_time_used;
	start = clock();

	int numIterations = SOR(n, b, A, X_0, conv, X_sol, err_arr, maxIter, w);
	
	end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

	

	FILE *fileSol = fopen("../solution_data/SOR/SORSolution.txt", "w");
	
	for(int i =0;i<n; i++){
		fprintf(fileSol,"%.12f\n", X_sol[i]);
	}
	fclose(fileSol);

	FILE *fileSolRes = fopen("../solution_data/SOR/SORError.txt", "w");
    if(fileSolRes == NULL){
		printf("unable to open solution file \n");
        // return 1;
	}
	for(int i =0;i<numIterations; i++){
		fprintf(fileSolRes,"%.12f\n", err_arr[i]);
	}
	fclose(fileSolRes);

	FILE *fileSolInfo = fopen("../solution_data/SOR/SORInfo.txt", "w");
	fprintf(fileSolInfo, "%d\n", numIterations);
	fprintf(fileSolInfo, "%.12f", cpu_time_used);
	fclose(fileSolInfo);

	printf("Number of Iterations = %d \n\n", numIterations);
	printf("Solver execution time = %.12f\n", cpu_time_used);
	return 1;
}



