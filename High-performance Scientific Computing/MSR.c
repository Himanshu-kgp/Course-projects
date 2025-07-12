#include <stdio.h>
#include <stdlib.h>


int MSR(int n, double **A, double *AA, int *JA){

    int ii = 0;
    for(int i = 0;i<n;i++){
        AA[ii] = A[i][i];
        ii ++;
    }


    ii++;

    int jj = 0;
    int flag = 0;


    for(int i = 0;i<n;i++){
        flag = 0;
        for(int j=0;j<n;j++){
            if(i != j && A[i][j] != 0){
                JA[ii] = j;
                AA[ii] = A[i][j];
                if(flag == 0){
                    JA[jj] = ii ;
                    jj ++ ;
                    flag = 1;
                }
                ii++;
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


    int *ans; // non zero
    ans = (int *)malloc(2*sizeof(int));
    double *AA;
    int *JA;
    AA =  (double *)malloc(n*n*sizeof(double));
    JA =  (int *)malloc(n*n*sizeof(int));

    int nnz = MSR(n, A, AA, JA);

    // int nnz = ans[1];
    // int lengthIA = ans[2];

    // printf("%d\n", lengthIA);

    FILE *fileMSRKmat = fopen("./problem_data/MSRKmat.txt", "w");
	
	for(int i =0;i<nnz; i++){
		fprintf(fileMSRKmat,"%.12f\n", AA[i]);
	}
	fclose(fileMSRKmat);

    FILE *fileMSRJA = fopen("./problem_data/MSRJA.txt", "w");
	
	for(int i =0;i<nnz; i++){
		fprintf(fileMSRJA,"%d\n", JA[i]);
	}
	fclose(fileMSRJA);


    free(AA);
    free(JA);
    free(A);
    return 0;
}