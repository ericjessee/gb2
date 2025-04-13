package sm83_pkg;
`include "opcodes.vh"

typedef enum logic [2:0] {
    REG_B,
    REG_C,
    REG_D,
    REG_E,
    REG_H,
    REG_L,
    REG_A
} gp_r8_sel_t;

typedef enum logic [1:0] {
    REG_BC,
    REG_DE,
    REG_HL,
    REG_SP,
} gp_r16_sel_t;

typedef enum logic [1:0] {
    REG_BC,
    REG_DE,
    REG_HL,
    REG_AF,
} stk_r16_sel_t;

typedef enum logic [1:0] {
    REG_BC,
    REG_DE,
    REG_HLI,
    REG_HLD,
} mem_r16_sel_t;

typedef enum logic [5:0] {
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
    ALU_SCF,
    ALU_CCF,
    ALU_CPL,
    ALU_DAA
} alu_op_t;

typedef enum logic [] {
    CTL_NOP,
    CTL_HALT,
    CTL_STOP, //?
    CTL_JR,
    CTL_ALU_A,
    CTL_ALU_A_R8,
    CTL_ALU_HL_R16,
    CTL_LD_R8_D8,
    CTL_LD_R8_R8,
    CTL_LD_R16_D16,
    CTL_LDPTR_R16_A,
    CTL_LDPTR_A_R16,
    CTL_LDPTR_R16_D8,
    CTL_LDPTR_R8_R16,
    CTL_LDPTR_D16_SP,
    CTL_INC16,
    CTL_DEC16
} ctl_op_t;

typedef enum logic [1:0] { 
    J_NZ,
    J_Z,
    J_NC,
    J_C
} j_cond_t;

typedef enum logic [1:0] {
    BLOCK_0,
    BLOCK_1,
    BLOCK_2,
    BLOCK_3
} instr_block_t;

typedef enum logic [3:0] {
    B0_LD_R16_D16   = 4'h1,
    B0_LDPTR_R16_A  = 4'h2,
    B0_LDPTR_A_R16  = 4'ha,
    B0_INC_R16      = 4'h3,
    B0_DEC_R16,     = 4'hb,
    B0_ADD_HL_R16   = 4'h9
} b0_op16_t;

typedef enum logic [4:0] {
    B0_RLCA = 5'h0,
    B0_RRCA = 5'h1,
    B0_RLA =  5'h2,
    B0_RRA =  5'h3,
    B0_DAA =  5'h4,
    B0_CPL =  5'h5,
    B0_SCF =  5'h6,
    B0_CCF =  5'h7
} b0_op1_t;

typedef logic [7:0]  r8_t;
typedef logic [7:0]  data_t;

typedef struct packed {
    data_t msb;
    data_t lsb;
} addr_t;

typedef struct packed {
    r8_t msb;
    r8_t lsb;
} r16_t;

typedef union packed {
    gp_r16_sel_t  r16;
    stk_r16_sel_t r16stk;
    mem_r16_sel_t r16mem;
} r16_sel_t;

typedef struct packed {
    r16_sel_t   r16;
    b0_op16_t   op; //true if lower 3 bits != (100 || 101 || 110 || 111) (and not a jump???)
} instr_body_b0_op16_t;

typedef struct packed {
    gp_r8_sel_t r8;
    logic [2:1] const10; //10 if true
    logic       dec_ninc;
} instr_body_b0_op_inc8_t;

typedef struct packed {
    gp_r8_sel_t rd;
    logic [2:0] const110; //110 if true
} instr_body_b0_ld_r8_d8_t;

typedef struct packed {
    b0_op1_t op;
    logic [2:0] const111; //111 if true
} instr_body_b0_op1_t;

typedef struct packed {
    logic       is_cond; //1 if conditional jump
    j_cond_t    cond;
    logic [2:0] const000; //000 if true
} instr_body_b0_jp_t;

typedef union packed {
    instr_body_b0_op16_t     op16; 
    instr_body_b0_op_inc8_t  inc8;
    instr_body_b0_ld_r8_d8_t ldimm8;
    instr_body_b0_op1_t      op1;
    instr_body_b0_jp_t       jp;
} instr_body_b0_t;

typedef struct packed {
    logic [5:3] rd;
    logic [2:0] rs;
} instr_body_b1_ld_r8_r8_t;

typedef union packed {
    logic [5:0]              raw;
    instr_body_b1_ld_r8_r8_t ld_r8_r8;
    instr_body_b0_t          b0;
} instr_body_t;

typedef struct packed {
    instr_block_t block;
    instr_body_t  body
} instr_t;

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