`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 12:38:11
// Design Name: 
// Module Name: regfile_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


 module regfile_display(
    //ʱ���븴λ�ź�
    input clk,
    input resetn,    //��׺"n"����͵�ƽ��Ч

    //���뿪�أ����ڲ���дʹ�ܺ�ѡ��������
    input wen,
    input [2:0] input_sel,

    //led�ƣ�����ָʾдʹ���źţ�����������ʲô����
    output led_wen,
    output led_waddr,    //ָʾ����д��ַ
    output led_wdata_low,    //ָʾ����д���ݵ͵�ַ
    output led_wdata_high,    //ָʾ����д���ݸߵ�ַ
    output led_raddr1,   //ָʾ�������ַ1
    output led_raddr2,   //ָʾ�������ַ2

    //��������ؽӿڣ�����Ҫ����
    output lcd_rst,
    output lcd_cs,
    output lcd_rs,
    output lcd_wr,
    output lcd_rd,
    inout[15:0] lcd_data_io,
    output lcd_bl_ctr,
    inout ct_int,
    inout ct_sda,
    output ct_scl,
    output ct_rstn
);
//-----{LED��ʾ}begin
    assign led_wen    = wen;
    assign led_raddr1 = (input_sel==3'd0);
    assign led_raddr2 = (input_sel==3'd1);
    assign led_waddr  = (input_sel==3'd2);
    assign led_wdata_high  = (input_sel==3'd3);
    assign led_wdata_low  = (input_sel==3'd4);
//-----{LED��ʾ}end

//-----{���üĴ�����ģ��}begin
    //�Ĵ����Ѷ�����һ�����˿ڣ������ڴ���������ʾ32���Ĵ���ֵ
    wire [63:0] test_data;  
    wire [4 :0] test_addr;

    reg  [3 :0] raddr1;
    reg  [3 :0] raddr2;
    reg  [3 :0] waddr;
    reg  [63:0] wdata;
    wire [63:0] rdata1;
    wire [63:0] rdata2;
    regfile rf_module(
        .clk   (clk   ),
        .wen   (wen   ),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr (waddr ),
        .wdata (wdata ),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .test_addr(test_addr),
        .test_data(test_data)
    );
//-----{���üĴ�����ģ��}end

//---------------------{���ô�����ģ��}begin--------------------//
//-----{ʵ����������}begin
//��С�ڲ���Ҫ����
    reg         display_valid;
    reg  [39:0] display_name;
    reg  [31:0] display_value;
    wire [5 :0] display_number;
    wire        input_valid;
    wire [31:0] input_value;

    lcd_module lcd_module(
        .clk            (clk           ),   //10Mhz
        .resetn         (resetn        ),

        //���ô������Ľӿ�
        .display_valid  (display_valid ),
        .display_name   (display_name  ),
        .display_value  (display_value ),
        .display_number (display_number),
        .input_valid    (input_valid   ),
        .input_value    (input_value   ),

        //lcd��������ؽӿڣ�����Ҫ����
        .lcd_rst        (lcd_rst       ),
        .lcd_cs         (lcd_cs        ),
        .lcd_rs         (lcd_rs        ),
        .lcd_wr         (lcd_wr        ),
        .lcd_rd         (lcd_rd        ),
        .lcd_data_io    (lcd_data_io   ),
        .lcd_bl_ctr     (lcd_bl_ctr    ),
        .ct_int         (ct_int        ),
        .ct_sda         (ct_sda        ),
        .ct_scl         (ct_scl        ),
        .ct_rstn        (ct_rstn       )
    ); 
//-----{ʵ����������}end

//-----{�Ӵ�������ȡ����}begin
//����ʵ����Ҫ��������޸Ĵ�С�ڣ�
//�����ÿһ���������룬��д����һ��always��
    //16���Ĵ�����ʾ��11~42�ŵ���ʾ�飬�ʶ���ַΪ��display_number-1��
    assign test_addr = display_number-5'd11; 
    //��input_selΪ3'b000ʱ����ʾ������Ϊ����ַ1����raddr1
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            raddr1 <= 8'd0;
        end
        else if (input_valid &&  input_sel==3'd0)
        begin
            raddr1 <= input_value[7:0];
        end
    end
    
    //��input_selΪ3'b001ʱ����ʾ������Ϊ����ַ2����raddr2
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            raddr2 <= 8'd0;
        end
        else if (input_valid && input_sel==3'd1)
        begin
            raddr2 <= input_value[7:0];
        end
    end
    
    //��input_selΪ3'b010ʱ����ʾ������Ϊд��ַ����waddr
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            waddr  <= 8'd0;
        end
        else if (input_valid && input_sel==3'd2)
        begin
            waddr  <= input_value[7:0];
        end
    end
    
    //��input_selΪ3'b011ʱ����ʾ������Ϊд���ݸ�32λ����wdata_high
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            wdata[63:32]  <= 32'd0;
        end
        else if (input_valid && input_sel==3'd3)
        begin
            wdata[63:32]  <= input_value;     
        end
    end
    
    //��input_selΪ3'b100ʱ����ʾ������Ϊд���ݵ�32λ����wdata_low
        always @(posedge clk)
        begin
            if (!resetn)
            begin
                wdata[31:0]  <= 32'd0;
            end
            else if (input_valid && input_sel==3'd4)
            begin
                wdata[31:0]  <= input_value;     
            end
        end
//-----{�Ӵ�������ȡ����}end

wire [3:0]temp;
assign temp=test_addr>>1;
//-----{�������������ʾ}begin
//������Ҫ��ʾ�����޸Ĵ�С�ڣ�
//�������Ϲ���44����ʾ���򣬿���ʾ44��32λ����
//44����ʾ�����1��ʼ��ţ����Ϊ1~44��
    always @(posedge clk)
    begin
        if (display_number >6'd10 && display_number <6'd43 )
        begin //���11~42��ʾ32��ͨ�üĴ�����ֵ
            display_valid <= 1'b1;
            //display_name[15: 8] <= {4'b0011,temp};
            display_name[7 : 0] <= {4'b0011,temp}; 
            //display_name[15: 0] <= {4'b0000,4'b0000,4'b0000,test_addr[4:0]};
            if(test_addr % 2 == 0)
            begin
               display_name[39:8] <= "RG_H";
               display_value       <= test_data[63:32];
            end
            else if(test_addr % 2 != 0)
            begin
               display_name[39:8] <= "RG_L";
               display_value       <= test_data[31:0];
            end
          end
        /*else if (display_number >6'd10 && display_number <6'd43 && display_number % 2 == 0)
          begin //���11~42��ʾ32��ͨ�üĴ�����ֵ
              display_valid <= 1'b1;
              display_name[39:16] <= "R_L";
              display_name[15: 8] <= {4'b0011,3'b000,test_addr[3]};
              display_name[7 : 0] <= {4'b0011,test_addr[2:0]}; 
              display_value       <= test_data[31:0];
            end      */    
        else
        begin
            case(display_number)
                6'd1 : //��ʾ���˿�1�ĵ�ַ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RADD1";
                    display_value <= raddr1;
                end
                6'd2 : //��ʾ���˿�2�ĵ�ַ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RADD2";
                    display_value <= raddr2;
                end
                6'd3 : //��ʾ���˿�1�����ĸ�32λ����
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RD1_H";
                    display_value <= rdata1[63:32];
                end
                6'd4 : //��ʾ���˿�1�����ĵ�32λ����
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RD1_L";
                    display_value <= rdata1[31:0];
                end
                6'd5 : //��ʾ���˿�2�����ĸ�32λ����
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RD2_H";
                    display_value <= rdata2[63:32];
                end
                6'd6 : //��ʾ���˿�2�����ĵ�32λ����
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RD2_L";
                    display_value <= rdata2[31:0];
                end                
                6'd7 : //��ʾд�˿ڵĵ�ַ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WADDR";
                    display_value <= waddr;
                end
                6'd9 : //��ʾд�˿�д��ĸ�32λ����
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WAD_H";
                    display_value <= wdata[63:32];
                end
                6'd10 : //��ʾд�˿�д��ĵ�32λ����
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WAD_L";
                    display_value <= wdata[31:0];
                end                
                default :
                begin
                    display_valid <= 1'b0;
                    display_name  <= 40'd0;
                    display_value <= 32'd0;
                end
            endcase
        end
    end
//-----{�������������ʾ}end
//----------------------{���ô�����ģ��}end---------------------//
endmodule

