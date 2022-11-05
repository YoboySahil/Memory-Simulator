module fetch();
integer fd;
reg[47:0] ic[99:0];
initial begin
    $readmemb("code.bin",ic);
    // $displayb(ic[0]);
    // $displayb(ic[1]);
end
endmodule