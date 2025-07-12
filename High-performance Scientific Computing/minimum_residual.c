#include <stdio.h>
#include <math.h>
#include <stdlib.h>


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


double vectorVectorProduct(double *u, double *v, int n){
    double sum = 0;

    for(int i =0;i<n;i++){
        sum += u[i]*v[i];
    }
    return sum;

}

double * matrixVectorProduct(double **A, double *v, int n){
    double * vect;
    vect = (double *)malloc(n*sizeof(double));

    double sum = 0;

    for(int i =0;i<n;i++){
        sum = 0;
        for(int j=0; j<n; j++){
            sum += A[i][j]*v[j];
        }
        vect[i] = sum;
    }
    return vect;

}

double *scalarVectorProduct(double s, double *v, int n){
    double *vNew;
    vNew = (double *)malloc(n*sizeof(double));
    for(int i =0;i<n;i++){
        vNew[i] = v[i]*s;
    }
    return vNew;
}

double *vectorVectorAddition(double *u, double *v, int n){
    double *sum;
    sum = (double *)malloc(n*sizeof(double));

    for(int i=0;i<n;i++){
        sum[i] = u[i] + v[i];
    }

    return sum;
}



double * minimum_residual(int n, double **A, double *b, double *X_0, double conv, int maxIter, int *iterptr){

    double *r, *p, *X_sol;
    r = (double *)malloc(n*sizeof(double));
    p = (double *)malloc(n*sizeof(double));
    X_sol = (double *)malloc(n*sizeof(double));
    
    copyArray(n, X_0, X_sol);

    r = vectorVectorAddition(b, scalarVectorProduct(-1, matrixVectorProduct(A, X_sol, n), n), n); // r=b-Ax
    // displayVector(n, r);
    p = matrixVectorProduct(A, r, n); // p=Ar
    // displayVector(n, p);

    double alpha;
    double residual = 1+conv;

    while(residual>conv){
        // printf("iteration: %d\n", *iterptr);
        if((*iterptr)>maxIter){
            printf("method did not converge :(\n");
            break;
        }
        alpha = vectorVectorProduct(p, r, n)/vectorVectorProduct(p, p, n); // alpha = (p.t)*r/((p.t)*p)
        // printf("%0.12f\n", alpha);
        X_sol = vectorVectorAddition(X_sol, scalarVectorProduct(alpha, r, n), n) ; // x=x+alpha*r
        // displayVector(n, X_sol);
        r = vectorVectorAddition(r, scalarVectorProduct(-alpha, p, n), n); //r=r-alpha*p
        // displayVector(n, r);
        p = matrixVectorProduct(A, r, n); // p=Ar
        residual = norm(n, r);
        printf("iteration: %d       residual=%0.12f\n", *iterptr, residual);
        (*iterptr) ++ ;
    }

    // displayVector(n, X_sol);
    // free(r);
    // free(p);
    return X_sol;

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



	for(int i = 0; i<n; i++){
       		 X_0[i] = 0;    
 	
	}

	// displayMatrix(n, A);
	// displayVector(n, b);
	printf("convergence criteria is : %.12f \n", conv);




    int *iterPtr ;
    *iterPtr = 1;
    X_sol = minimum_residual(n, A, b, X_0, conv, maxIter, iterPtr);
	// free(A);
    // free(b);
    // free(X_0);
	displayVector(n, X_sol) ;
    // printf("hello\n");
    
	FILE *fileSol = fopen("./minimumResidualSolution.txt", "w");
	printf("line 219\n");
    if(fileSol == NULL){
		printf("unable to open f vector file \n");
	}
	for(int i =0;i<n; i++){
		fprintf(fileSol,"%.12f\n", X_sol[i]);
	}
	fclose(fileSol);

	// FILE *fileSolInfo = fopen("minimumResidualInfo.txt", "w");
	// fprintf(fileSolInfo, "%d", *iterPtr) ;
	// fclose(fileSolInfo);
	
	printf("Number of Iterations = %d\n\n\n", *iterPtr);
	return 0;
}