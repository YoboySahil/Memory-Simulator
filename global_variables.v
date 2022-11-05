module global_variables();
    // integer n;
    // initial n = 2;
    integer main_memory[1023:0][3:0];
    integer cache_memory_tag[7:0][3:0];
    integer cache_memory_data[7:0][3:0][3:0];
    reg valid_bit[7:0][3:0];
    reg modified_bit[7:0][3:0];
    integer latest_use[7:0][3:0];
    integer i, j;
    initial begin
        for(i=0; i<1024; i++) begin
            for(j=0; j<4; j++) begin
                main_memory[i][j]=i+j;
            end
        end
    end
    initial begin
        for(i=0; i<8; i++)
        begin
            for(j=0; j<4; j++)
            begin
                valid_bit[i][j]=1'b0;
                modified_bit[i][j]=1'b0;
                latest_use[i][j]=-1;
            end
        end
    end
endmodule