`timescale 1ns / 1ps
module fifo_rtl( input clk,
    input reset,
    input write_en,
    input read_en,
    input [7:0] write_data,
    output full,
    output reg [7:0] read_data,
    output empty

    );
    reg [7:0]memory[0:15];
    reg [3:0] write_pointer;
    reg [3:0] read_pointer;
    reg[4:0] counter;
    assign empty=(counter==5'd0);
    assign full=(counter==5'd16);
    always @(posedge clk)
    begin
        if(reset)
        begin
            write_pointer<=1'b0;
            read_pointer<=1'b0;
            counter<=1'b0;
            read_data<=1'b0;
            
        end
        
        else
        begin
            if(read_en && !empty) 
            begin
                read_data<=memory[read_pointer];
                read_pointer<=read_pointer+1'b1;
            end 
            if(write_en && !full)
            begin
                memory[write_pointer]<=write_data;
                write_pointer<=write_pointer+1'b1;
            end
            if(read_en && !empty && !(write_en && !full))
            counter<=counter-1'b1;
            if(write_en && !full && !(read_en && !empty))
            counter<=counter+1'b1;
               
        end
        
    end
    
endmodule
