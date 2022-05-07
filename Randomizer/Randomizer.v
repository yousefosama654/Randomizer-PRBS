module Randomizer (clk, rst, enable, load,DataIn,seed,DataOut);

input clk,enable,rst,load,DataIn ;
input [14:0]seed;
output reg DataOut;

reg XOR;
reg [14:0]data;
initial data=15'b101010001110110;
always @(posedge clk or posedge rst )begin
if(rst)
data<=0;
else if(load)
data<=seed;
else begin
XOR=data[13]^data[14];
data={ data[13:0],XOR };
DataOut=XOR ^ DataIn;
end

end

endmodule


module tb();
reg clk,rst,enable,load;
reg DataIn;
reg [14:0]Seed;
wire  DataOut;
LinearFeedbackShiftRegister obj (clk, rst, enable, load,DataIn,Seed,DataOut);

always begin
clk=~clk; #5;
end

initial begin
clk=0;rst=0;enable=1;load=0;DataIn=0;Seed=4;
#10 DataIn=1;
#10 DataIn=0;
#10 DataIn=1;
#10 DataIn=0;


end
endmodule

/************************************************************************/
module randomizer_tb();

//internal signals
reg clk;
reg reset;
reg en;
reg l;
reg [14:0] s;
reg d;
wire q;
reg [95:0]in_p;
reg [95:0] out_p;
integer i;
wire [95:0] expectedOut;
assign expectedOut=96'h558AC4A53A1724E163AC2BF9;
localparam PERIOD = 10;
Randomizer UUT(
clk, reset, en,l,d,s,q
);
always begin
	clk = ~clk;
        #(PERIOD/10);
end
initial begin
	clk = 1;
   en=1;
	l =0;
	reset = 1'b0;
	in_p = 96'hACBCD2114DAE1577C6DBF4C9;
	out_p =96'h000000000000000000000000;
	d = 1'b0;
	for(i=95; i> -1; i=i-1)
	begin
	d = in_p[i];	
        #(PERIOD/5);
	out_p[i] = q ;
        
	end
if(out_p==expectedOut) 
$display("SUCCESS");

else begin
 $display("FAILED");
end 
end

endmodule
