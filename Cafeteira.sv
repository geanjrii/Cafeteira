module Cafeteira(tipo, clock, reset, c, l, f);

	input[1:0] tipo;
	
	input clock, reset;
	
	output logic c, l, f;
	
	logic[1:0] estado;
	
	parameter cafe = 0, leite = 1, pronto = 2;
	
	int cafe_clk = 0, leite_clk = 0;
	
	always_ff @(posedge clock, posedge reset) begin
		if(reset) begin
			estado <= cafe;
		end
		else begin
			case(estado)
			cafe: begin
				cafe_clk += 1;
				if((tipo == 2'b00 && cafe_clk == 2) || (tipo == 2'b01 && cafe_clk == 4)) begin
					estado <= pronto;
				end
				else if(tipo == 2'b10 && cafe_clk == 2) estado <= leite;
			end
			leite: begin
				leite_clk += 1;
				if(leite_clk == 2) begin
					estado <= pronto;
				end
			end
			pronto: begin
				cafe_clk = 0;
				leite_clk = 0;
				estado <= cafe;
			end
			endcase
		end
	end
	
	always_comb begin
		case(estado)
		cafe: begin
			c = 1'b1; l = 1'b0; f = 1'b0;
		end
		leite: begin
			c = 1'b0; l = 1'b1; f = 1'b0;
		end
		pronto: begin
			c = 1'b0; l = 1'b0; f = 1'b1;
		end
		endcase
	end
endmodule
