#include <math.h>
#include <stdio.h>
#include <stdlib.h>

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



int SOR(int n, double *b, double **A, double *X_0, double conv, double *X_sol, int maxIter, double w){
	
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
	
	FILE *fileKinfo = fopen("./problem_data/kinfo.txt", "r");
	if(fileKinfo == NULL){
		printf("unable to read K info file \n");
	}
	fscanf(fileKinfo, "%d", &n);
	fclose(fileKinfo);

	double conv = 1e-6;
	int maxIter = 100;
	double w = 1.5;
	
	

    double *b, *X_0, *X_sol;
    b = (double *)malloc(n*sizeof(double));
    X_0 = (double *)malloc(n*sizeof(double));
    X_sol = (double *)malloc(n*sizeof(double));


    double **A;
    A = (double **)malloc(n*sizeof(double *));
    for(int i = 0;i<n;i++){
        A[i] = (double *)malloc(n*sizeof(double));
    }




	FILE *fileA = fopen("./problem_data/Kmat.txt", "r") ;
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


	FILE *fileb = fopen("./problem_data/Fvec.txt", "r");
	if(fileb == NULL){
		printf("unable to open f vector file \n");
	}

	for(int i = 0; i<n; i++){
		fscanf(fileb, "%lf", &b[i]);
	}
	
	fclose(fileb);

	//printf("start entering A \n"); 
	//for (int i=0; i<n; i++){
	//	for(int j=0; j<n; j++){
	//		scanf("%lf", &A[i][j]);
	//	}
	//}

	//printf("start entering b \n");
	//for(int i=0;i<n;i++){
	//	scanf("%lf", &b[i]);
	//}

	for(int i = 0; i<n; i++){
        X_0[i] = 0;    
    }

	//displayMatrix(n, A);
	//displayVector(n, b);
	printf("convergence criteria is : %.12f \n", conv);
	//double a = norm(n, X_0, b);
	//printf("norm %lf \n", a)
	int numIterations = SOR(n, b, A, X_0, conv, X_sol, maxIter, w);
	
	// displayVector(n, X_sol) ;

	FILE *fileSol = fopen("./SORSolution.txt", "w");
	
	for(int i =0;i<n; i++){
		fprintf(fileSol,"%.12f\n", X_sol[i]);
	}
	fclose(fileSol);


	FILE *fileSolInfo = fopen("./SORSolutionInfo.txt", "w");
	fprintf(fileSolInfo, "%d", numIterations);
	fclose(fileSolInfo);

	printf("Number of Iterations = %d \n\n\n", numIterations);
	return 1;
}



