module p_node(
    input      [3:0] LNODE,
    input      [3:0] RNODE,
    output reg [3:0] TYPE 
);
    parameter Z=4'b0001;
    parameter P=4'b0010;
    parameter N=4'b0100;
    parameter Y=4'b1000;
    parameter U=4'b0000;

    

    always@(*) begin
        case({LNODE,RNODE}) 
        {Z,Z}      :TYPE = Z;
        {Z,P}      :TYPE = P;
        {P,Z}      :TYPE = P;
        {N,Z}      :TYPE = N;
        {N,P}      :TYPE = N;
        {N,N}      :TYPE = N;
        {N,Y}      :TYPE = N;
        {N,U}      :TYPE = N;
        {Z,N}      :TYPE = N;
        {Y,Z}      :TYPE = Y;
        {Y,P}      :TYPE = Y;
        {Y,N}      :TYPE = Y;
        {Y,Y}      :TYPE = Y;
        {Y,U}      :TYPE = Y;
        {Z,Y}      :TYPE = Y;
        {P,N}      :TYPE = Y;
        default    :TYPE = U;
        endcase
    end
endmodule //moduleName

module n_node(
    input      [3:0] LNODE,
    input      [3:0] RNODE,
    output reg [3:0] TYPE 
);
    parameter Z=4'b0001;
    parameter P=4'b0010;
    parameter N=4'b0100;
    parameter Y=4'b1000;
    parameter U=4'b0000;

    always@(*) begin
        case({LNODE,RNODE}) 
        {Z,Z}      :TYPE = Z;
        {Z,N}      :TYPE = N;
        {N,Z}      :TYPE = N;
        {P,Z}      :TYPE = P;
        {P,P}      :TYPE = P;
        {P,N}      :TYPE = P;
        {P,Y}      :TYPE = P;
        {P,U}      :TYPE = P;
        {Z,P}      :TYPE = P;
        {Y,Z}      :TYPE = Y;
        {Y,P}      :TYPE = Y;
        {Y,N}      :TYPE = Y;
        {Y,Y}      :TYPE = Y;
        {Y,U}      :TYPE = Y;
        {Z,Y}      :TYPE = Y;
        {N,P}      :TYPE = Y;
        default    :TYPE = U;
        endcase
    end
endmodule //moduleName
