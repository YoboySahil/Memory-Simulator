module fetch();
integer fd;
reg[47:0] ic[99:0];
initial begin
    $readmemb("code.bin",ic);
end
endmodule