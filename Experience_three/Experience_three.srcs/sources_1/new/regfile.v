`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////


module regfile(
    input             clk,
    input             wen,
    input      [3 :0] raddr1,
    input      [3 :0] raddr2,
    input      [3 :0] waddr,
    input      [63:0] wdata,
    output reg [63:0] rdata1,
    output reg [63:0] rdata2,
    input      [4:0] test_addr,
    output reg [63:0] test_data
    );
    reg [63:0] rf[15:0];
     
    // three ported register file
    // read two ports combinationally
    // write third port on rising edge of clock
    // register 0 hardwired to 0

    always @(posedge clk)
    begin
        if (wen) 
        begin
            rf[waddr] <= wdata;
        end
    end
     

    always @(*)
    begin
        case (raddr1)
            4'd1 : rdata1 <= rf[1 ];
            4'd2 : rdata1 <= rf[2 ];
            4'd3 : rdata1 <= rf[3 ];
            4'd4 : rdata1 <= rf[4 ];
            4'd5 : rdata1 <= rf[5 ];
            4'd6 : rdata1 <= rf[6 ];
            4'd7 : rdata1 <= rf[7 ];
            4'd8 : rdata1 <= rf[8 ];
            4'd9 : rdata1 <= rf[9 ];
            4'd10: rdata1 <= rf[10];
            4'd11: rdata1 <= rf[11];
            4'd12: rdata1 <= rf[12];
            4'd13: rdata1 <= rf[13];
            4'd14: rdata1 <= rf[14];
            4'd15: rdata1 <= rf[15];
            default : rdata1 <= 64'd0;
        endcase
    end

    always @(*)
    begin
        case (raddr2)
            4'd1 : rdata2 <= rf[1 ];
            4'd2 : rdata2 <= rf[2 ];
            4'd3 : rdata2 <= rf[3 ];
            4'd4 : rdata2 <= rf[4 ];
            4'd5 : rdata2 <= rf[5 ];
            4'd6 : rdata2 <= rf[6 ];
            4'd7 : rdata2 <= rf[7 ];
            4'd8 : rdata2 <= rf[8 ];
            4'd9 : rdata2 <= rf[9 ];
            4'd10: rdata2 <= rf[10];
            4'd11: rdata2 <= rf[11];
            4'd12: rdata2 <= rf[12];
            4'd13: rdata2 <= rf[13];
            4'd14: rdata2 <= rf[14];
            4'd15: rdata2 <= rf[15];
            default : rdata2 <= 64'd0;
        endcase
    end
     
    always @(*)
    begin
        case (test_addr)
            //5'd1 : test_data <= rf[1 ];
            5'd2 : test_data <= rf[1 ];
            5'd3 : test_data <= rf[1 ];
            5'd4 : test_data <= rf[2 ];
            5'd5 : test_data <= rf[2 ];
            5'd6 : test_data <= rf[3 ];
            5'd7 : test_data <= rf[3 ];
            5'd8 : test_data <= rf[4 ];
            5'd9 : test_data <= rf[4 ];
            5'd10: test_data <= rf[5 ];
            5'd11: test_data <= rf[5 ];
            5'd12: test_data <= rf[6 ];
            5'd13: test_data <= rf[6 ];
            5'd14: test_data <= rf[7 ];
            5'd15: test_data <= rf[7 ];
            5'd16: test_data <= rf[8 ];
            5'd17: test_data <= rf[8 ];
            5'd18: test_data <= rf[9 ];
            5'd19: test_data <= rf[9 ];
            5'd20: test_data <= rf[10];
            5'd21: test_data <= rf[10];
            5'd22: test_data <= rf[11];
            5'd23: test_data <= rf[11];
            5'd24: test_data <= rf[12];
            5'd25: test_data <= rf[12];
            5'd26: test_data <= rf[13];
            5'd27: test_data <= rf[13];
            5'd28: test_data <= rf[14];
            5'd29: test_data <= rf[14];
            5'd30: test_data <= rf[15];
            5'd31: test_data <= rf[15];
            default : test_data <= 64'd0;           
        endcase
    end
endmodule

