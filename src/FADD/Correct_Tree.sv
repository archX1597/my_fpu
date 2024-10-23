module Correction_Tree(
    input Node P_nodes [24:0],   // 27 input P_nodes for Pos_node processing
    input Node N_nodes [24:0],   // 27 input N_nodes for Neg_node processing
    output final_result     // Final result (OR of Pos_node and Neg_node results)
);

    Node pos_level1 [12:0];    // First level for Pos_node (13 nodes)
    Node neg_level1 [12:0];    // First level for Neg_node (13 nodes)

    Node pos_level2 [6:0];     // Second level for Pos_node (7 nodes)
    Node neg_level2 [6:0];     // Second level for Neg_node (7 nodes)

    Node pos_level3 [3:0];     // Third level for Pos_node (4 nodes)
    Node neg_level3 [3:0];     // Third level for Neg_node (4 nodes)

    Node pos_level4 [1:0];     // Fourth level for Pos_node (2 nodes)
    Node neg_level4 [1:0];     // Fourth level for Neg_node (2 nodes)

    Node pos_level5;           // Fifth level for Pos_node (1 node)
    Node neg_level5;           // Fifth level for Neg_node (1 node)

    // First level logic for both trees (25 nodes => 13 nodes)
    genvar i;
    generate
        for (i = 0; i < 12; i = i + 1) begin
            // Pos_node processing for P_nodes
            Pos_node u_pos_node (
                .LNODE(P_nodes[2*i]),
                .RNODE(P_nodes[2*i+1]),
                .TYPE(pos_level1[i])
            );

            // Neg_node processing for N_nodes
            Neg_node u_neg_node (
                .LNODE(N_nodes[2*i]),
                .RNODE(N_nodes[2*i+1]),
                .TYPE(neg_level1[i])
            );
        end
    endgenerate

    // Handle the last node at the first level (node 24 and node 23)
    Pos_node u_pos_node_last1 (
        .LNODE(P_nodes[24]),
        .RNODE(P_nodes[23]),
        .TYPE(pos_level1[12])
    );

    Neg_node u_neg_node_last1 (
        .LNODE(N_nodes[24]),
        .RNODE(N_nodes[23]),
        .TYPE(neg_level1[12])
    );

    // Second level logic (13 nodes => 7 nodes)
    generate
        for (i = 0; i < 6; i = i + 1) begin
            // Pos_node processing
            Pos_node u_pos_node_level2 (
                .LNODE(pos_level1[2*i]),
                .RNODE(pos_level1[2*i+1]),
                .TYPE(pos_level2[i])
            );

            // Neg_node processing
            Neg_node u_neg_node_level2 (
                .LNODE(neg_level1[2*i]),
                .RNODE(neg_level1[2*i+1]),
                .TYPE(neg_level2[i])
            );
        end
    endgenerate

    // Handle the last node at the second level
    Pos_node u_pos_node_last2 (
        .LNODE(pos_level1[12]),
        .RNODE(pos_level1[11]),
        .TYPE(pos_level2[6])
    );

    Neg_node u_neg_node_last2 (
        .LNODE(neg_level1[12]),
        .RNODE(neg_level1[11]),
        .TYPE(neg_level2[6])
    );

    // Third level logic (7 nodes => 4 nodes)
    generate
        for (i = 0; i < 3; i = i + 1) begin
            // Pos_node processing
            Pos_node u_pos_node_level3 (
                .LNODE(pos_level2[2*i]),
                .RNODE(pos_level2[2*i+1]),
                .TYPE(pos_level3[i])
            );

            // Neg_node processing
            Neg_node u_neg_node_level3 (
                .LNODE(neg_level2[2*i]),
                .RNODE(neg_level2[2*i+1]),
                .TYPE(neg_level3[i])
            );
        end

        // Handle the last node at the third level
        Pos_node u_pos_node_last3 (
            .LNODE(pos_level2[6]),
            .RNODE(pos_level2[5]),
            .TYPE(pos_level3[3])
        );

        Neg_node u_neg_node_last3 (
            .LNODE(neg_level2[6]),
            .RNODE(neg_level2[5]),
            .TYPE(neg_level3[3])
        );
    endgenerate

    // Fourth level logic (4 nodes => 2 nodes)
    generate
        for (i = 0; i < 2; i = i + 1) begin
            // Pos_node processing
            Pos_node u_pos_node_level4 (
                .LNODE(pos_level3[2*i]),
                .RNODE(pos_level3[2*i+1]),
                .TYPE(pos_level4[i])
            );

            // Neg_node processing
            Neg_node u_neg_node_level4 (
                .LNODE(neg_level3[2*i]),
                .RNODE(neg_level3[2*i+1]),
                .TYPE(neg_level4[i])
            );
        end
    endgenerate

    // Fifth level logic (2 nodes => 1 final node)
    Pos_node u_pos_node_final (
        .LNODE(pos_level4[0]),
        .RNODE(pos_level4[1]),
        .TYPE(pos_level5)
    );

    Neg_node u_neg_node_final (
        .LNODE(neg_level4[0]),
        .RNODE(neg_level4[1]),
        .TYPE(neg_level5)
    );

    // Final OR logic: OR the outputs of Pos_node and Neg_node at the final level
    assign final_result = (pos_level5 == 4'b1000) | (neg_level5 == 4'b1000 );


endmodule
