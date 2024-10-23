module FAR_PATH #(
    parameter FRAC_WIDTH = 24,
    parameter EXP_WIDTH  = 8
)(
    input  [FRAC_WIDTH-1 : 0] esmall_op, elarge_op,
    input  [EXP_WIDTH-1  : 0] exp_f,
    input  [EXP_WIDTH    : 0] diff_abs,
    input  sign_diff,
    output [FRAC_WIDTH+2 : 0] far_result,
    output [EXP_WIDTH-1  : 0] exp_far
);

    // Signals to handle exponent and fraction shifts
    logic  [EXP_WIDTH -1 : 0] exp_L_shift, exp_R_shift;
    logic  [FRAC_WIDTH+3 : 0] far_aligned_esmall_op, far_aligned_elarge_op; // FRAC_WIDTH + 3 bits
    logic  [FRAC_WIDTH+2 : 0] far_esmall_op; // Shifted esmall_op with guard, round, sticky bits
    logic  [FRAC_WIDTH+3 : 0] far_result_tonormalize;
    logic  far_normalLshift, far_normalRshift;

    // Shift logic using decoder (case statement)
    always @(*) begin : shifter
        case (diff_abs)
           9'd 0: begin
                // No shift needed
                far_esmall_op = {esmall_op, 3'b000};
            end
           9'd 1: begin
                // Shift by 1
                far_esmall_op = {
                    1'b0, // Pad MSB
                    esmall_op[FRAC_WIDTH-1:1], // Shifted significand
                    esmall_op[0],              // Guard bit
                    1'b0,                      // Round bit
                    1'b0                       // Sticky bit
                };
            end
           9'd 2: begin
                // Shift by 2
                far_esmall_op = {
                    2'b0,
                    esmall_op[FRAC_WIDTH-1:2],
                    esmall_op[1],              // Guard bit
                    esmall_op[0],              // Round bit
                    1'b0                       // Sticky bit
                };
            end
           9'd 3: begin
                // Shift by 3
                far_esmall_op = {
                    3'b0,
                    esmall_op[FRAC_WIDTH-1:3],
                    esmall_op[2],              // Guard bit
                    esmall_op[1],              // Round bit
                    |esmall_op[0]              // Sticky bit
                };
            end
           9'd 4: begin
                // Shift by 4
                far_esmall_op = {
                    4'b0,
                    esmall_op[FRAC_WIDTH-1:4],
                    esmall_op[3],              // Guard bit
                    esmall_op[2],              // Round bit
                    |esmall_op[1:0]            // Sticky bit
                };
            end
           9'd 5: begin
                // Shift by 5
                far_esmall_op = {
                    5'b0,
                    esmall_op[FRAC_WIDTH-1:5],
                    esmall_op[4],              // Guard bit
                    esmall_op[3],              // Round bit
                    |esmall_op[2:0]            // Sticky bit
                };
            end
           9'd 6: begin
                // Shift by 6
                far_esmall_op = {
                    6'b0,
                    esmall_op[FRAC_WIDTH-1:6],
                    esmall_op[5],              // Guard bit
                    esmall_op[4],              // Round bit
                    |esmall_op[3:0]            // Sticky bit
                };
            end
           9'd 7: begin
                // Shift by 7
                far_esmall_op = {
                    7'b0,
                    esmall_op[FRAC_WIDTH-1:7],
                    esmall_op[6],              // Guard bit
                    esmall_op[5],              // Round bit
                    |esmall_op[4:0]            // Sticky bit
                };
            end
           9'd 8: begin
                // Shift by 8
                far_esmall_op = {
                    8'b0,
                    esmall_op[FRAC_WIDTH-1:8],
                    esmall_op[7],              // Guard bit
                    esmall_op[6],              // Round bit
                    |esmall_op[5:0]            // Sticky bit
                };
            end
           9'd 9: begin
                // Shift by 9
                far_esmall_op = {
                    9'b0,
                    esmall_op[FRAC_WIDTH-1:9],
                    esmall_op[8],              // Guard bit
                    esmall_op[7],              // Round bit
                    |esmall_op[6:0]            // Sticky bit
                };
            end
            9'd10: begin
                // Shift by 10
                far_esmall_op = {
                    10'b0,
                    esmall_op[FRAC_WIDTH-1:10],
                    esmall_op[9],              // Guard bit
                    esmall_op[8],              // Round bit
                    |esmall_op[7:0]            // Sticky bit
                };
            end
            9'd11: begin
                // Shift by 11
                far_esmall_op = {
                    11'b0,
                    esmall_op[FRAC_WIDTH-1:11],
                    esmall_op[10],             // Guard bit
                    esmall_op[9],              // Round bit
                    |esmall_op[8:0]            // Sticky bit
                };
            end
            9'd12: begin
                // Shift by 12
                far_esmall_op = {
                    12'b0,
                    esmall_op[FRAC_WIDTH-1:12],
                    esmall_op[11],             // Guard bit
                    esmall_op[10],             // Round bit
                    |esmall_op[9:0]            // Sticky bit
                };
            end
            9'd13: begin
                // Shift by 13
                far_esmall_op = {
                    13'b0,
                    esmall_op[FRAC_WIDTH-1:13],
                    esmall_op[12],             // Guard bit
                    esmall_op[11],             // Round bit
                    |esmall_op[10:0]           // Sticky bit
                };
            end
            9'd14: begin
                // Shift by 14
                far_esmall_op = {
                    14'b0,
                    esmall_op[FRAC_WIDTH-1:14],
                    esmall_op[13],             // Guard bit
                    esmall_op[12],             // Round bit
                    |esmall_op[11:0]           // Sticky bit
                };
            end
            9'd15: begin
                // Shift by 15
                far_esmall_op = {
                    15'b0,
                    esmall_op[FRAC_WIDTH-1:15],
                    esmall_op[14],             // Guard bit
                    esmall_op[13],             // Round bit
                    |esmall_op[12:0]           // Sticky bit
                };
            end
            9'd16: begin
                // Shift by 16
                far_esmall_op = {
                    16'b0,
                    esmall_op[FRAC_WIDTH-1:16],
                    esmall_op[15],             // Guard bit
                    esmall_op[14],             // Round bit
                    |esmall_op[13:0]           // Sticky bit
                };
            end
            9'd17: begin
                // Shift by 17
                far_esmall_op = {
                    17'b0,
                    esmall_op[FRAC_WIDTH-1:17],
                    esmall_op[16],             // Guard bit
                    esmall_op[15],             // Round bit
                    |esmall_op[14:0]           // Sticky bit
                };
            end
            9'd18: begin
                // Shift by 18
                far_esmall_op = {
                    18'b0,
                    esmall_op[FRAC_WIDTH-1:18],
                    esmall_op[17],             // Guard bit
                    esmall_op[16],             // Round bit
                    |esmall_op[15:0]           // Sticky bit
                };
            end
            9'd19: begin
                // Shift by 19
                far_esmall_op = {
                    19'b0,
                    esmall_op[FRAC_WIDTH-1:19],
                    esmall_op[18],             // Guard bit
                    esmall_op[17],             // Round bit
                    |esmall_op[16:0]           // Sticky bit
                };
            end
            9'd20: begin
                // Shift by 20
                far_esmall_op = {
                    20'b0,
                    esmall_op[FRAC_WIDTH-1:20],
                    esmall_op[19],             // Guard bit
                    esmall_op[18],             // Round bit
                    |esmall_op[17:0]           // Sticky bit
                };
            end
            9'd21: begin
                // Shift by 21
                far_esmall_op = {
                    21'b0,
                    esmall_op[FRAC_WIDTH-1:21],
                    esmall_op[20],             // Guard bit
                    esmall_op[19],             // Round bit
                    |esmall_op[18:0]           // Sticky bit
                };
            end
            9'd22: begin
                // Shift by 22
                far_esmall_op = {
                    22'b0,
                    esmall_op[FRAC_WIDTH-1:22],
                    esmall_op[21],             // Guard bit
                    esmall_op[20],             // Round bit
                    |esmall_op[19:0]           // Sticky bit
                };
            end
            9'd23: begin
                // Shift by 23
                far_esmall_op = {
                    23'b0,
                    esmall_op[FRAC_WIDTH-1:23],
                    esmall_op[22],             // Guard bit
                    esmall_op[21],             // Round bit
                    |esmall_op[20:0]           // Sticky bit
                };
            end
            9'd24: begin
                // Shift by 24
                far_esmall_op = {
                    24'b0,
                    1'b0,                      // Guard bit
                    esmall_op[FRAC_WIDTH-1],   // Round bit
                    |esmall_op[FRAC_WIDTH-2:0] // Sticky bit
                };
            end
            default: begin
                // Shift amount exceeds significand width, result is zero
                far_esmall_op = { {FRAC_WIDTH{1'b0}}, 3'b000 };
            end
        endcase
    end

    // Align elarge_op with 3 extra bits for guard, round, and sticky bits
    assign far_aligned_elarge_op = {1'b0, elarge_op, 3'b00};
    assign far_aligned_esmall_op = {1'b0,far_esmall_op};

    // Perform fixed-point addition or subtraction
    assign far_result_tonormalize = sign_diff ?
                                    far_aligned_elarge_op - far_aligned_esmall_op :
                                    far_aligned_elarge_op + far_aligned_esmall_op;

    // Normalization shift detection
    assign far_normalRshift = far_result_tonormalize[FRAC_WIDTH+3];
    assign far_normalLshift = ~(far_result_tonormalize[FRAC_WIDTH+3] | far_result_tonormalize[FRAC_WIDTH+2]);

    // Final result normalization
    assign far_result = far_normalRshift ? far_result_tonormalize[FRAC_WIDTH+3 : 1] :
                        far_normalLshift ? {far_result_tonormalize[FRAC_WIDTH+1: 0], 1'b0} :
                                           far_result_tonormalize[FRAC_WIDTH+2 : 0];

    // Exponent adjustments
    assign exp_L_shift = exp_f - 1;
    assign exp_R_shift = exp_f + 1;

    // Final exponent
    assign exp_far = far_normalRshift ? exp_R_shift :
                     far_normalLshift ? exp_L_shift :
                                        exp_f;

endmodule
