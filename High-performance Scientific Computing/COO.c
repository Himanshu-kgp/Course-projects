#include <stdio.h>
#include <stdlib.h>


int COO(int n, double **A, double *AA, int *JR, int *JC){

    int ii = 0;

    for(int i = 0;i<n;i++){
        for(int j =0;j<n;j++){
            if(A[i][j]!=0){
                printf("%lf \n", A[i][j]);
                printf("%d, %d \n\n", i, j);
                AA[ii] = A[i][j];
                JR[ii] = i;
                JC[ii] = j;
                ii++ ;
            }
        }
    }

    return ii;

}

int main(){

    int n ;

	FILE *fileKinfo = fopen("./problem_data/kinfo.txt", "r");
	if(fileKinfo == NULL){
		printf("unable to read K info file \n");
	}
	fscanf(fileKinfo, "%d", &n);
	fclose(fileKinfo);

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


    int nnz; // non zero
    double *AA;
    int *JR, *JC;
    AA =  (double *)malloc(n*n*sizeof(double));
    JR =  (int *)malloc(n*n*sizeof(int));
    JC =  (int *)malloc(n*n*sizeof(int));;
    nnz = COO(n, A, AA, JR, JC);

    printf("number of non zero elements = %d\n", nnz);


    FILE *fileCOOKmat = fopen("./problem_data/COOKmat.txt", "w");
	
	for(int i =0;i<nnz; i++){
		fprintf(fileCOOKmat,"%.12f\n", AA[i]);
	}
	fclose(fileCOOKmat);

    FILE *fileCOOJR = fopen("./problem_data/COOJR.txt", "w");
	
	for(int i =0;i<nnz; i++){
		fprintf(fileCOOJR,"%d\n", JR[i]);
	}
	fclose(fileCOOJR);

    FILE *fileCOOJC = fopen("./problem_data/COOJC.txt", "w");
	
	for(int i =0;i<nnz; i++){
		fprintf(fileCOOJC,"%d\n", JC[i]);
	}
	fclose(fileCOOJC);

    free(AA);
    free(JR);
    free(JC);
    free(A);
    return 0;
}