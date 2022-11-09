module fetch();
integer fd;
reg[47:0] ic[10020:0];
initial begin
    $readmemb("code.bin",ic);
end
endmodule