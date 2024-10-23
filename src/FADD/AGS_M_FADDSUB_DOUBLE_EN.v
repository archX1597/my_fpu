//      Floating point format

module  AGS_M_FADDSUB_DOUBLE_EN(ACLK, ARESETn, ENABLE, SOURCEA, SOURCEB, ADDSUB_CTRL, RESULT);

        // input

        input                   ACLK;
        input                   ARESETn;
		input			ENABLE;
        input   [31:0] SOURCEA;
        input   [31:0] SOURCEB;
        input                   ADDSUB_CTRL;            // (ADDSUB_CTRL) ? SUB : ADD;

        // output

        output  [31:0] RESULT;





        // internal signals

        wire [31:31]  srcA_sign;
        wire [31:31]  srcB_sign;
        wire [30:23]   srcA_exp;
        wire [30:23]   srcB_exp;
        wire [24:0]             srcA_frac;
        wire [24:0]             srcB_frac;

	wire [30:23]		srcB_exp_double;
	wire			expB_is_Greater;

        wire [8:0]              rest_AB_exp;
//        wire [8:0]              rest_BA_exp;
//        wire [4:0]              frac_hshift_cnt_AB;
//        wire [4:0]              frac_hshift_cnt_BA;

        wire [24:0]             srcA_frac_hshifted;
        wire [24:0]             srcB_frac_hshifted;

        wire [25:0]             result_frac_AB;
        wire [25:0]             result_frac_AxB;
        wire [25:0]             result_frac_BxA;

        reg                     dest_sign;
        reg [25:0]              result_frac;
        wire [7:0]              result_exp;
        wire [8:0]              result_exp_inc;

        reg                     dest_sign_reg;
        reg [25:0]              result_frac_reg;
        reg [7:0]               result_exp_reg;
        reg [8:0]               result_exp_inc_reg;

        reg                     end_frag_reg;
        reg [31:0]     result_reg;

//        wire [4:0]              frac_lshift_cnt;
        reg [4:0]              frac_lshift_cnt;
//        wire [23:0]             result_frac_lshifted;
        reg [23:0]             result_frac_lshifted;
        wire [8:0]              result_exp_sub;

//	wire	[24:0]		src_frac_hshifted;	
	reg	[24:0]		src_frac_hshifted;	
	wire	[24:0]		src_frac;
//	wire	[4:0]		frac_hshift_cnt;

        reg [31:0]     RESULT;


//
//      Phase First
//


        assign srcA_sign = SOURCEA[31:31];
        assign srcB_sign = SOURCEB[31:31] ^ ADDSUB_CTRL;
        assign srcA_exp = SOURCEA[30:23];
        assign srcB_exp = SOURCEB[30:23];

	assign srcB_exp_double = SOURCEB[30:23] + 1'b1;
	assign expB_is_Greater = (srcA_exp > srcB_exp) ? 1'b0 : 1'b1;

        assign srcA_frac = {1'b1, SOURCEA[22:0], 1'b0};
        assign srcB_frac = {1'b1, SOURCEB[22:0], 1'b0};

        assign rest_AB_exp = {1'b0, srcA_exp} - {1'b0, srcB_exp};

	assign src_frac = (expB_is_Greater) ? srcA_frac : srcB_frac;
/*
	always@(src_frac or rest_AB_exp)
	begin
		case(rest_AB_exp)
			9'b000000000:	src_frac_hshifted = {1'h0, src_frac[24:1]};
			9'b000000001:	src_frac_hshifted = src_frac;
			9'b000000010:	src_frac_hshifted = {1'h0, src_frac[24:1]};
			9'b000000011:	src_frac_hshifted = {2'h0, src_frac[24:2]};
			9'b000000100:	src_frac_hshifted = {3'h0, src_frac[24:3]};
			9'b000000101:	src_frac_hshifted = {4'h0, src_frac[24:4]};
			9'b000000110:	src_frac_hshifted = {5'h00, src_frac[24:5]};
			9'b000000111:	src_frac_hshifted = {6'h00, src_frac[24:6]};
			9'b000001000:	src_frac_hshifted = {7'h00, src_frac[24:7]};
			9'b000001001:	src_frac_hshifted = {8'h00, src_frac[24:8]};
			9'b000001010:	src_frac_hshifted = {9'h000, src_frac[24:9]};
			9'b000001011:	src_frac_hshifted = {10'h000, src_frac[24:10]};
			9'b000001100:	src_frac_hshifted = {11'h000, src_frac[24:11]};
			9'b000001101:	src_frac_hshifted = {12'h000, src_frac[24:12]};
			9'b000001110:	src_frac_hshifted = {13'h0000, src_frac[24:13]};
			9'b000001111:	src_frac_hshifted = {14'h0000, src_frac[24:14]};
			9'b000010000:	src_frac_hshifted = {15'h0000, src_frac[24:15]};
			9'b000010001:	src_frac_hshifted = {16'h0000, src_frac[24:16]};
			9'b000010010:	src_frac_hshifted = {17'h00000, src_frac[24:17]};
			9'b000010011:	src_frac_hshifted = {18'h00000, src_frac[24:18]};
			9'b000010100:	src_frac_hshifted = {19'h00000, src_frac[24:19]};
			9'b000010101:	src_frac_hshifted = {20'h00000, src_frac[24:20]};
			9'b000010110:	src_frac_hshifted = {21'h000000, src_frac[24:21]};
			9'b000010111:	src_frac_hshifted = {22'h000000, src_frac[24:22]};
			9'b000011000:	src_frac_hshifted = {23'h000000, src_frac[24:23]};
			9'b000011001:	src_frac_hshifted = {24'h000000, src_frac[24]};		

			9'b111101001:	src_frac_hshifted = {24'h000000, src_frac[24]};		
			9'b111101010:	src_frac_hshifted = {23'h000000, src_frac[24:23]};
			9'b111101011:	src_frac_hshifted = {22'h000000, src_frac[24:22]};
			9'b111101100:	src_frac_hshifted = {21'h000000, src_frac[24:21]};
			9'b111101101:	src_frac_hshifted = {20'h00000, src_frac[24:20]};
			9'b111101110:	src_frac_hshifted = {19'h00000, src_frac[24:19]};
			9'b111101111:	src_frac_hshifted = {18'h00000, src_frac[24:18]};
			9'b111110000:	src_frac_hshifted = {17'h00000, src_frac[24:17]};
			9'b111110001:	src_frac_hshifted = {16'h0000, src_frac[24:16]};
			9'b111110010:	src_frac_hshifted = {15'h0000, src_frac[24:15]};
			9'b111110011:	src_frac_hshifted = {14'h0000, src_frac[24:14]};
			9'b111110100:	src_frac_hshifted = {13'h0000, src_frac[24:13]};
			9'b111110101:	src_frac_hshifted = {12'h000, src_frac[24:12]};
			9'b111110110:	src_frac_hshifted = {11'h000, src_frac[24:11]};
			9'b111110111:	src_frac_hshifted = {10'h000, src_frac[24:10]};
			9'b111111000:	src_frac_hshifted = {9'h000, src_frac[24:9]};
			9'b111111001:	src_frac_hshifted = {8'h00, src_frac[24:8]};
			9'b111111010:	src_frac_hshifted = {7'h00, src_frac[24:7]};
			9'b111111011:	src_frac_hshifted = {6'h00, src_frac[24:6]};
			9'b111111100:	src_frac_hshifted = {5'h00, src_frac[24:5]};
			9'b111111101:	src_frac_hshifted = {4'h0, src_frac[24:4]};
			9'b111111110:	src_frac_hshifted = {3'h0, src_frac[24:3]};
			9'b111111111:	src_frac_hshifted = {2'h0, src_frac[24:2]};		

			default:	src_frac_hshifted = 25'h0000000;
		endcase
	end
*/
// nakamura
reg [25:0] g_tmp_src_frac;
reg [25:0] g_tmp1_src_frac_hshifted;
reg [25:0] g_tmp2_src_frac_hshifted;
reg [25:0] g_tmp3_src_frac_hshifted;
reg [25:0] g_tmp4_src_frac_hshifted;
reg [25:0] g_tmp5_src_frac_hshifted;
reg [25:0] g_tmp6_src_frac_hshifted;
always@(src_frac or rest_AB_exp)
begin
	if (rest_AB_exp[8]==1'b0) begin
		g_tmp_src_frac = {src_frac, 1'b0};
		if (rest_AB_exp[4]==1'b1) begin
			g_tmp1_src_frac_hshifted = {16'h0000, g_tmp_src_frac[25:16]};
		end else begin
			g_tmp1_src_frac_hshifted = g_tmp_src_frac;
		end
		if (rest_AB_exp[3]==1'b1) begin
			g_tmp2_src_frac_hshifted = {8'h00, g_tmp1_src_frac_hshifted[25:8]};
		end else begin
			g_tmp2_src_frac_hshifted = g_tmp1_src_frac_hshifted;
		end
		if (rest_AB_exp[2]==1'b1) begin
			g_tmp3_src_frac_hshifted = {4'h0, g_tmp2_src_frac_hshifted[25:4]};
		end else begin
			g_tmp3_src_frac_hshifted = g_tmp2_src_frac_hshifted;
		end
		if (rest_AB_exp[1]==1'b1) begin
			g_tmp4_src_frac_hshifted = {2'h0, g_tmp3_src_frac_hshifted[25:2]};
		end else begin
			g_tmp4_src_frac_hshifted = g_tmp3_src_frac_hshifted;
		end
		if (rest_AB_exp[0]==1'b1) begin
			g_tmp5_src_frac_hshifted = {1'h0, g_tmp4_src_frac_hshifted[25:1]};
		end else begin
			g_tmp5_src_frac_hshifted = g_tmp4_src_frac_hshifted;
		end
		if ((rest_AB_exp[7]==1'b1) | (rest_AB_exp[6]==1'b1) | (rest_AB_exp[5]==1'b1)) begin
			g_tmp6_src_frac_hshifted = 26'h0000000;
		end else if (rest_AB_exp==9'h000) begin
			g_tmp6_src_frac_hshifted = {2'h0, src_frac[24:1]};
		end else begin
			g_tmp6_src_frac_hshifted = g_tmp5_src_frac_hshifted;
		end
	end else begin //rest_AB_exp[8]==1'b1
		g_tmp_src_frac = {3'h0, src_frac[24:2]};
		if (rest_AB_exp[4]==1'b0) begin
			g_tmp1_src_frac_hshifted = {16'h0000, g_tmp_src_frac[25:16]};
		end else begin
			g_tmp1_src_frac_hshifted = g_tmp_src_frac;
		end
		if (rest_AB_exp[3]==1'b0) begin
			g_tmp2_src_frac_hshifted = {8'h00, g_tmp1_src_frac_hshifted[25:8]};
		end else begin
			g_tmp2_src_frac_hshifted = g_tmp1_src_frac_hshifted;
		end
		if (rest_AB_exp[2]==1'b0) begin
			g_tmp3_src_frac_hshifted = {4'h0, g_tmp2_src_frac_hshifted[25:4]};
		end else begin
			g_tmp3_src_frac_hshifted = g_tmp2_src_frac_hshifted;
		end
		if (rest_AB_exp[1]==1'b0) begin
			g_tmp4_src_frac_hshifted = {2'h0, g_tmp3_src_frac_hshifted[25:2]};
		end else begin
			g_tmp4_src_frac_hshifted = g_tmp3_src_frac_hshifted;
		end
		if (rest_AB_exp[0]==1'b0) begin
			g_tmp5_src_frac_hshifted = {1'h0, g_tmp4_src_frac_hshifted[25:1]};
		end else begin
			g_tmp5_src_frac_hshifted = g_tmp4_src_frac_hshifted;
		end
		if ((rest_AB_exp[7]==1'b0) | (rest_AB_exp[6]==1'b0) | (rest_AB_exp[5]==1'b0)) begin
			g_tmp6_src_frac_hshifted = 26'h0000000;
		end else begin
			g_tmp6_src_frac_hshifted = g_tmp5_src_frac_hshifted;
		end
	end
	src_frac_hshifted = g_tmp6_src_frac_hshifted[24:0];
end

        assign srcA_frac_hshifted = (expB_is_Greater) ? src_frac_hshifted : srcA_frac;
        assign srcB_frac_hshifted = (expB_is_Greater) ? srcB_frac : src_frac_hshifted;

        assign result_frac_AB = {1'b0, srcA_frac_hshifted} + {1'b0, srcB_frac_hshifted};
        assign result_frac_AxB = {1'b0, srcA_frac_hshifted} - {1'b0, srcB_frac_hshifted};
        assign result_frac_BxA = {1'b0, srcB_frac_hshifted} - {1'b0, srcA_frac_hshifted};

        always@(srcA_sign or srcB_sign or result_frac_AxB or result_frac_BxA or result_frac_AB)
        begin
            if (srcA_sign ^ srcB_sign) begin
						if ((!result_frac_AxB[25]) && (!result_frac_BxA[25])) begin
								result_frac = 26'h0000000;
								dest_sign = 1'b0;
						end
                        else if (result_frac_AxB[25]) begin
                                result_frac = result_frac_BxA;
                                dest_sign = srcB_sign;
                        end
                        else begin
                                result_frac = result_frac_AxB;
                                dest_sign = srcA_sign;
                        end
                end
                else begin
                        result_frac = result_frac_AB;
                        dest_sign = srcA_sign;
                end
        end


        assign result_exp = (expB_is_Greater) ? srcB_exp_double : srcA_exp;

        assign result_exp_inc = {1'b0, result_exp} + 1'b1;


// Phase Second

        always@(posedge ACLK)
        begin
		if (ENABLE) begin
                        dest_sign_reg <= dest_sign;
                        result_frac_reg <= result_frac;
                        result_exp_reg<= result_exp;
                        result_exp_inc_reg <= result_exp_inc;
		end

        end

        always@(posedge ACLK or negedge ARESETn)
        begin
                if (!ARESETn) begin
                        end_frag_reg <= 1'b1;
                        result_reg <= 32'h00000000;
                end
		else if (ENABLE) begin
                if (SOURCEA[30:23] == 8'hff) begin
                        end_frag_reg <= 1'b1;
                        result_reg <= SOURCEA;
                end
                else if (SOURCEB[30:23] == 8'hff) begin
                        end_frag_reg <= 1'b1;
                        result_reg <= SOURCEB;
                end
                else if (SOURCEA[30:0] == 31'd0) begin
                                end_frag_reg <= 1'b1;
								if (srcB_exp_double == 8'hff) begin
                                	result_reg[31:0] <= {srcB_sign, 31'h7f7fffff};
								end
								else if (SOURCEB[30:23] == 8'd0) begin
                                	result_reg[31:0] <= 32'h00000000;
								end
								else begin
                                	result_reg[31:0] <= {srcB_sign, srcB_exp_double, SOURCEB[22:0]};
								end
                 end
                else if (SOURCEB[30:0] == 31'd0) begin
                                end_frag_reg <= 1'b1;
                                result_reg <= SOURCEA;
                        end
                        else if ((SOURCEA[30:23] == 8'd0) || (SOURCEB[30:23] == 8'd0)) begin
                                end_frag_reg <= 1'b1;
                                result_reg <= 32'h00000000;
                        end
						else if ((SOURCEA[30:23] == srcB_exp_double) && (SOURCEA[22:0] == SOURCEB[22:0]) && (srcA_sign != srcB_sign)) begin
									end_frag_reg <= 1'b1;
								result_reg <= 32'h00000000;
						end
                else begin
                                end_frag_reg <= 1'b0;
                                result_reg <= 32'h00000000;
                        end
                end
        end



//
//      Phase Last
//

/*
        assign frac_lshift_cnt = (result_frac_reg[24]) ? 5'd0 :
                                 (result_frac_reg[23]) ? 5'd1 :
                                 (result_frac_reg[22]) ? 5'd2 :
                                 (result_frac_reg[21]) ? 5'd3 :
                                 (result_frac_reg[20]) ? 5'd4 :
                                 (result_frac_reg[19]) ? 5'd5 :
                                 (result_frac_reg[18]) ? 5'd6 :
                                 (result_frac_reg[17]) ? 5'd7 :
                                 (result_frac_reg[16]) ? 5'd8 :
                                 (result_frac_reg[15]) ? 5'd9 :
                                 (result_frac_reg[14]) ? 5'd10 :
                                 (result_frac_reg[13]) ? 5'd11 :
                                 (result_frac_reg[12]) ? 5'd12 :
                                 (result_frac_reg[11]) ? 5'd13 :
                                 (result_frac_reg[10]) ? 5'd14 :
                                 (result_frac_reg[9]) ? 5'd15 :
                                 (result_frac_reg[8]) ? 5'd16 :
                                 (result_frac_reg[7]) ? 5'd17 :
                                 (result_frac_reg[6]) ? 5'd18 :
                                 (result_frac_reg[5]) ? 5'd19 :
                                 (result_frac_reg[4]) ? 5'd20 :
                                 (result_frac_reg[3]) ? 5'd21 :
                                 (result_frac_reg[2]) ? 5'd22 :
                                 (result_frac_reg[1]) ? 5'd23 :
                                 5'd24;

        assign result_frac_lshifted = lshift(result_frac_reg[23:0], frac_lshift_cnt);
*/

	wire [24:0]	result_frac_reg_24to0;
	assign result_frac_reg_24to0 = result_frac_reg[24:0];
/*
	always@(result_frac_reg_24to0)
	begin
		casex (result_frac_reg_24to0)
			25'b1xxxxxxxxxxxxxxxxxxxxxxxx: begin
				result_frac_lshifted =  result_frac_reg_24to0[23:0];  
				frac_lshift_cnt = 5'd0;
			end
			25'b01xxxxxxxxxxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[22:0],	1'h0		};  
				frac_lshift_cnt = 5'd1;
			end
			25'b001xxxxxxxxxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[21:0],	2'h0		};  
				frac_lshift_cnt = 5'd2;
			end
			25'b0001xxxxxxxxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[20:0],	3'h0		};  
				frac_lshift_cnt = 5'd3;
			end
			25'b00001xxxxxxxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[19:0],	4'h0		};  
				frac_lshift_cnt = 5'd4;
			end
			25'b000001xxxxxxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[18:0],	5'h00		};  
				frac_lshift_cnt = 5'd5;
			end
			25'b0000001xxxxxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[17:0],	6'h00		};  
				frac_lshift_cnt = 5'd6;
			end
			25'b00000001xxxxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[16:0],	7'h00		};  
				frac_lshift_cnt = 5'd7;
			end
			25'b000000001xxxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[15:0],	8'h00		};  
				frac_lshift_cnt = 5'd8;
			end
			25'b0000000001xxxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[14:0],	9'h000		};  
				frac_lshift_cnt = 5'd9;
			end
			25'b00000000001xxxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[13:0],	10'h000 	};  
				frac_lshift_cnt = 5'd10;
			end
			25'b000000000001xxxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[12:0],	11'h000 	};  
				frac_lshift_cnt = 5'd11;
			end
			25'b0000000000001xxxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[11:0],	12'h000 	};  
				frac_lshift_cnt = 5'd12;
			end
			25'b00000000000001xxxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[10:0],	13'h0000 	};  
				frac_lshift_cnt = 5'd13;
			end
			25'b000000000000001xxxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[9:0],	14'h0000 	};  
				frac_lshift_cnt = 5'd14;
			end
			25'b0000000000000001xxxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[8:0],	15'h0000 	};  
				frac_lshift_cnt = 5'd15;
			end
			25'b00000000000000001xxxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[7:0],	16'h0000 	};  
				frac_lshift_cnt = 5'd16;
			end
			25'b000000000000000001xxxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[6:0],	17'h00000 	};  
				frac_lshift_cnt = 5'd17;
			end
			25'b0000000000000000001xxxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[5:0],	18'h00000 	};  
				frac_lshift_cnt = 5'd18;
			end
			25'b00000000000000000001xxxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[4:0],	19'h00000 	};  
				frac_lshift_cnt = 5'd19;
			end
			25'b000000000000000000001xxxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[3:0],	20'h00000 	};  
				frac_lshift_cnt = 5'd20;
			end
			25'b0000000000000000000001xxx: begin
				result_frac_lshifted = {result_frac_reg_24to0[2:0],	21'h000000 	};  
				frac_lshift_cnt = 5'd21;
			end
			25'b00000000000000000000001xx: begin
				result_frac_lshifted = {result_frac_reg_24to0[1:0],	22'h000000 	};  
				frac_lshift_cnt = 5'd22;
			end
			25'b000000000000000000000001x: begin
				result_frac_lshifted = {result_frac_reg_24to0[0],	23'h000000 	};  
				frac_lshift_cnt = 5'd23;
			end
			25'b0000000000000000000000001: begin
				result_frac_lshifted = 24'h000000;
				frac_lshift_cnt = 5'd24;
			end
			default: begin
				result_frac_lshifted = 24'hxxxxxx;
				frac_lshift_cnt = 5'bxxxxx;
			end
		endcase
	end
*/

	reg [24:0] g_tmp_result_frac_lshifted1;
	reg [24:0] g_tmp_result_frac_lshifted2;
	reg [24:0] g_tmp_result_frac_lshifted3;
	reg [24:0] g_tmp_result_frac_lshifted4;
	reg [24:0] g_tmp_result_frac_lshifted5;

	always@(result_frac_reg_24to0) begin
		if ((|result_frac_reg_24to0[24:12])==0) begin
			g_tmp_result_frac_lshifted1 = {result_frac_reg_24to0[12:0], 12'h000};
		end else begin
			g_tmp_result_frac_lshifted1 = result_frac_reg_24to0;
		end

		if ((|g_tmp_result_frac_lshifted1[24:18])==0) begin
			g_tmp_result_frac_lshifted2 = {g_tmp_result_frac_lshifted1[17:0], 7'h00};
		end else begin
			g_tmp_result_frac_lshifted2 = g_tmp_result_frac_lshifted1;
		end

		if ((|g_tmp_result_frac_lshifted2[24:21])==0) begin
			g_tmp_result_frac_lshifted3 = {g_tmp_result_frac_lshifted2[20:0], 4'h0};
		end else begin
			g_tmp_result_frac_lshifted3 = g_tmp_result_frac_lshifted2;
		end

		if ((|g_tmp_result_frac_lshifted3[24:23])==0) begin
			g_tmp_result_frac_lshifted4 = {g_tmp_result_frac_lshifted3[22:0], 2'h0};
		end else begin
			g_tmp_result_frac_lshifted4 = g_tmp_result_frac_lshifted3;
		end

		if (g_tmp_result_frac_lshifted4[24]==0) begin
			g_tmp_result_frac_lshifted5 = {g_tmp_result_frac_lshifted4[23:0], 1'h0};
		end else begin
			g_tmp_result_frac_lshifted5 = g_tmp_result_frac_lshifted4;
		end
		
		result_frac_lshifted = g_tmp_result_frac_lshifted5[23:0];
	end

	always@(result_frac_reg_24to0)
	begin
		casex (result_frac_reg_24to0)
			25'b1xxxxxxxxxxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd0;
			end
			25'b01xxxxxxxxxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd1;
			end
			25'b001xxxxxxxxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd2;
			end
			25'b0001xxxxxxxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd3;
			end
			25'b00001xxxxxxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd4;
			end
			25'b000001xxxxxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd5;
			end
			25'b0000001xxxxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd6;
			end
			25'b00000001xxxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd7;
			end
			25'b000000001xxxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd8;
			end
			25'b0000000001xxxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd9;
			end
			25'b00000000001xxxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd10;
			end
			25'b000000000001xxxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd11;
			end
			25'b0000000000001xxxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd12;
			end
			25'b00000000000001xxxxxxxxxxx: begin
				frac_lshift_cnt = 5'd13;
			end
			25'b000000000000001xxxxxxxxxx: begin
				frac_lshift_cnt = 5'd14;
			end
			25'b0000000000000001xxxxxxxxx: begin
				frac_lshift_cnt = 5'd15;
			end
			25'b00000000000000001xxxxxxxx: begin
				frac_lshift_cnt = 5'd16;
			end
			25'b000000000000000001xxxxxxx: begin
				frac_lshift_cnt = 5'd17;
			end
			25'b0000000000000000001xxxxxx: begin
				frac_lshift_cnt = 5'd18;
			end
			25'b00000000000000000001xxxxx: begin
				frac_lshift_cnt = 5'd19;
			end
			25'b000000000000000000001xxxx: begin
				frac_lshift_cnt = 5'd20;
			end
			25'b0000000000000000000001xxx: begin
				frac_lshift_cnt = 5'd21;
			end
			25'b00000000000000000000001xx: begin
				frac_lshift_cnt = 5'd22;
			end
			25'b000000000000000000000001x: begin
				frac_lshift_cnt = 5'd23;
			end
			25'b0000000000000000000000001: begin
				frac_lshift_cnt = 5'd24;
			end
			default: begin
				frac_lshift_cnt = 5'bxxxxx;
			end
		endcase
	end
	

        assign result_exp_sub = {1'b0, result_exp_reg} - {4'b0000, frac_lshift_cnt};


	wire [25:2]	result_frac_reg_25to2;
	wire [23:1]	result_frac_lshifted_23to1;
	
	assign result_frac_reg_25to2 = result_frac_reg[25:2];
	assign result_frac_lshifted_23to1 = result_frac_lshifted[23:1];

        always@(end_frag_reg or result_reg or result_frac_reg_25to2 or result_exp_inc_reg or result_exp_sub or dest_sign_reg or result_frac_lshifted_23to1)
        begin
                if (end_frag_reg) begin
                        RESULT = result_reg;
                end
                else if (result_frac_reg_25to2[25]) begin
                        if (result_exp_inc_reg[8] || (result_exp_inc_reg[7:0] == 8'hff)) begin
                                RESULT[31:31] = dest_sign_reg;
                                RESULT[30:23] = 8'hfe;
                                RESULT[22:0] = 23'h7fffff;
                        end
                        else begin
                                RESULT[31:31] = dest_sign_reg;
                                RESULT[30:23] = result_exp_inc_reg[7:0];
                                RESULT[22:0] = result_frac_reg_25to2[24:2];
                        end
                end
                else begin
                        if (result_exp_sub[7:0] == 8'hff) begin
                                RESULT[31:31] = dest_sign_reg;
                                RESULT[30:23] = 8'hfe;
                                RESULT[22:0] = 23'h7fffff;
                        end
                        else if (result_exp_sub[8] || (result_exp_sub[7:0] == 8'h00)) begin
                                RESULT[31:31] = dest_sign_reg;
                                RESULT[30:0] = 31'h00000000;
                        end
                        else begin
                                RESULT[31:31] = dest_sign_reg;
                                RESULT[30:23] = result_exp_sub[7:0];
                                RESULT[22:0] = result_frac_lshifted_23to1;
                        end
                end

        end


/*

function [24:0] hshift;
input [24:0] source;
input [4:0] bitnum;
begin
	case (bitnum)
		5'b00000: hshift = source[24:0];  
		5'b00001: hshift = {1'b0, 	source[24:1]	};  
		5'b00010: hshift = {2'b00, 	source[24:2]	};  
		5'b00011: hshift = {3'b000, 	source[24:3]	};  
		5'b00100: hshift = {4'h0, 	source[24:4]	};  
		5'b00101: hshift = {5'h00, 	source[24:5]	};  
		5'b00110: hshift = {6'h00, 	source[24:6]	};  
		5'b00111: hshift = {7'h00, 	source[24:7]	};  
		5'b01000: hshift = {8'h00, 	source[24:8]	};  
		5'b01001: hshift = {9'h000, 	source[24:9]	};  
		5'b01010: hshift = {10'h000, 	source[24:10]	};  
		5'b01011: hshift = {11'h000, 	source[24:11]	};  
		5'b01100: hshift = {12'h000, 	source[24:12]	};  
		5'b01101: hshift = {13'h0000, 	source[24:13]	};  
		5'b01110: hshift = {14'h0000, 	source[24:14]	};  
		5'b01111: hshift = {15'h0000, 	source[24:15]	};  
		5'b10000: hshift = {16'h0000, 	source[24:16]	};  
		5'b10001: hshift = {17'h00000, 	source[24:17]	};  
		5'b10010: hshift = {18'h00000, 	source[24:18]	};  
		5'b10011: hshift = {19'h00000, 	source[24:19]	};  
		5'b10100: hshift = {20'h00000, 	source[24:20]	};  
		5'b10101: hshift = {21'h000000, source[24:21]	};  
		5'b10110: hshift = {22'h000000, source[24:22]	};  
		5'b10111: hshift = {23'h000000, source[24:23]	};  
		5'b11000: hshift = {24'h000000, source[24]	};  
		5'b11001: hshift = 25'h0000000;  
		default: hshift = 25'hxxxxxxx;
	endcase
end
endfunction


function [23:0] lshift;
input [23:0] source;
input [4:0] bitnum;
begin
	case (bitnum)
		5'b00000: lshift = source[23:0];  
		5'b00001: lshift = {source[22:0],	1'b0		};  
		5'b00010: lshift = {source[21:0],	2'b00		};  
		5'b00011: lshift = {source[20:0],	3'b000		};  
		5'b00100: lshift = {source[19:0],	4'h0		};  
		5'b00101: lshift = {source[18:0],	5'h00		};  
		5'b00110: lshift = {source[17:0],	6'h00		};  
		5'b00111: lshift = {source[16:0],	7'h00		};  
		5'b01000: lshift = {source[15:0],	8'h00		};  
		5'b01001: lshift = {source[14:0],	9'h000		};  
		5'b01010: lshift = {source[13:0],	10'h000 	};  
		5'b01011: lshift = {source[12:0],	11'h000 	};  
		5'b01100: lshift = {source[11:0],	12'h000 	};  
		5'b01101: lshift = {source[10:0],	13'h0000 	};  
		5'b01110: lshift = {source[9:0],	14'h0000 	};  
		5'b01111: lshift = {source[8:0],	15'h0000 	};  
		5'b10000: lshift = {source[7:0],	16'h0000 	};  
		5'b10001: lshift = {source[6:0],	17'h00000 	};  
		5'b10010: lshift = {source[5:0],	18'h00000 	};  
		5'b10011: lshift = {source[4:0],	19'h00000 	};  
		5'b10100: lshift = {source[3:0],	20'h00000 	};  
		5'b10101: lshift = {source[2:0],	21'h000000 	};  
		5'b10110: lshift = {source[1:0],	22'h000000 	};  
		5'b10111: lshift = {source[0],		23'h000000 	};  
		5'b11000: lshift = 24'h000000;
		default: lshift = 24'hxxxxxx;
	endcase
end
endfunction
*/


endmodule

