module alu(input [31:0] a, b, //ALU_inputs. 
input [2:0] f,		        //ALU_control_bit to control ALU operation.
output reg [31:0] y,		        //ALU_output.
output reg zero);                 //Zero_indicator_bit to indicate zero value output.

//This is switch case on the control bits that control the operation of the ALU.
always @(f,a,b)
	begin
	case(f)
	//AND_operation
	0: y <= a & b;
	//OR_operation
	1: y <= a | b;
	//ADD_operation
	2: y <= a + b;                                           
	//SUB_operation
	6: y <= a +(~b+1);
	//SLT_operation
	7: begin 
		if (a[31] != b[31]) begin
					if (a[31] > b[31]) begin
						y <= 1;
					end else begin
						y <= 0;
					end
				end else begin
					if (a < b)
					begin
						y <= 1;
					end
					else
					begin
						y <= 0;
					end
				end
           end
	endcase
	end

//Checking the zero flag bit that indicate the zero value output
always @(y) 
	begin
	if (y == 0) begin
			zero <= 1;
	end else begin
			zero <= 0;
	end
	
	end
endmodule