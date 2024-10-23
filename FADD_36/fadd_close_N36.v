module fadd_close_N36 #(
    parameter FRAC_WIDTH = 36,
    parameter EXP_WIDTH  = 8 
)(
		input exp_a_neq_b,far_sign                                      ,
		input  [ EXP_WIDTH -1 : 0]  exp_f                               ,
		input  [ FRAC_WIDTH-1 : 0]  esmall_op,elarge_op                 ,
		output [ FRAC_WIDTH-1 : 0]  close_result,
		output [ EXP_WIDTH -1 : 0]  exp_close,
		output close_sign
	);

	wire  [ FRAC_WIDTH-1:0]  close_esmall_op;
	wire  [ FRAC_WIDTH  :0]  close_aligned_elarge_op,close_aligned_esmall_op ;
	wire  [ FRAC_WIDTH  :0]  close_result_tonormalize,close_result_sub1,close_result_sub2;
	//reg [ FRAC_WIDTH  :0]  close_result_torenormal33 ;
	reg   [ FRAC_WIDTH-1:0]  close_shiftpath;
	//wire[ FRAC_WIDTH-1:0]  close_roundpath32;
	wire  [ EXP_WIDTH -1:0]  exp_close0;
	wire  [5:0]              lza_num;
	wire  [5:0]              shift_num;
	wire                     correct_sel;
	assign close_esmall_op         = (exp_a_neq_b)? {1'b0,esmall_op[FRAC_WIDTH-1:1]}:{esmall_op};
	assign close_aligned_elarge_op = {1'b0,elarge_op};
	assign close_aligned_esmall_op = {1'b0,close_esmall_op};
	

//fixed ADD
	assign close_result_sub1  =  close_aligned_elarge_op - close_aligned_esmall_op;
	assign close_result_sub2  =  close_aligned_esmall_op - close_aligned_elarge_op;
	//

   lza37 u_lza(
		.i_op_a         ( close_aligned_elarge_op      ),
		.i_op_b         ( close_aligned_esmall_op       ),
		.lza_num        ( lza_num      ),
		.correct_sel    ( correct_sel  )
	);

	assign close_result_tonormalize   = close_result_sub1[FRAC_WIDTH] ? close_result_sub2 : close_result_sub1 ;
//normalized
	assign shift_num                  = lza_num + {5'b0,correct_sel};
	assign exp_close0                 = exp_f+8'd1;
	//assign shift_or_round             = lz_eq_1&(~correct_sel); // leading zero == 1,round zero >=2 shift

	/*always@(*) begin:round_close
		if(close_result_tonormalize[0]==1'b0)
			close_result_torenormal33 = {close_result_tonormalize[33:1]};
		else if((~close_result_tonormalize[1]&close_result_tonormalize[0]))
			close_result_torenormal33 = {close_result_tonormalize[33:1]};
		else
			close_result_torenormal33 = close_result_tonormalize[33:1]+1'b1;
	end*/
	
	//assign close_roundpath32 = close_result_torenormal33[32] ? close_result_torenormal33>>1 : close_result_torenormal33;

	always@(*) begin:shifter_close
		case(shift_num)
			6'd0:close_shiftpath =  {close_result_tonormalize[36:1]     };
			6'd1:close_shiftpath =  {close_result_tonormalize[35:0] };
			6'd2:close_shiftpath =  {close_result_tonormalize[34:0],1'b0 };
			6'd3:close_shiftpath =  {close_result_tonormalize[33:0],2'b0 };
			6'd4:close_shiftpath =  {close_result_tonormalize[32:0],3'b0 };
			6'd5:close_shiftpath =  {close_result_tonormalize[31:0],4'b0 };
			6'd6:close_shiftpath =  {close_result_tonormalize[30:0],5'b0 };
			6'd7:close_shiftpath =  {close_result_tonormalize[29:0],6'b0 };
			6'd8:close_shiftpath =  {close_result_tonormalize[28:0],7'b0 };
			6'd9:close_shiftpath =  {close_result_tonormalize[27:0],8'b0 };
			6'd10:close_shiftpath = {close_result_tonormalize[26:0],9'b0 };
			6'd11:close_shiftpath = {close_result_tonormalize[25:0],10'b0 };
			6'd12:close_shiftpath = {close_result_tonormalize[24:0],11'b0 };
			6'd13:close_shiftpath = {close_result_tonormalize[23:0],12'b0 };
			6'd14:close_shiftpath = {close_result_tonormalize[22:0],13'b0 };
			6'd15:close_shiftpath = {close_result_tonormalize[21:0],14'b0 };
			6'd16:close_shiftpath = {close_result_tonormalize[20:0],15'b0 };
			6'd17:close_shiftpath = {close_result_tonormalize[19:0],16'b0 };
			6'd18:close_shiftpath = {close_result_tonormalize[18:0],17'b0 };
			6'd19:close_shiftpath = {close_result_tonormalize[17:0],18'b0 };
			6'd20:close_shiftpath = {close_result_tonormalize[16:0],19'b0 };
			6'd21:close_shiftpath = {close_result_tonormalize[15:0],20'b0 };
			6'd22:close_shiftpath = {close_result_tonormalize[14:0],21'b0 };
			6'd23:close_shiftpath = {close_result_tonormalize[13:0],22'b0 };
			6'd24:close_shiftpath = {close_result_tonormalize[12:0],23'b0 };
			6'd25:close_shiftpath = {close_result_tonormalize[11:0],24'b0 };
			6'd26:close_shiftpath = {close_result_tonormalize[10:0],25'b0 };
			6'd27:close_shiftpath = {close_result_tonormalize[9:0],26'b0 };
			6'd28:close_shiftpath = {close_result_tonormalize[8:0],27'b0 };
			6'd29:close_shiftpath = {close_result_tonormalize[7:0],28'b0 };
			6'd30:close_shiftpath = {close_result_tonormalize[6:0],29'b0 };
			6'd31:close_shiftpath = {close_result_tonormalize[5:0],30'b0 };
			6'd32:close_shiftpath = {close_result_tonormalize[4:0],31'b0 };
			6'd33:close_shiftpath = {close_result_tonormalize[3:0],32'b0 };
			6'd34:close_shiftpath = {close_result_tonormalize[2:0],33'b0 };
			6'd35:close_shiftpath = {close_result_tonormalize[1:0],34'b0 };
			6'd36:close_shiftpath = {close_result_tonormalize[0:0],35'b0 };
			default:close_shiftpath = { 36'b0 };
		endcase
	end
	assign close_sign           = far_sign^close_result_sub1[FRAC_WIDTH];



	assign close_result        = close_shiftpath;
	assign exp_close           = exp_close0-{2'd0,shift_num}       ;
endmodule