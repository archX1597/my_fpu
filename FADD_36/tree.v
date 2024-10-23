module correction_tree_N37
(
    input  [147:0] node_input_n,node_input_p,
    output         correct
);
    //5level
    wire [63 :0] plevel1;
    wire [31 :0] plevel2;
    wire [15 :0] plevel3;
    wire [7  :0] plevel4;
    wire [3  :0] plevel5;

    wire [7  :0] pslevel1;
    wire [3  :0] pslevel2;

    wire [127:0] pLtree;

    wire [15 :0] pStree;
    wire [3  :0] pSStree;

    wire [3  :0] pSType;

    wire [63 :0] nlevel1;
    wire [31 :0] nlevel2;
    wire [15 :0] nlevel3;
    wire [7  :0] nlevel4;
    wire [3  :0] nlevel5;

    wire [7  :0] nslevel1;
    wire [3  :0] nslevel2;

    wire [127:0] nLtree;

    wire [15 :0] nStree;
    wire [3  :0] nSStree;

    wire [3  :0] nSType;

    wire [3:0] ptree_type;
    wire [3:0] ntree_type;

    assign pLtree = node_input_p[147:20];
    assign pStree = node_input_p[19 : 4];
    assign pSStree= node_input_p[3  : 0];
	
    assign nLtree = node_input_n[147:20];
    assign nStree = node_input_n[19 : 4];
    assign nSStree= node_input_n[3  : 0];


    //level1 
    generate
        genvar i;
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(i = 16;i>0;i=i-1) begin
         p_node u_p_node(
         	.LNODE 	( pLtree[(8*i)-1    :(8*i)-4]  ),
         	.RNODE 	( pLtree[(8*i)-5    :(8*i)-8]  ),
         	.TYPE  	( plevel1[4*i-1     :4*(i-1)]  )
         );
        end
    endgenerate

    //level 2
    generate
        genvar k;
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(k = 8;k>0;k=k-1) begin
         p_node u_p_node(
         	.LNODE 	( plevel1[(8*k)-1    :(8*k)-4] ),
         	.RNODE 	( plevel1[(8*k)-5    :(8*k)-8] ),
         	.TYPE  	( plevel2[4*k-1     :4*(k-1)]  )
         );
        end
    endgenerate

    //level3
    generate
        genvar j;
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(j = 4;j>0;j=j-1) begin
         p_node u_p_node(
         	.LNODE 	( plevel2[(8*j)-1    :(8*j)-4] ),
         	.RNODE 	( plevel2[(8*j)-5    :(8*j)-8] ),
         	.TYPE  	( plevel3[4*j-1     :4*(j-1)]  )
         );
        end
    endgenerate

    //level4
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(j = 2;j>0;j=j-1) begin
         p_node u_p_node(
         	.LNODE 	( plevel3[(8*j)-1    :(8*j)-4] ),
         	.RNODE 	( plevel3[(8*j)-5    :(8*j)-8] ),
         	.TYPE  	( plevel4[4*j-1     :4*(j-1)]  )
         );
        end
    endgenerate
    
    //level 5
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(j = 1;j>0;j=j-1) begin
         p_node u_p_node(
         	.LNODE 	( plevel4[(8*j)-1    :(8*j)-4] ),
         	.RNODE 	( plevel4[(8*j)-5    :(8*j)-8] ),
         	.TYPE  	( plevel5[4*j-1      :4*(j-1)] )
         );
        end
    endgenerate


    //small tree level 1
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(j = 2;j>0;j=j-1) begin
         p_node u_p_node(
         	.LNODE 	( pStree[(8*j)-1      :(8*j)-4] ),
         	.RNODE 	( pStree[(8*j)-5      :(8*j)-8] ),
         	.TYPE  	( pslevel1[4*j-1      :4*(j-1)] )
         );
        end
    endgenerate
    
    //small tree level 2
        p_node u_p_node_sstree(
            .LNODE 	( pslevel1[7          :4] ),
            .RNODE 	( pslevel1[3          :0] ),
            .TYPE  	( pslevel2)
         );
     

    //Small tree and SS type

         p_node u_p_node_SLAST(
            .LNODE 	( pslevel2 ),
            .RNODE 	( pSStree),
            .TYPE  	( pSType)
         );
     

     p_node u_p_node_last(
         	.LNODE 	( plevel5 ),
         	.RNODE 	( pSType),
         	.TYPE  	( ptree_type )
     );   


    //ntree
     //level1 
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(i = 16;i>0;i=i-1) begin
         n_node u_n_node(
         	.LNODE 	( nLtree[(8*i)-1    :(8*i)-4]  ),
         	.RNODE 	( nLtree[(8*i)-5    :(8*i)-8]  ),
         	.TYPE  	( nlevel1[4*i-1     :4*(i-1)]  )
         );
        end
    endgenerate

    //level 2
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(k = 8;k>0;k=k-1) begin
         n_node u_n_node(
         	.LNODE 	( nlevel1[(8*k)-1    :(8*k)-4] ),
         	.RNODE 	( nlevel1[(8*k)-5    :(8*k)-8] ),
         	.TYPE  	( nlevel2[4*k-1     :4*(k-1)]  )
         );
        end
    endgenerate

    //level3
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(j = 4;j>0;j=j-1) begin
         n_node u_n_node(
         	.LNODE 	( nlevel2[(8*j)-1    :(8*j)-4] ),
         	.RNODE 	( nlevel2[(8*j)-5    :(8*j)-8] ),
         	.TYPE  	( nlevel3[4*j-1     :4*(j-1)]  )
         );
        end
    endgenerate

    //level4
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(j = 2;j>0;j=j-1) begin
         n_node u_n_node(
         	.LNODE 	( nlevel3[(8*j)-1    :(8*j)-4] ),
         	.RNODE 	( nlevel3[(8*j)-5    :(8*j)-8] ),
         	.TYPE  	( nlevel4[4*j-1     :4*(j-1)]  )
         );
        end
    endgenerate
    
    //level 5
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(j = 1;j>0;j=j-1) begin
         n_node u_n_node(
         	.LNODE 	( nlevel4[(8*j)-1    :(8*j)-4] ),
         	.RNODE 	( nlevel4[(8*j)-5    :(8*j)-8] ),
         	.TYPE  	( nlevel5[4*j-1      :4*(j-1)] )
         );
        end
    endgenerate


    //small tree
    generate
        // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
        for(j = 2;j>0;j=j-1) begin
         n_node u_n_node(
         	.LNODE 	( nStree[(8*j)-1      :(8*j)-4] ),
         	.RNODE 	( nStree[(8*j)-5      :(8*j)-8] ),
         	.TYPE  	( nslevel1[4*j-1      :4*(j-1)] )
         );
        end
    endgenerate
    
    //small tree level 2
        n_node u_n_node_sstree(
            .LNODE 	( nslevel1[7          :4] ),
            .RNODE 	( nslevel1[3          :0] ),
            .TYPE  	( nslevel2)
         );


         n_node u_n_node_SLAST(
            .LNODE 	( nslevel2 ),
            .RNODE 	( nSStree),
            .TYPE  	( nSType)
         );
     

     n_node u_n_node_last(
         	.LNODE 	( nlevel5 ),
         	.RNODE 	( nSType),
         	.TYPE  	( ntree_type )
     );   

     assign correct = (ntree_type == 4'b1000)||(ptree_type == 4'b1000);
 endmodule

module correction_tree_N41
    (
        input  [163:0] node_input_n,node_input_p,
        output         correct
    );
        //5level
        wire [63 :0] plevel1;
        wire [31 :0] plevel2;
        wire [15 :0] plevel3;
        wire [7  :0] plevel4;
        wire [3  :0] plevel5;
    
        wire [15 :0] pslevel1;
        wire [7  :0] pslevel2;
        wire [3  :0] pslevel3;

        wire [127:0] pLtree;
    
        wire [31 :0] pStree;
        wire [3  :0] pSStree;
    
        wire [3  :0] pSType;
    
        wire [63 :0] nlevel1;
        wire [31 :0] nlevel2;
        wire [15 :0] nlevel3;
        wire [7  :0] nlevel4;
        wire [3  :0] nlevel5;
    
        wire [15 :0] nslevel1;
        wire [7  :0] nslevel2;
        wire [3  :0] nslevel3;
    
        wire [127:0] nLtree;
    
        wire [31 :0] nStree;
        wire [3  :0] nSStree;
    
        wire [3  :0] nSType;
    
        wire [3:0] ptree_type;
        wire [3:0] ntree_type;
    
        assign pLtree = node_input_p[163:36];
        assign pStree = node_input_p[35 : 4];
        assign pSStree= node_input_p[3  : 0];
        assign nLtree = node_input_n[163:36];
        assign nStree = node_input_n[35 : 4];
        assign nSStree= node_input_n[3  : 0];
    
    
        //level1 
        generate
            genvar i;
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(i = 16;i>0;i=i-1) begin
             p_node u_p_node(
                 .LNODE 	( pLtree[(8*i)-1    :(8*i)-4]  ),
                 .RNODE 	( pLtree[(8*i)-5    :(8*i)-8]  ),
                 .TYPE  	( plevel1[4*i-1     :4*(i-1)]  )
             );
            end
        endgenerate
    
        //level 2
        generate
            genvar k;
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(k = 8;k>0;k=k-1) begin
             p_node u_p_node(
                 .LNODE 	( plevel1[(8*k)-1    :(8*k)-4] ),
                 .RNODE 	( plevel1[(8*k)-5    :(8*k)-8] ),
                 .TYPE  	( plevel2[4*k-1     :4*(k-1)]  )
             );
            end
        endgenerate
    
        //level3
        generate
            genvar j;
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 4;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( plevel2[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( plevel2[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( plevel3[4*j-1     :4*(j-1)]  )
             );
            end
        endgenerate
    
        //level4
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 2;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( plevel3[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( plevel3[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( plevel4[4*j-1     :4*(j-1)]  )
             );
            end
        endgenerate
        
        //level 5
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 1;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( plevel4[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( plevel4[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( plevel5[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
    
    
        //small tree level 1
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 4;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( pStree[(8*j)-1      :(8*j)-4] ),
                 .RNODE 	( pStree[(8*j)-5      :(8*j)-8] ),
                 .TYPE  	( pslevel1[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
        
        //small tree level 2
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 2;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( pslevel1[(8*j)-1      :(8*j)-4] ),
                 .RNODE 	( pslevel1[(8*j)-5      :(8*j)-8] ),
                 .TYPE  	( pslevel2[4*j-1        :4*(j-1)] )
             );
            end
        endgenerate
         
        p_node u_p_node_sstree(
                .LNODE 	( pslevel2[7          :4] ),
                .RNODE 	( pslevel2[3          :0] ),
                .TYPE  	( pslevel3)
             );
    
        
        //Small tree and SS type
    
             p_node u_p_node_SLAST(
                .LNODE 	( pslevel3 ),
                .RNODE 	( pSStree),
                .TYPE  	( pSType)
             );
         
    
         p_node u_p_node_last(
                 .LNODE 	( plevel5 ),
                 .RNODE 	( pSType),
                 .TYPE  	( ptree_type )
         );   
    
    
        //ntree
         //level1 
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(i = 16;i>0;i=i-1) begin
             n_node u_n_node(
                 .LNODE 	( nLtree[(8*i)-1    :(8*i)-4]  ),
                 .RNODE 	( nLtree[(8*i)-5    :(8*i)-8]  ),
                 .TYPE  	( nlevel1[4*i-1     :4*(i-1)]  )
             );
            end
        endgenerate
    
        //level 2
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(k = 8;k>0;k=k-1) begin
             n_node u_n_node(
                 .LNODE 	( nlevel1[(8*k)-1    :(8*k)-4] ),
                 .RNODE 	( nlevel1[(8*k)-5    :(8*k)-8] ),
                 .TYPE  	( nlevel2[4*k-1     :4*(k-1)]  )
             );
            end
        endgenerate
    
        //level3
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 4;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nlevel2[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( nlevel2[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( nlevel3[4*j-1     :4*(j-1)]  )
             );
            end
        endgenerate
    
        //level4
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 2;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nlevel3[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( nlevel3[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( nlevel4[4*j-1     :4*(j-1)]  )
             );
            end
        endgenerate
        
        //level 5
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 1;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nlevel4[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( nlevel4[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( nlevel5[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
    
    
      //small tree level 1
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 4;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nStree[(8*j)-1      :(8*j)-4] ),
                 .RNODE 	( nStree[(8*j)-5      :(8*j)-8] ),
                 .TYPE  	( nslevel1[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
        
        //small tree level 2
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 2;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nslevel1[(8*j)-1      :(8*j)-4] ),
                 .RNODE 	( nslevel1[(8*j)-5      :(8*j)-8] ),
                 .TYPE  	( nslevel2[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
         
        n_node u_n_node_sstree(
                .LNODE 	( nslevel2[7          :4] ),
                .RNODE 	( nslevel2[3          :0] ),
                .TYPE  	( nslevel3)
             );
    
        
        //Small tree and SS type
    
             n_node u_n_node_SLAST(
                .LNODE 	( nslevel3 ),
                .RNODE 	( nSStree),
                .TYPE  	( nSType)
             );
         
    
         n_node u_n_node_last(
                 .LNODE 	( nlevel5 ),
                 .RNODE 	( nSType),
                 .TYPE  	( ntree_type )
         );   
    
         assign correct = (ntree_type == 4'b1000)||(ptree_type == 4'b1000);
     endmodule

module correction_tree_N34(
        input  [135:0] node_input_n,node_input_p,
        output         correct
    );
        //5level
        wire [63 :0] plevel1;
        wire [31 :0] plevel2;
        wire [15 :0] plevel3;
        wire [7  :0] plevel4;
        wire [3  :0] plevel5;
        wire [3  :0] pslevel1;
        wire [127:0] pLtree;
        wire [7  :0] pStree;
    
        wire [63 :0] nlevel1;
        wire [31 :0] nlevel2;
        wire [15 :0] nlevel3;
        wire [7  :0] nlevel4;
        wire [3  :0] nlevel5;
        wire [3  :0] nslevel1;
        wire [127:0] nLtree;
        wire [7  :0] nStree;
    
        wire [3:0] ptree_type;
        wire [3:0] ntree_type;
    
        assign pLtree = node_input_p[135:8];
        assign pStree = node_input_p[7  :0];
		
        assign nLtree = node_input_n[135:8];
        assign nStree = node_input_n[7  :0];
    
    
        //level1 
        generate
            genvar i;
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(i = 16;i>0;i=i-1) begin
             p_node u_p_node(
                 .LNODE 	( pLtree[(8*i)-1    :(8*i)-4]  ),
                 .RNODE 	( pLtree[(8*i)-5    :(8*i)-8]  ),
                 .TYPE  	( plevel1[4*i-1     :4*(i-1)]  )
             );
            end
        endgenerate
    
        //level 2
        generate
            genvar k;
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(k = 8;k>0;k=k-1) begin
             p_node u_p_node(
                 .LNODE 	( plevel1[(8*k)-1    :(8*k)-4] ),
                 .RNODE 	( plevel1[(8*k)-5    :(8*k)-8] ),
                 .TYPE  	( plevel2[4*k-1     :4*(k-1)]  )
             );
            end
        endgenerate
    
        //level3
        generate
            genvar j;
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 4;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( plevel2[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( plevel2[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( plevel3[4*j-1     :4*(j-1)]  )
             );
            end
        endgenerate
    
        //level4
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 2;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( plevel3[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( plevel3[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( plevel4[4*j-1     :4*(j-1)]  )
             );
            end
        endgenerate
        
        //level 5
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 1;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( plevel4[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( plevel4[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( plevel5[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
    
    
        //small tree
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 1;j>0;j=j-1) begin
             p_node u_p_node(
                 .LNODE 	( pStree[(8*j)-1      :(8*j)-4] ),
                 .RNODE 	( pStree[(8*j)-5      :(8*j)-8] ),
                 .TYPE  	( pslevel1[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
        
         p_node u_p_node_last(
                 .LNODE 	( plevel5 ),
                 .RNODE 	( pslevel1 ),
                 .TYPE  	( ptree_type )
         );   
    
    
        //ntree
         //level1 
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(i = 16;i>0;i=i-1) begin
             n_node u_n_node(
                 .LNODE 	( nLtree[(8*i)-1    :(8*i)-4]  ),
                 .RNODE 	( nLtree[(8*i)-5    :(8*i)-8]  ),
                 .TYPE  	( nlevel1[4*i-1     :4*(i-1)]  )
             );
            end
        endgenerate
    
        //level 2
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(k = 8;k>0;k=k-1) begin
             n_node u_n_node(
                 .LNODE 	( nlevel1[(8*k)-1    :(8*k)-4] ),
                 .RNODE 	( nlevel1[(8*k)-5    :(8*k)-8] ),
                 .TYPE  	( nlevel2[4*k-1     :4*(k-1)]  )
             );
            end
        endgenerate
    
        //level3
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 4;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nlevel2[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( nlevel2[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( nlevel3[4*j-1     :4*(j-1)]  )
             );
            end
        endgenerate
    
        //level4
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 2;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nlevel3[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( nlevel3[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( nlevel4[4*j-1     :4*(j-1)]  )
             );
            end
        endgenerate
        
        //level 5
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 1;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nlevel4[(8*j)-1    :(8*j)-4] ),
                 .RNODE 	( nlevel4[(8*j)-5    :(8*j)-8] ),
                 .TYPE  	( nlevel5[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
    
    
        //small tree
        generate
            // @SuppressProblem -type unnamed_generate_block_other -count 1 -length 1
            for(j = 1;j>0;j=j-1) begin
             n_node u_n_node(
                 .LNODE 	( nStree[(8*j)-1      :(8*j)-4] ),
                 .RNODE 	( nStree[(8*j)-5      :(8*j)-8] ),
                 .TYPE  	( nslevel1[4*j-1      :4*(j-1)] )
             );
            end
        endgenerate
        
         n_node u_n_node_last(
                 .LNODE 	( nlevel5 ),
                 .RNODE 	( nslevel1 ),
                 .TYPE  	( ntree_type )
         );   
    
         assign correct = (ntree_type == 4'b1000)||(ptree_type == 4'b1000);
endmodule