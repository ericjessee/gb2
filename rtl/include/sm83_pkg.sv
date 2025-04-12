package sm83_pkg;

typedef enum logic [2:0] {
    REG_B,
    REG_C,
    REG_D,
    REG_E,
    REG_H,
    REG_L
} gp_r8_sel_t;

typedef enum logic [1:0] {
    REG_BC,
    REG_DE,
    REG_HL
} gp_r16_sel_t;

typedef enum logic [8:0] {
    OP_NOP,
    OP_ADC,
    OP_ADD,
    OP_AND,
    OP_CP,
    OP_DEC,
    OP_INC,
    OP_OR,
    OP_SBC,
    OP_SUB,
    OP_XOR,
    OP_BIT,
    OP_RES,
    OP_SET,
    OP_SWAP,
    OP_RL,
    OP_RLA,
    OP_RLC,
    OP_RR,
    OP_RRA,
    OP_RRC,
    OP_RRCA,
    OP_SLA,
    OP_SRA,
    OP_SRL,
    OP_CCF,
    OP_CPL,
    OP_DAA
} alu_op_t;

typedef logic [8:0] r8_t;

typedef struct packed {
    r8_t msb;
    r8_t lsb;
} r16_t;

typedef struct packed {
    logic       z;
    logic       n;
    logic       h;
    logic       c;
    logic [3:0] pad;
} flags_t;

/* verilator lint_off ASCRANGE */
typedef union packed{
    r16_t r16;
    r8_t [0:1] r8;
} r8_16_t;
/* verilator lint_on ASCRANGE */

typedef struct packed {
    logic ir;
    logic ie;
    logic a;
    logic f;
    logic gp8;
    logic gp16;
    logic pc;
    logic sp;
} reg_wen_vec_t;

typedef struct packed {
    r8_t    ir;
    r8_t    ie;
    r8_t    a;
    flags_t f;
    r8_16_t b_c;
    r8_16_t d_e;
    r8_16_t h_l;
    r16_t   pc;
    r16_t   sp;
} reg_vec_t;

endpackage