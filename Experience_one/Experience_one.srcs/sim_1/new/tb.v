`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/23 15:50:58
// Design Name: 
// Module Name: tb
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


`timescale 1ns / 1ps   //���浥λʱ��Ϊ1ns������Ϊ1ps
module testbench;

    // Inputs
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [31:0] operand3;
    reg [31:0] operand4;
    reg cin;

    // Outputs
    wire [31:0] result;
    wire cout;
    wire cout2;
    // Instantiate the Unit Under Test (UUT)
    adder uut (
        .operand1(operand1), 
        .operand2(operand2), 
        .operand3(operand3), 
        .operand4(operand4), 
        .cin(cin), 
        .result(result), 
        .cout(cout),
        .cout2(cout2)
    );
    initial begin
        // Initialize Inputs
        operand1 = 0;
        operand2 = 0;
        operand3 = 0;
        operand4 = 0;
        cin = 0;
        // Wait 100 ns for global reset to finish
        #100;
        // Add stimulus here
    end
    always #10 operand1 = $random;  //$randomΪϵͳ���񣬲���һ�������32λ��
    always #10 operand2 = $random;  //#10 ��ʾ�ȴ�10����λʱ��(10ns)����ÿ��10ns����ֵһ�������32λ��
    always #10 operand3 = $random;
    always #10 operand4 = $random;
    always #10 cin = {$random} % 2; //����ƴ�ӷ���{$random}����һ���Ǹ�������2ȡ��õ�0��1
endmodule