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
    ALU_NOP,
    ALU_ADC, ALU_ADD,
    ALU_AND,
    ALU_CP,
    ALU_DEC, ALU_INC,
    ALU_OR,
    ALU_SBC, ALU_SUB,
    ALU_XOR,
    ALU_BIT_0, ALU_BIT_1, ALU_BIT_2, ALU_BIT_3,
    ALU_BIT_4, ALU_BIT_5, ALU_BIT_6, ALU_BIT_7,
    ALU_RES_0, ALU_RES_1, ALU_RES_2, ALU_RES_3,
    ALU_RES_4, ALU_RES_5, ALU_RES_6, ALU_RES_7,
    ALU_SET_0, ALU_SET_1, ALU_SET_2, ALU_SET_3,
    ALU_SET_4, ALU_SET_5, ALU_SET_6, ALU_SET_7,
    ALU_SWAP,
    ALU_RL,
    ALU_RLC,
    ALU_RR,
    ALU_RRA,
    ALU_RRC,
    ALU_RRCA,
    ALU_SLA,
    ALU_SRA,
    ALU_SRL,
    ALU_CCF,
    ALU_CPL,
    ALU_DAA
} alu_op_t;

// typedef enum logic [] {
    
// } opcode_t;

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