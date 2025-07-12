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



int biconjugate_gradient(int n, double **A, double *b, double *X_0, double *X_sol, double *residual_arr, double conv, int maxIter){
    // displayVector(n, X_0);
    double *r, *rNew, *p, *pNew, *r0Star, *X, *Ap, *s, *As ;
    r = (double *)malloc(n*sizeof(double));
    rNew = (double *)malloc(n*sizeof(double));
    r0Star = (double *)malloc(n*sizeof(double));
    p = (double *)malloc(n*sizeof(double));
    pNew = (double *)malloc(n*sizeof(double));
    X = (double *)malloc(n*sizeof(double));
    Ap = (double *)malloc(n*sizeof(double));
    s = (double *)malloc(n*sizeof(double));
    As = (double *)malloc(n*sizeof(double));

    double *temp, *temp2, *temp3;
    temp = (double *)malloc(n*sizeof(double));
    temp2 = (double *)malloc(n*sizeof(double));
    temp3 = (double *)malloc(n*sizeof(double));

    copyArray(n, X_0, X);
    // displayVector(n, X);

    matrixVectorProduct(A, X, n, temp); // temp = A*X0
    scalarVectorProduct(-1, temp, n, temp); // temp = -temp = -A*X0
    vectorVectorAddition(b, temp, n, r); // r = b+temp => r=b-A*x0
    // displayVector(n, r);
    for(int i=0;i<n;i++){
        r0Star[i] = 1; // (rStar, r) != 0 should be satisfied
    }
    // displayVector(n, r);
    copyArray(n, r, p); // p0 = r0
    // displayVector(n, p);
    // displayMatrix(n, A);

    double alpha, beta, omega;
    double residual = 1+conv;
    int iter = 1;

    
    while(residual>conv){
        // printf("iteration: %d\n", iter);
        if(iter>maxIter){
            printf("method did not converge :(\n");
            break;
        }

        // displayVector(n, p);
        matrixVectorProduct(A, p, n, Ap); // Ap = A*p
        // displayVector(n, Ap);

        alpha = vectorVectorProduct(r, r0Star, n)/vectorVectorProduct(Ap, r0Star, n); // alpha = dot(r, r0star)/dot(Ap, r0star)

        scalarVectorProduct(-1*alpha, Ap, n, temp); // temp = -alpha*Ap;
        vectorVectorAddition(r, temp, n, temp2); // s = r + temp; => s = r - alpha*Ap;
        copyArray(n, temp2, s);

        // displayVector(n, s);

        matrixVectorProduct(A, s, n, As); // As = A*s;
        // displayVector(n, As);
        omega = vectorVectorProduct(As, s, n)/vectorVectorProduct(As, As, n); // omega = dot(As, s)/dot(As, As)
        // printf("%lf\n", omega);
        scalarVectorProduct(alpha, p, n, temp); // temp = alpha*p
        scalarVectorProduct(omega, s, n, temp2); // temp2 = omega*s
        vectorVectorAddition(temp, temp2, n, temp3); // temp3 = temp + temp2 => temp3 = alpha*p + omega*s
        vectorVectorAddition(X, temp3, n, X); // X = X + temp3 => X = X + alpha*p + omega*s

        scalarVectorProduct(-1*omega, As, n, temp); // temp = -omega*As
        vectorVectorAddition(s, temp, n, rNew); // rNew = s + temp => rNew = s - omega*As

        // beta = (alpha/omega)*dot(rNew, r0star)/dot(r, r0star)
        beta = (alpha/omega)*vectorVectorProduct(rNew, r0Star, n)/vectorVectorProduct(r, r0Star, n); 

        scalarVectorProduct(beta, p, n, temp); // temp = beta*p
        scalarVectorProduct(-beta*omega, Ap, n, temp2); // temp2 = -beta*omega*Ap
        vectorVectorAddition(temp, temp2, n, temp3); // temp2 = temp + temp2 => temp2 = beta*p-beta*omega*Ap
        vectorVectorAddition(rNew, temp3 , n, pNew); // pNew = rNew + temp2 => pNew = rNew + beta*p-beta*omega*Ap

        // displayVector(n, rNew);
        copyArray(n, rNew, r);
        copyArray(n, pNew, p);

        residual = norm(n, rNew);
        // displayVector(n, rNew);
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
    free(r0Star);
    free(X);
    free(Ap);
    free(temp);
    free(temp2);
    return iter;

}


int main(){

    int n ;

	FILE *fileKinfo = fopen("../problem_data/kinfo.txt", "r");
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




	FILE *fileA = fopen("../problem_data/Kmat.txt", "r") ;
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


	FILE *fileb = fopen("../problem_data/Fvec.txt", "r");
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


    int numIterations = 0;
    double *residual_arr  ;
    residual_arr = (double *)malloc(maxIter*sizeof(double));

    clock_t start, end;
	double cpu_time_used;
	start = clock();

    numIterations = biconjugate_gradient(n, A, b, X_0, X_sol, residual_arr, conv, maxIter);

    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
	free(A);
    free(b);
    free(X_0);
    printf("\n");
	// displayVector(n, X_sol) ;

    
	FILE *fileSol = fopen("../solution_data/BICGSTAB/BICGSTABSolution.txt", "w");
    if(fileSol == NULL){
		printf("unable to open solution file \n");
        // return 1;
	}
	for(int i =0;i<n; i++){
		fprintf(fileSol,"%.12f\n", X_sol[i]);
	}
	fclose(fileSol);

    // free(X_sol);

	FILE *fileSolInfo = fopen("../solution_data/BICGSTAB/BICGSTABInfo.txt", "w");
	fprintf(fileSolInfo, "%d\n", numIterations) ;
	fprintf(fileSolInfo, "%.12f", cpu_time_used);
	fclose(fileSolInfo);
	
    FILE *fileSolRes = fopen("../solution_data/BICGSTAB/BICGSTABResidual.txt", "w");
    if(fileSolRes == NULL){
		printf("unable to open solution file \n");
        // return 1;
	}
	for(int i =0;i<numIterations; i++){
		fprintf(fileSolRes,"%.12f\n", residual_arr[i]);
	}
	fclose(fileSolRes);
    free(X_sol);
	printf("Number of Iterations = %d\n\n\n", numIterations);
    printf("Solver execution time = %.12f\n", cpu_time_used);
    free(residual_arr);
	return 0;
}