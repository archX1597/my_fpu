`include "FPU.svh"
package FPU_pkg;
    typedef struct packed {
        logic sign;
        logic [`FLOAT_32_EXP -1  : 0] exp;
        logic [`FLOAT_32_FRAC -1 : 0] frac;
    } float_type;
    typedef logic [3:0] Node;
endpackage