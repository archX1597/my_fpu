module lza37#(
    parameter LZA_WIDTH  = 37
) (
        input  [LZA_WIDTH-1:0] i_op_a  ,
        input  [LZA_WIDTH-1:0] i_op_b  ,
        output [5          :0] lza_num,
        output                 correct_sel
    );

    // @SuppressProblem -type partially_unread_data -count 1 -length 1
    wire [LZA_WIDTH-1:0] e_code ;
    wire [LZA_WIDTH-1:0] g_code ;
    wire [LZA_WIDTH-1:0] s_code ;

    wire [LZA_WIDTH-1:0] p_pos  ;
    wire [LZA_WIDTH-1:0] n_pos  ;
    wire [LZA_WIDTH-1:0] z_pos  ;
    wire [LZA_WIDTH-1:0] p_neg  ;
    wire [LZA_WIDTH-1:0] n_neg  ;
    wire [LZA_WIDTH-1:0] z_neg  ;


    wire [5:0]            LZD_num ;
    //
    wire   [LZA_WIDTH-1:0] o_f        ;
    assign e_code = ~(i_op_a ^ i_op_b) ;
    assign g_code = i_op_a & ~i_op_b   ;
    assign s_code = ~i_op_a & i_op_b   ;

    //correction tree signal
    

    generate
        genvar j ;
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for (j=LZA_WIDTH-2;j > 0;j = j-1) begin
            assign o_f[j]= (e_code[j+1]&( g_code[j] & ~s_code[j-1] || s_code[j]&(~g_code[j-1]))) || (~e_code[j+1]&( (s_code[j]&~s_code[j-1]||g_code[j]&~g_code[j-1])));
        end
    endgenerate

    assign o_f[LZA_WIDTH-1] = g_code[LZA_WIDTH-1]& ~s_code[LZA_WIDTH-2] || s_code[LZA_WIDTH-1]& ~g_code[LZA_WIDTH-2];
    assign o_f[0]            =(e_code[1]&(g_code[0] ||s_code[0])) || (~e_code[1]&((s_code[0]||g_code[0])));
    //correction tree encode
    //positive tree encode:
    generate
        genvar i ;
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for (i=LZA_WIDTH-2;i > 0;i = i-1) begin
            assign p_pos[i] = (g_code[i]||(~e_code[i+1]&s_code[i]))&~s_code[i-1];
            assign n_pos[i] = e_code[i+1]&s_code[i]                             ;
            assign z_pos[i] = ~(p_pos[i]||n_pos[i])                             ;
        end
    endgenerate

    assign   p_pos[LZA_WIDTH-1] = (g_code[LZA_WIDTH-1])&(~s_code[LZA_WIDTH-2]);
    assign   n_pos[LZA_WIDTH-1] =  s_code[LZA_WIDTH-1]                         ;
    assign   z_pos[LZA_WIDTH-1] = ~(p_pos[LZA_WIDTH-1]||n_pos[LZA_WIDTH-1])   ;

    assign   p_pos[0]= (g_code[0]||(~e_code[1]&s_code[0]));
    assign   n_pos[0]= e_code[1]&s_code[0]                ;
    assign   z_pos[0]= ~(p_pos[0]||n_pos[0])               ;

    //negative tree encode:

    generate
        genvar k ;
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for (k=LZA_WIDTH-2; k > 0;k = k-1) begin
            assign n_neg[k] = (s_code[k]||(~e_code[k+1]&g_code[k]))&~g_code[k-1];
            assign p_neg[k] = e_code[k+1]&g_code[k]                             ;
            assign z_neg[k] = ~(p_neg[k]||n_neg[k])                             ;
        end
    endgenerate

    assign   n_neg[LZA_WIDTH-1] = (s_code[LZA_WIDTH-1])&(~g_code[LZA_WIDTH-2]);
    assign   p_neg[LZA_WIDTH-1] =  g_code[LZA_WIDTH-1]                         ;
    assign   z_neg[LZA_WIDTH-1] = ~(p_neg[LZA_WIDTH-1]||n_neg[LZA_WIDTH-1])   ;

    assign   n_neg[0]= (s_code[0]||(~e_code[1]&g_code[0])) ;
    assign   p_neg[0]=  e_code[1]&g_code[0]                ;
    assign   z_neg[0]= ~(p_neg[0]||n_neg[0])               ;

    //correction tree
    wire [4*LZA_WIDTH-1:0] correct_p;
    wire [4*LZA_WIDTH-1:0] correct_n;
    wire         correct  ;
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(i=LZA_WIDTH;i>0;i=i-1) begin
            assign correct_p[i*4-1:(i-1)*4]= {1'b0,n_pos[i-1],p_pos[i-1],z_pos[i-1]};
        end
    endgenerate
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(i=LZA_WIDTH;i>0;i=i-1) begin
            assign correct_n[i*4-1:(i-1)*4]= {1'b0,n_neg[i-1],p_neg[i-1],z_neg[i-1]};
        end
    endgenerate

    // outports wire


    correction_tree_N37 u_correction_tree(
                        .node_input_n 	( correct_n  ),
                        .node_input_p 	( correct_p  ),
                        .correct      	( correct    )
                    );

    // outports wire

    lzd37 u_lzd37(
              .i_detect_op 	( o_f  ),
              .o_lzd_num   	( LZD_num   )
          );

    assign correct_sel = correct;
    assign lza_num = LZD_num;

endmodule
