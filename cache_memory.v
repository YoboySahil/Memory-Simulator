`include "global_variables.v"
`include "fetch.v"

module cache_memory();
reg[47:0] instruction;
reg[3:0] code;
reg[9:0] m_address, temp_m_address;
reg[6:0] tag;
reg[2:0] set_index;
reg[1:0] block_offset;
reg[31:0] data;
integer i, pc, r_ind, j, k;
reg is_read_hit;
reg is_write_hit;
integer min;
integer count;

initial begin
    count = 0;
    pc = 0;
    while(1)
    begin
        #10
        instruction = fetch.ic[pc];
        code = instruction[47:44];
        m_address = instruction[43:34];
        tag = instruction[43:37];
        set_index = instruction[36:34];
        block_offset = instruction[33:32];
        data = instruction[31:0];
        is_read_hit = 1'b0;
        is_write_hit = 1'b0;
        if(code == 4'b0000)                                   //read instruction
        begin
            for(i=0; i<4; i++) begin
                if(global_variables.cache_memory_tag[set_index][i] == tag  && global_variables.valid_bit[set_index][i] == 1'b1 && is_read_hit == 1'b0)              //read-hit condition
                begin
                    global_variables.cache_memory_data[set_index][r_ind][block_offset] = global_variables.main_memory[m_address][block_offset];
                    $display("READ HIT");
                    $display("OUTPUT TO PROCESSOR ", global_variables.cache_memory_data[set_index][i][block_offset]);
                    is_read_hit = 1'b1;
                    global_variables.latest_use[set_index][i] = pc;
                end
            end

            if(is_read_hit == 1'b0)                         //read miss
            begin
                min=10000;
                for(i=0;i<4;i++)begin
                    $display(i);
                    $display(global_variables.latest_use[set_index][i]);
                    if(global_variables.latest_use[set_index][i]<min)begin
                        min=global_variables.latest_use[set_index][i];
                        r_ind=i;
                    end
                end
                $display("READ MISS");
                if(global_variables.modified_bit[set_index][r_ind] == 1'b1)
                begin
                    temp_m_address[9:3] = global_variables.cache_memory_tag[set_index][r_ind];
                    temp_m_address[2:0] = set_index;
                    global_variables.main_memory[temp_m_address][block_offset] = global_variables.cache_memory_data[set_index][r_ind][block_offset];                   //Write allocate in read hit
                    global_variables.modified_bit[set_index][r_ind] = 1'b0;
                end
                global_variables.cache_memory_tag[set_index][r_ind] = tag;
                for(i=0; i<4; i++)
                begin
                    global_variables.cache_memory_data[set_index][r_ind][i] = global_variables.main_memory[m_address][i];
                end
                global_variables.valid_bit[set_index][r_ind] = 1'b1;
                global_variables.latest_use[set_index][r_ind] = pc;
                $display("OUTPUT TO PROCESSOR ", global_variables.cache_memory_data[set_index][r_ind][block_offset]);
            end
        end
        
        else if(code == 4'b1111)                              //write instruction
        begin
            for(i=0; i<4; i++) begin
                if(global_variables.cache_memory_tag[set_index][i] == tag && is_write_hit == 1'b0)              //write-hit condition
                begin
                    $display("WRITE HIT");
                    global_variables.cache_memory_data[set_index][i][block_offset] = data;
                    global_variables.modified_bit[set_index][i] = 1'b1;
                    global_variables.valid_bit[set_index][i] = 1'b1;
                    is_write_hit = 1'b1;
                    global_variables.latest_use[set_index][i] = pc;
                end
            end

            if(is_write_hit == 1'b0)                        //write miss
            begin
                min=10000;
                for(i=0;i<4;i++)begin
                    if(global_variables.latest_use[set_index][i]<min)begin
                        min=global_variables.latest_use[set_index][i];
                        r_ind=i;
                    end
                end
                $display("WRITE MISS");
                if(global_variables.modified_bit[set_index][r_ind] == 1'b1)
                begin
                    $display("replaced!!!");
                    temp_m_address[9:3] = global_variables.cache_memory_tag[set_index][r_ind];
                    temp_m_address[2:0] = set_index;
                    global_variables.main_memory[temp_m_address][block_offset] = global_variables.cache_memory_data[set_index][r_ind][block_offset];                   //Write allocate in read hit
                    global_variables.modified_bit[set_index][r_ind] = 1'b0;
                end
                global_variables.cache_memory_tag[set_index][r_ind] = tag;
                global_variables.cache_memory_data[set_index][r_ind][block_offset] = data;
                for(i=0; i<4; i++)
                begin
                    if(i!=block_offset)
                        global_variables.cache_memory_data[set_index][r_ind][i] = global_variables.main_memory[m_address][i];
                end
                global_variables.valid_bit[set_index][r_ind] = 1'b1;
                global_variables.modified_bit[set_index][r_ind] = 1'b1;
                global_variables.latest_use[set_index][r_ind] = pc;
            end
        end
        for(i=0; i<8; i++)
        begin
            $display("set no",i);
            for(j=0; j<4; j++)
            begin
                $display("Line No. :",j," Tag ",global_variables.cache_memory_tag[i][j]);
                for(k=0;k<4;k++)begin
                    $display("Word No. :",k, global_variables.cache_memory_data[i][j][k]);
                end
                $display("Valid Bit: ",global_variables.valid_bit[i][j],", Modified Bit: ",global_variables.modified_bit[i][j]);
                
            end
        end
        if(is_read_hit | is_write_hit)
            count++;
        if(instruction == 47'b0)
        begin
            $display("PROGRAM HALTED");
            $display("Hit Rate = ",count, "/", pc);
            $finish;
        end
        pc++;
    end
end

endmodule