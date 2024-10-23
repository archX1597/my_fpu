module fadd_far_N36 #(
    parameter FRAC_WIDTH = 36,
    parameter EXP_WIDTH  = 8 
)(
        input [ FRAC_WIDTH-1 : 0 ] esmall_op,elarge_op ,
        input [ EXP_WIDTH-1  : 0 ] exp_f,
        input [ EXP_WIDTH    : 0 ] diff_abs,
        input  sign_diff,
        output [ FRAC_WIDTH-1 :0 ] far_result,
        output [ EXP_WIDTH-1  :0 ] exp_far
    );
    //fadd_far

    wire  [ EXP_WIDTH -1 : 0]  exp_L_shift,exp_R_shift                         ;
    wire  [ FRAC_WIDTH   : 0]  far_aligned_esmall_op,far_aligned_elarge_op     ;//FRAC_WIDTH+1
    reg   [ FRAC_WIDTH-1 : 0]  far_esmall_op                                   ;
    wire  [ FRAC_WIDTH-1 : 0]  far_esmall_toshift_op                           ;
    wire  [ FRAC_WIDTH   : 0]  far_result_tonormalize                          ;
    wire  far_normalLshift , far_normalRshift;

    assign far_esmall_toshift_op = {esmall_op};
    
    always@(*) begin: shifter
        case(diff_abs)
            9'd0:far_esmall_op =  {far_esmall_toshift_op[35:0] }  ;
            9'd1:far_esmall_op =  {1'b0,far_esmall_toshift_op[35:1] }  ;
            9'd2:far_esmall_op =  {2'b0,far_esmall_toshift_op[35:2] }  ;
            9'd3:far_esmall_op =  {3'b0,far_esmall_toshift_op[35:3] }  ;
            9'd4:far_esmall_op =  {4'b0,far_esmall_toshift_op[35:4] }  ;
            9'd5:far_esmall_op =  {5'b0,far_esmall_toshift_op[35:5] }  ;
            9'd6:far_esmall_op =  {6'b0,far_esmall_toshift_op[35:6] }  ;
            9'd7:far_esmall_op =  {7'b0,far_esmall_toshift_op[35:7] }  ;
            9'd8:far_esmall_op =  {8'b0,far_esmall_toshift_op[35:8] }  ;
            9'd9:far_esmall_op =  {9'b0,far_esmall_toshift_op[35:9] }  ;
            9'd10:far_esmall_op = {10'b0,far_esmall_toshift_op[35:10] };
            9'd11:far_esmall_op = {11'b0,far_esmall_toshift_op[35:11] };
            9'd12:far_esmall_op = {12'b0,far_esmall_toshift_op[35:12] };
            9'd13:far_esmall_op = {13'b0,far_esmall_toshift_op[35:13] };
            9'd14:far_esmall_op = {14'b0,far_esmall_toshift_op[35:14] };
            9'd15:far_esmall_op = {15'b0,far_esmall_toshift_op[35:15] };
            9'd16:far_esmall_op = {16'b0,far_esmall_toshift_op[35:16] };
            9'd17:far_esmall_op = {17'b0,far_esmall_toshift_op[35:17] };
            9'd18:far_esmall_op = {18'b0,far_esmall_toshift_op[35:18] };
            9'd19:far_esmall_op = {19'b0,far_esmall_toshift_op[35:19] };
            9'd20:far_esmall_op = {20'b0,far_esmall_toshift_op[35:20] };
            9'd21:far_esmall_op = {21'b0,far_esmall_toshift_op[35:21] };
            9'd22:far_esmall_op = {22'b0,far_esmall_toshift_op[35:22] };
            9'd23:far_esmall_op = {23'b0,far_esmall_toshift_op[35:23] };
            9'd24:far_esmall_op = {24'b0,far_esmall_toshift_op[35:24] };
            9'd25:far_esmall_op = {25'b0,far_esmall_toshift_op[35:25] };
            9'd26:far_esmall_op = {26'b0,far_esmall_toshift_op[35:26] };
            9'd27:far_esmall_op = {27'b0,far_esmall_toshift_op[35:27] };
            9'd28:far_esmall_op = {28'b0,far_esmall_toshift_op[35:28] };
            9'd29:far_esmall_op = {29'b0,far_esmall_toshift_op[35:29] };
            9'd30:far_esmall_op = {30'b0,far_esmall_toshift_op[35:30] };
            9'd31:far_esmall_op = {31'b0,far_esmall_toshift_op[35:31] };
            9'd32:far_esmall_op = {32'b0,far_esmall_toshift_op[35:32] };
            9'd33:far_esmall_op = {33'b0,far_esmall_toshift_op[35:33] };
            9'd34:far_esmall_op = {34'b0,far_esmall_toshift_op[35:34] };
            9'd35:far_esmall_op = {35'b0,far_esmall_toshift_op[35:35] };
            default:far_esmall_op = { 36'b0 };
        endcase
    end

    assign far_aligned_elarge_op    = {1'b0, elarge_op     }                                                  ;
    assign far_aligned_esmall_op    = {1'b0, far_esmall_op }                                                  ;
    //fixed add
    assign far_result_tonormalize   = sign_diff ?   far_aligned_elarge_op - far_aligned_esmall_op :
                                                    far_aligned_elarge_op + far_aligned_esmall_op ;
           



    //normalized shift
    assign far_normalRshift           =   far_result_tonormalize[FRAC_WIDTH] ;
    assign far_normalLshift           = ~(far_result_tonormalize[FRAC_WIDTH] | far_result_tonormalize[FRAC_WIDTH-1]);
    assign far_result                 =   far_normalRshift ?  far_result_tonormalize [FRAC_WIDTH   : 1]      : 
                                          far_normalLshift ? {far_result_tonormalize [FRAC_WIDTH-2 : 0],1'b0}: 
                                                              far_result_tonormalize [FRAC_WIDTH-1 : 0]      ;

    assign exp_L_shift                = exp_f - 8'b1;
    assign exp_R_shift                = exp_f + 8'b1;

    assign exp_far                    =  far_normalRshift ? exp_R_shift                                     : 
                                         far_normalLshift ? exp_L_shift                                     : 
                                                            exp_f    ;
endmodule
