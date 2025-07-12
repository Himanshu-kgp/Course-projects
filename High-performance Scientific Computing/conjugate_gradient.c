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



int conjugate_gradient(int n, double **A, double *b, double *X_0, double *X_sol, double*residual_arr, double conv, int maxIter){
    // displayVector(n, X_0);
    double *r, *Ap, *rNew, *p, *X, *pNew;
    r = (double *)malloc(n*sizeof(double));
    rNew = (double *)malloc(n*sizeof(double));
    p = (double *)malloc(n*sizeof(double));
    pNew = (double *)malloc(n*sizeof(double));
    X = (double *)malloc(n*sizeof(double));
    Ap = (double *)malloc(n*sizeof(double));

    copyArray(n, X_0, X);
    // displayVector(n, X);

    r = vectorVectorAddition(b, scalarVectorProduct(-1, matrixVectorProduct(A, X, n), n), n); // r=b-A*x0
    // displayVector(n, r);
    copyArray(n, r, p); // p0 = r0
    // displayVector(n, p);
    // displayMatrix(n, A);

    double alpha, beta;
    double residual = 1+conv;
    int iter = 1;

    
    while(residual>conv){
        // printf("iteration: %d\n", iter);
        if(iter>maxIter){
            printf("method did not converge :(\n");
            break;
        }

        // displayVector(n, p);
        copyArray(n, matrixVectorProduct(A, p, n), Ap);
        // displayVector(n, Ap);
        alpha = vectorVectorProduct(r, r, n)/vectorVectorProduct(Ap, r, n);
        X = vectorVectorAddition(X, scalarVectorProduct(alpha, p, n), n);
        rNew = vectorVectorAddition(r, scalarVectorProduct(-alpha, Ap, n), n);
        beta = vectorVectorProduct(rNew, rNew, n)/vectorVectorProduct(r, r, n);
        pNew = vectorVectorAddition(rNew, scalarVectorProduct(beta, p, n) , n);

        copyArray(n, rNew, r);
        copyArray(n, pNew, p);
        residual = norm(n, rNew);
        residual_arr[iter] = residual;
        printf("iteration: %d       residual: %0.12f\n", iter, residual);
        iter ++;
        
    }

    copyArray(n, X, X_sol);
    // displayVector(n, X_sol);
    free(r);
    free(rNew);
    free(p);
    free(pNew);
    free(X);
    free(Ap);
    return iter;

}


int main(){

    int n ;

	FILE *fileKinfo = fopen("./problem_data/kinfo.txt", "r");
	if(fileKinfo == NULL){
		printf("unable to read K info file \n");
        return 1;
	}
	fscanf(fileKinfo, "%d", &n);
	fclose(fileKinfo);

	double conv = 1e-6;
	int maxIter = 1000;

	
	

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
		return 1;
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
        return 1;
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
	printf("convergence criteria is : %.12f \n\n", conv);


    double *residual_arr  ;
    residual_arr = (double *)malloc(maxIter*sizeof(double));
    int numIterations = 0;
    numIterations = conjugate_gradient(n, A, b, X_0, X_sol, residual_arr, conv, maxIter);
	free(A);
    free(b);
    free(X_0);
    printf("\n");
	// displayVector(n, X_sol) ;

    
	FILE *fileSol = fopen("./conjugateGradientSolution.txt", "w");
    if(fileSol == NULL){
		printf("unable to open solution file \n");
        // return 1;
	}
	for(int i =0;i<n; i++){
		fprintf(fileSol,"%.12f\n", X_sol[i]);
	}
	fclose(fileSol);

    // free(X_sol);

	FILE *fileSolInfo = fopen("conjugateGradient.txt", "w");
	fprintf(fileSolInfo, "%d", numIterations) ;
	fclose(fileSolInfo);
	
    free(X_sol);
	printf("Number of Iterations = %d\n\n\n", numIterations);
    free(residual_arr);
	return 0;
}