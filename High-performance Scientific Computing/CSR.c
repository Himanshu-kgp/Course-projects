#include <stdio.h>
#include <stdlib.h>


int* CSR(int n, double **A, double *AA, int *JA, int *IA){

    int ii = 0;
    int jj = 0;
    int flag = 0;


    for(int i = 0;i<n;i++){
        flag = 0;
        for(int j =0;j<n;j++){
            if(A[i][j]!=0){
                AA[ii] = A[i][j];
                JA[ii] = j;
                if(flag == 0){
                    IA[jj] = ii;
                    jj++;
                    flag = 1;
                }
                ii ++;
            }
        }
    }

    IA[jj] = ii + 1;
    jj ++ ;
    int *ans;
    ans = (int *)malloc(2*sizeof(int));
    *(ans+1) = ii;
    *(ans+2) = jj;
    return ans;

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
    int *JA, *IA;
    AA =  (double *)malloc(n*n*sizeof(double));
    JA =  (int *)malloc(n*n*sizeof(int));
    IA =  (int *)malloc(n*n*sizeof(int));;

    ans = CSR(n, A, AA, JA, IA);

    int nnz = ans[1];
    int lengthIA = ans[2];

    // printf("%d\n", lengthIA);

    FILE *fileCSRKmat = fopen("./problem_data/CSRKmat.txt", "w");
	
	for(int i =0;i<nnz; i++){
		fprintf(fileCSRKmat,"%.12f\n", AA[i]);
	}
	fclose(fileCSRKmat);

    FILE *fileCSRJA = fopen("./problem_data/CSRJA.txt", "w");
	
	for(int i =0;i<nnz; i++){
		fprintf(fileCSRJA,"%d\n", JA[i]);
	}
	fclose(fileCSRJA);

    FILE *fileCSRIA = fopen("./problem_data/CSRIA.txt", "w");
	
	for(int i =0;i<lengthIA; i++){
		fprintf(fileCSRIA,"%d\n", IA[i]);
	}
	fclose(fileCSRIA);

    free(AA);
    free(JA);
    free(IA);
    free(A);
    return 0;
}