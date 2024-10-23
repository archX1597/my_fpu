import FPU_pkg::*;
module FADDSUB (
    input  float_type i_OP_A,i_OP_B,
    input  logic i_ADD_or_SUB,//SUB ==1 ,ADD == 0 A <op> B
    input  i_CLK,i_NRST,
//    input  [1:0] Round_MODE,
    output float_type o_OP_C,
    output Over_flow,Under_flow,
    output Q_NaN,S_NaN,
    output NORMAL_Flag
);
//Exception Signal:
    logic Inf_A,Inf_B ;
    logic Min_A,Min_B ;
    logic o_NaN       ;
    logic Q_NaN_A,S_NaN_A;
    logic Q_NaN_B,S_NaN_B;
    logic Result_Q_NaN;
    logic Result_S_NaN;

    logic [`FLOAT_32_EXP       : 0] EXP_diff_A_LT_B,EXP_diff_B_LT_A,EXP_diff;
    logic [`FLOAT_32_EXP  - 1  : 0] EXP_Far_Path;
    logic [`FLOAT_32_FRAC      : 0] FRAC_Large,FRAC_Small;
    logic [`FLOAT_32_EXP  - 1  : 0] EXP_Large;
    logic [`FLOAT_32_FRAC + 3  : 0] FRAC_Far_Path,FRAC_Close_Path;
    logic A_LT_B;
    logic A_EQ_B;
    logic EXP_diff_ST_or_EQ_1;
    logic FRAC_ADD_OR_SUB;
    logic PATH_FAR_OR_CLOSE;

    
  
    always_comb begin:Exception_Detecor
        Inf_A   = (& i_OP_A.exp) && (|i_OP_A.frac) ;
        Inf_B   = (& i_OP_B.exp) && (|i_OP_B.frac) ;
        //Quiet_NaN
        Q_NaN_A = (& i_OP_A.exp) && ~(|i_OP_A.frac) && i_OP_A.frac[`FLOAT_32_FRAC-1];
        Q_NaN_B = (& i_OP_B.exp) && ~(|i_OP_B.frac) && i_OP_B.frac[`FLOAT_32_FRAC-1];
        //Signal_Nan
        S_NaN_A = (& i_OP_A.exp) && ~(|i_OP_A.frac) && ~i_OP_A.frac[`FLOAT_32_FRAC-1];
        S_NaN_B = (& i_OP_B.exp) && ~(|i_OP_B.frac) && ~i_OP_B.frac[`FLOAT_32_FRAC-1];
    end


    assign Result_Q_NaN = Q_NaN_A && Q_NaN_B |
                          Q_NaN_A && Inf_B   |
                          Inf_A   && Q_NaN_B |
                          Inf_A   && Inf_B && i_ADD_or_SUB == `SUB;

    assign Result_S_NaN = S_NaN_A && S_NaN_B |
                          Q_NaN_A && S_NaN_B |
                          S_NaN_A && Q_NaN_B |
                          S_NaN_A && Inf_B   | 
                          Inf_A   && S_NaN_B ;

    //Parallel Caculate Exp distance
    assign EXP_diff_A_LT_B = {1'b0,i_OP_A.exp} - {1'b0,i_OP_B.exp};
    assign EXP_diff_B_LT_A = {1'b0,i_OP_B.exp} - {1'b0,i_OP_A.exp};

    //Exponetn Select
    assign A_LT_B = (~ EXP_diff_A_LT_B[`FLOAT_32_EXP]) && (~ A_EQ_B);
    assign A_EQ_B = | EXP_diff_A_LT_B;

    //Path and Opreation 
    assign FRAC_ADD_OR_SUB = i_OP_A.sign ^ i_OP_B.sign ^ i_ADD_or_SUB;
    assign PATH_FAR_OR_CLOSE = ((FRAC_ADD_OR_SUB == `SUB) && EXP_diff_ST_or_EQ_1) ? `CLOSE_PATH : `FAR_PATH;

    //Frac switch
    assign FRAC_Large = A_LT_B ? {1'b1,i_OP_A.frac} : {1'b1,i_OP_B.frac};
    assign FRAC_Small = A_LT_B ? {1'b1,i_OP_B.frac} : {1'b1,i_OP_A.frac};
    assign EXP_Large  = A_LT_B ? {i_OP_A.exp}  : {i_OP_A.exp};
    assign EXP_diff_ST_or_EQ_1 = (EXP_Large == 1) || A_EQ_B;
    assign EXP_diff            = A_LT_B ? EXP_diff_A_LT_B : EXP_diff_B_LT_A ;

    
    FAR_PATH #(
        .FRAC_WIDTH(`FLOAT_32_FRAC+1),
        .EXP_WIDTH (`FLOAT_32_EXP)
    )
    u_FAR_PATH (
        // Inputs
        .diff_abs  (EXP_diff),
        .elarge_op (FRAC_Large),
        .esmall_op (FRAC_Small),
        .exp_f     (EXP_Large),
        .sign_diff (FRAC_ADD_OR_SUB),
        // Outputs
        .exp_far   (EXP_Far_Path),
        .far_result(FRAC_Far_Path)
    );

    //Round_extend:
    

    //OP Switch


    

endmodule
