`include "global_variables.v"
`include "fetch.v"

module cache_memory();
    //Enter the memory-cache dimensions in the below 4 parameters
    parameter ways = 16;
    parameter SET = 8;
    parameter MEM = 24;
    parameter BO = 2;

    reg[MEM + 3:0] instruction;
    reg[3:0] code;
    reg[MEM-BO-1:0] m_address, temp_m_address;
    reg[MEM-SET-BO-1:0] tag;
    reg[SET-1:0] set_index;
    reg[BO-1:0] block_offset;
    reg[31:0] data;
    integer i, pc, r_ind, j, k;
    reg is_read_hit;
    reg is_write_hit;
    integer min;
    integer count;

    initial begin
        count = 0;
        for(pc=0; pc<100000; pc++)
        begin
            #10
            instruction = fetch.ic[pc];
            m_address = instruction[MEM-1:BO];
            code = instruction[MEM+3:MEM];
            tag = instruction[MEM-1:SET+2];
            set_index = instruction[SET+1:BO];
            block_offset = instruction[BO-1:0];
            data = 69;
            is_read_hit = 1'b0;
            is_write_hit = 1'b0;
            $display(pc);
            if(code == 4'b0001)                                   //read instruction
            begin
                for(i=0; i<ways; i++) begin
                    if(global_variables.cache_memory_tag[set_index][i] == tag  && global_variables.valid_bit[set_index][i] == 1'b1 && is_read_hit == 1'b0)              //read-hit condition
                    begin
                        global_variables.cache_memory_data[set_index][i][block_offset] = global_variables.main_memory[m_address][block_offset];
                        is_read_hit = 1'b1;
                        global_variables.latest_use[set_index][i] = pc;
                    end
                end

                if(is_read_hit == 1'b0)                         //read-miss
                begin
                    min=10000;
                    for(i=0;i<ways;i++)begin
                        if(global_variables.latest_use[set_index][i]<min)begin
                            min=global_variables.latest_use[set_index][i];
                            r_ind=i;
                        end
                    end
                    if(global_variables.modified_bit[set_index][r_ind] == 1'b1)
                    begin
                        temp_m_address[MEM-3:SET] = global_variables.cache_memory_tag[set_index][r_ind];
                        temp_m_address[SET-1:0] = set_index;
                        global_variables.main_memory[temp_m_address][block_offset] = global_variables.cache_memory_data[set_index][r_ind][block_offset];                   //Write allocate in read hit
                        global_variables.modified_bit[set_index][r_ind] = 1'b0;
                    end
                    global_variables.cache_memory_tag[set_index][r_ind] = tag;
                    for(i=0; i<ways; i++)
                    begin
                        global_variables.cache_memory_data[set_index][r_ind][i] = global_variables.main_memory[m_address][i];
                    end
                    global_variables.valid_bit[set_index][r_ind] = 1'b1;
                    global_variables.latest_use[set_index][r_ind] = pc;
                end
            end
            
            else if(code == 4'b0010)                              //write instruction
            begin
                for(i=0; i<ways; i++) begin
                    if(global_variables.cache_memory_tag[set_index][i] == tag && is_write_hit == 1'b0)              //write-hit condition
                    begin
                        global_variables.cache_memory_data[set_index][i][block_offset] = data;
                        global_variables.modified_bit[set_index][i] = 1'b1;
                        global_variables.valid_bit[set_index][i] = 1'b1;
                        is_write_hit = 1'b1;
                        global_variables.latest_use[set_index][i] = pc;
                    end
                end

                if(is_write_hit == 1'b0)                        //write-miss
                begin
                    min=10000;
                    for(i=0;i<ways;i++)begin
                        if(global_variables.latest_use[set_index][i]<min)begin
                            min=global_variables.latest_use[set_index][i];
                            r_ind=i;
                        end
                    end
                    if(global_variables.modified_bit[set_index][r_ind] == 1'b1)
                    begin
                        // $display("replaced!!!");
                        temp_m_address[MEM-3:SET] = global_variables.cache_memory_tag[set_index][r_ind];
                        temp_m_address[SET-1:0] = set_index;
                        global_variables.main_memory[temp_m_address][block_offset] = global_variables.cache_memory_data[set_index][r_ind][block_offset];                   //Write allocate in read hit
                        global_variables.modified_bit[set_index][r_ind] = 1'b0;
                    end
                    global_variables.cache_memory_tag[set_index][r_ind] = tag;
                    global_variables.cache_memory_data[set_index][r_ind][block_offset] = data;
                    for(i=0; i<(2**BO); i++)
                    begin
                        if(i!=block_offset)
                            global_variables.cache_memory_data[set_index][r_ind][i] = global_variables.main_memory[m_address][i];
                    end
                    global_variables.valid_bit[set_index][r_ind] = 1'b1;
                    global_variables.modified_bit[set_index][r_ind] = 1'b1;
                    global_variables.latest_use[set_index][r_ind] = pc;
                end
            end
            if(is_read_hit | is_write_hit)
                count++;
            if(instruction == 0 )
            begin
                $display("PROGRAM HALTED");
                $display(count, "/", pc);
                $finish;
            end
        end
    end
endmodule