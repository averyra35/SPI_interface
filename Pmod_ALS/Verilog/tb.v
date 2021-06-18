`timescale 1ns / 1ps


module tb;

reg clk_tb;
reg Din_tb;
wire sclk_tb;
wire cs_tb;
wire [7:0] o_RX_Byte_tb;
wire [7:0] clk_div_tb;
wire [7:0] counter_tb;
wire cs_mon_tb;
wire sclk_mon_tb;
wire Din_mon_tb;
reg i_Start_tb;
wire o_RX_DV;
wire [11:0] o_BCD_tb;
wire o_DV_tb;
reg [1:0] counter;
wire[3:0] AN;
wire [7:0] CA;

initial begin
clk_tb = 1;
Din_tb = 0;
i_Start_tb = 0;
counter = 4'b0000;
end

always begin
    #5 clk_tb = !clk_tb;
end

always @ (posedge o_RX_DV or posedge o_DV_tb) begin
    if(counter == 4'b0000) begin
        i_Start_tb <= 1'b1;
        counter <= counter + 4'd1;
    end
    else begin
        if((counter == 4'd15) | (o_DV_tb == 1'b1)) begin
            counter <= 4'd0;
            i_Start_tb <= 1'b0;
        end
        else
            counter <= counter + 4'd1;
     end
end

/*
always @ (posedge cs_tb)begin
    i_Start_tb <= 1'b0;
end
*/

always @(negedge sclk_tb)begin
    if(cs_tb == 1'b0) begin
        Din_tb <= 1'b0;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b1;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b1;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b1;//1
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b1;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b0;
        #520 Din_tb <= 1'b0;
        #260 Din_tb <= 1'b0;
                
    end
end

spi_interface spi_interface_inst_tb(
    .clk(clk_tb), 
    .Din(Din_tb), 
    .sclk(sclk_tb), 
    .cs(cs_tb),  
    .o_RX_Byte(o_RX_Byte_tb), 
    .clk_div(clk_div_tb), 
    .counter(counter_tb), 
    .cs_mon(cs_mon_tb), 
    .sclk_mon(sclk_mon_tb), 
    .Din_mon(Din_mon_tb),
    .o_RX_DV(o_RX_DV)
);

double_dabble double_dabble_tb_inst1(
    .i_Clock(sclk_tb),
    .i_Binary(o_RX_Byte_tb),
    .i_Start(i_Start_tb),
    .o_BCD(o_BCD_tb),
    .o_DV(o_DV_tb)
);

seven_segment_display seven_segment_display_inst1(
    .clk(clk_tb),
    .digit0(o_BCD_tb[3:0]),
    .digit1(o_BCD_tb[7:4]),
    .digit2(o_BCD_tb[11:8]),
    .digit3(4'b0000),
    .AN(AN),
    .CA(CA)
);

endmodule