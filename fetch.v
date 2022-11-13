module fetch();
integer fd;
parameter N = 100000;
reg[27:0] ic[N:0];
initial begin
    //Enter the trace-sample file name accordingly
    $readmemh("Traces/code(qs).bin",ic);
end
endmodule