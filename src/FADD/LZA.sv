`define LZA_WIDTH 25
import FPU_pkg::*;
module LZA(
        input [`LZA_WIDTH - 1 : 0]  LZA_OP_A,
        input [`LZA_WIDTH - 1 : 0]  LZA_OP_B,
        output  [$clog2(`LZA_WIDTH):0] LZA_count,
        output ERR_SEL
    );

    logic [`LZA_WIDTH-1:0] LZA_RESULT_SEQ;
    logic [`LZA_WIDTH-1:0] e_code ;
    logic [`LZA_WIDTH-1:0] g_code ;
    logic [`LZA_WIDTH-1:0] s_code ;

    logic [`LZA_WIDTH-1:0] p_pos  ;
    logic [`LZA_WIDTH-1:0] n_pos  ;
    logic [`LZA_WIDTH-1:0] z_pos  ;
    logic [`LZA_WIDTH-1:0] p_neg  ;
    logic [`LZA_WIDTH-1:0] n_neg  ;
    logic [`LZA_WIDTH-1:0] z_neg  ;

    assign e_code = ~(LZA_OP_A ^ LZA_OP_B) ;
    assign g_code = LZA_OP_A & ~LZA_OP_B   ;
    assign s_code = ~LZA_OP_A & LZA_OP_B   ;


    generate
        genvar j ;
        for (j=`LZA_WIDTH-2;j > 0;j = j-1) begin
            assign LZA_RESULT_SEQ[j]= (e_code[j+1]&( g_code[j] & ~s_code[j-1] || s_code[j]&(~g_code[j-1]))) || (~e_code[j+1]&( (s_code[j]&~s_code[j-1]||g_code[j]&~g_code[j-1])));
        end
    endgenerate

    assign LZA_RESULT_SEQ[`LZA_WIDTH-1] = g_code[`LZA_WIDTH-1]& ~s_code[`LZA_WIDTH-2] || s_code[`LZA_WIDTH-1]& ~g_code[`LZA_WIDTH-2];
    assign LZA_RESULT_SEQ[0]            = (e_code[1]&(g_code[0] ||s_code[0])) || (~e_code[1]&((s_code[0]||g_code[0])));


    LZD #(
        .WIDTH(`LZA_WIDTH)
    )
    u_LZD (
        // Inputs
        .in             (LZA_RESULT_SEQ), 
        // Outputs
        .lead_zero_count(LZA_count[$clog2(`LZA_WIDTH):0]) 
    );
//positive tree encode:
    generate
        genvar i ;
        for (i=`LZA_WIDTH-2;i > 0;i = i-1) begin
            assign p_pos[i] = (g_code[i]||(~e_code[i+1]&s_code[i]))&~s_code[i-1];
            assign n_pos[i] = e_code[i+1]&s_code[i]                             ;
            assign z_pos[i] = ~(p_pos[i]||n_pos[i])                             ;
        end
    endgenerate

    assign   p_pos[`LZA_WIDTH-1] = (g_code[`LZA_WIDTH-1])&(~s_code[`LZA_WIDTH-2]);
    assign   n_pos[`LZA_WIDTH-1] =  s_code[`LZA_WIDTH-1]                         ;
    assign   z_pos[`LZA_WIDTH-1] = ~(p_pos[`LZA_WIDTH-1]||n_pos[`LZA_WIDTH-1])   ;

    assign   p_pos[0]= (g_code[0]||(~e_code[1]&s_code[0]));
    assign   n_pos[0]= e_code[1]&s_code[0]                ;
    assign   z_pos[0]= ~(p_pos[0]||n_pos[0])               ;

//negative tree encode:

    generate
        genvar k ;
        for (k=`LZA_WIDTH-2; k > 0;k = k-1) begin
            assign n_neg[k] = (s_code[k]||(~e_code[k+1]&g_code[k]))&~g_code[k-1];
            assign p_neg[k] = e_code[k+1]&g_code[k]                             ;
            assign z_neg[k] = ~(p_neg[k]||n_neg[k])                             ;
        end
    endgenerate

    assign   n_neg[`LZA_WIDTH-1] = (s_code[`LZA_WIDTH-1])&(~g_code[`LZA_WIDTH-2]);
    assign   p_neg[`LZA_WIDTH-1] =  g_code[`LZA_WIDTH-1]                         ;
    assign   z_neg[`LZA_WIDTH-1] = ~(p_neg[`LZA_WIDTH-1]||n_neg[`LZA_WIDTH-1])   ;

    assign   n_neg[0]= (s_code[0]||(~e_code[1]&g_code[0])) ;
    assign   p_neg[0]=  e_code[1]&g_code[0]                ;
    assign   z_neg[0]= ~(p_neg[0]||n_neg[0])               ;

    Node P_nodes [`LZA_WIDTH - 1 : 0];
    Node N_nodes [`LZA_WIDTH - 1 : 0];

    generate
        for(i=`LZA_WIDTH;i>0;i=i-1) begin
            assign P_nodes[i] = {1'b0,n_pos[i-1],p_pos[i-1],z_pos[i-1]};
            assign N_nodes[i] = {1'b0,n_neg[i-1],p_neg[i-1],z_neg[i-1]};
        end
    endgenerate



    Correction_Tree u_Correction_Tree (
        // Inputs
        .N_nodes     (N_nodes[`LZA_WIDTH - 1 : 0]), //27 input N_nodes for Neg_node processing
        .P_nodes     (P_nodes[`LZA_WIDTH - 1 : 0]), //27 input P_nodes for Pos_node processing
        // Outputs
        .final_result(ERR_SEL) //Final result (OR of Pos_node and Neg_node results)
    );
    

endmodule