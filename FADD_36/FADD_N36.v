module FADD_N36 #(
    parameter FRAC_WIDTH = 36,
    parameter EXP_WIDTH  = 8 
)(

        input                            i_sign_a ,
        input  signed [EXP_WIDTH - 1: 0] i_exp_a  ,
        input         [FRAC_WIDTH- 1: 0] i_frac_a ,

        input                            i_sign_b ,
        input  signed [EXP_WIDTH - 1: 0] i_exp_b  ,
        input         [FRAC_WIDTH- 1: 0] i_frac_b ,

        output                            o_sign_c ,
        output signed [EXP_WIDTH - 1: 0] o_exp_c  ,
        output        [FRAC_WIDTH- 1: 0] o_frac_c

    );

    //data path signal
    wire  [EXP_WIDTH -1 : 0]  exp_f,exp_far,exp_close                         ;
    wire  [EXP_WIDTH    : 0]  diff_abs                                        ;
    wire  [EXP_WIDTH    : 0]  diff_a_sub_b                                    ;
    wire  [EXP_WIDTH    : 0]  diff_b_sub_a                                    ;
    wire  [FRAC_WIDTH-1 : 0]  esmall_op,elarge_op                         ;
    wire  [FRAC_WIDTH-1 : 0]  close_result,far_result             ;

    //control
    wire   exp_a_lt_b                                       ;
    wire   exp_a_neq_b                                      ;
    wire   sign_diff                                        ;
    wire   path_sel                                         ;
    wire   far_sign                                         ;
    wire   close_sign                                       ;
   

    // @SuppressProblem -type assign_extend_non_const_arithmetic -count 1 -length 1
    assign diff_a_sub_b   = i_exp_a - i_exp_b               ;
    // @SuppressProblem -type assign_extend_non_const_arithmetic -count 1 -length 1
    assign diff_b_sub_a   = i_exp_b - i_exp_a               ;

    assign exp_a_neq_b    = |diff_a_sub_b                   ;
    assign exp_a_lt_b     = diff_b_sub_a[EXP_WIDTH]        ;
    assign diff_abs       = exp_a_lt_b ?  diff_a_sub_b   :  diff_b_sub_a   ;
    //if exp(A) == exp(B),diff_a_sub_b = 8'b0000_0000
    assign esmall_op    = exp_a_lt_b ? i_frac_b : i_frac_a ;
    assign elarge_op    = exp_a_lt_b ? i_frac_a : i_frac_b ;
    // if exp(A) == exp(B),can't check the value of A or B
    assign sign_diff      = i_sign_a ^ i_sign_b;
    assign path_sel       = (sign_diff)&((diff_abs == 9'b1) || (~exp_a_neq_b)); //1: d<=1 cloth path// 0: far path

    //far path
    assign exp_f                      = exp_a_lt_b ?  i_exp_a  :  i_exp_b ;
    assign far_sign                   = exp_a_lt_b ?  i_sign_a : i_sign_b ;

    fadd_far_N36 u_fadd_far_n36(
        	.esmall_op  	( esmall_op     ),
        	.elarge_op  	( elarge_op     ),
        	.exp_f        	( exp_f         ),
        	.diff_abs     	( diff_abs      ),
        	.sign_diff    	( sign_diff     ),
        	.far_result 	( far_result    ),
        	.exp_far      	( exp_far       )
        );

     
    // outports wire
    fadd_close_N36 u_fadd_close_n36(
    	.exp_a_neq_b    	( exp_a_neq_b     ),
    	.far_sign       	( far_sign        ),
    	.exp_f          	( exp_f           ),
    	.esmall_op    	    ( esmall_op     ),
    	.elarge_op    	    ( elarge_op     ),
    	.close_result 	    ( close_result  ),
    	.exp_close      	( exp_close       ),
        .close_sign         ( close_sign)
    );



    assign o_exp_c             = path_sel ? exp_close      : exp_far     ;
    assign o_frac_c            = path_sel ? close_result   : far_result  ;
    assign o_sign_c            = path_sel ? close_sign     : far_sign    ;

endmodule //FADD
