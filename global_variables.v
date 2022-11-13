module global_variables();
    //Enter the memory-cache dimensions in the below 4 parameters
    parameter n = 16;
    parameter SET = 8;
    parameter MEM = 24;
    parameter BO = 2;

    reg[7:0] main_memory[(2**MEM) - 1:0][n-1:0];
    integer cache_memory_tag[(2**SET)-1:0][n-1:0];  //change
    reg[7:0] cache_memory_data[(2**SET)-1:0][n-1:0][(2**BO)-1:0];
    reg valid_bit[(2**SET)-1:0][n-1:0];
    reg modified_bit[(2**SET)-1:0][n-1:0];
    integer latest_use[(2**SET)-1:0][n-1:0];
    integer i, j;
    initial begin
        for(i=0; i<(2**SET); i++)
        begin
            for(j=0; j<n; j++)
            begin
                valid_bit[i][j]=1'b0;
                modified_bit[i][j]=1'b0;
                latest_use[i][j]=-1;
            end
        end
    end
endmodule