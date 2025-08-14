package sm83_pkg;
`include "opcodes.vh"

typedef enum logic [2:0] {
    REG_B,
    REG_C,
    REG_D,
    REG_E,
    REG_H,
    REG_L,
    REG_Z,
    REG_A
} gp_r8_sel_t;

typedef enum logic [1:0] {
    R16_BC,
    R16_DE,
    R16_HL,
    R16_SP
} gp_r16_sel_t;

typedef enum logic [1:0] {
    R16STK_BC,
    R16STK_DE,
    R16STK_HL,
    R16STK_AF
} stk_r16_sel_t;

typedef enum logic [1:0] {
    R16MEM_BC,
    R16MEM_DE,
    R16MEM_HLI,
    R16MEM_HLD
} mem_r16_sel_t;

typedef enum logic [5:0] {
    ALU_NOP,              // 0x00
    ALU_LD1,              // 0x01
    ALU_LD2,              // 0x02
    ALU_ADC,              // 0x03
    ALU_ADD,              // 0x04
    ALU_AND,              // 0x05
    ALU_CP,               // 0x06
    ALU_DEC,              // 0x07
    ALU_INC,              // 0x08
    ALU_OR,               // 0x09
    ALU_SBC,              // 0x0A
    ALU_SUB,              // 0x0B
    ALU_XOR,              // 0x0C
    ALU_BIT_0,            // 0x0D
    ALU_BIT_1,            // 0x0E
    ALU_BIT_2,            // 0x0F
    ALU_BIT_3,            // 0x10
    ALU_BIT_4,            // 0x11
    ALU_BIT_5,            // 0x12
    ALU_BIT_6,            // 0x13
    ALU_BIT_7,            // 0x14
    ALU_RES_0,            // 0x15
    ALU_RES_1,            // 0x16
    ALU_RES_2,            // 0x17
    ALU_RES_3,            // 0x18
    ALU_RES_4,            // 0x19
    ALU_RES_5,            // 0x1A
    ALU_RES_6,            // 0x1B
    ALU_RES_7,            // 0x1C
    ALU_SET_0,            // 0x1D
    ALU_SET_1,            // 0x1E
    ALU_SET_2,            // 0x1F
    ALU_SET_3,            // 0x20
    ALU_SET_4,            // 0x21
    ALU_SET_5,            // 0x22
    ALU_SET_6,            // 0x23
    ALU_SET_7,            // 0x24
    ALU_SWAP,             // 0x25
    ALU_RL,               // 0x26
    ALU_RLC,              // 0x27
    ALU_RR,               // 0x28
    ALU_RRA,              // 0x29
    ALU_RRC,              // 0x2A
    ALU_RRCA,             // 0x2B
    ALU_SLA,              // 0x2C
    ALU_SRA,              // 0x2D
    ALU_SRL,              // 0x2E
    ALU_SCF,              // 0x2F
    ALU_CCF,              // 0x30
    ALU_CPL,              // 0x31
    ALU_DAA               // 0x32
} alu_op_t;

typedef enum logic [7:0] { // should be downsized
    CTL_NOP,               // 0x00
    CTL_HALT,              // 0x01
    CTL_STOP,              // 0x02
    CTL_RST,               // 0x03
    CTL_DI,                // 0x04
    CTL_EI,                // 0x05
    CTL_JR,                // 0x06
    CTL_JR_COND,           // 0x07
    CTL_JP_COND,           // 0x08
    CTL_JP_A16,            // 0x09
    CTL_JP_HL,             // 0x0A
    CTL_CALL_A16,          // 0x0B
    CTL_CALL_COND_A16,     // 0x0C
    CTL_RET_COND,          // 0x0D
    CTL_RET,               // 0x0E
    CTL_RETI,              // 0x0F
    CTL_ALU_A,             // 0x10
    CTL_ALU_A_R8,          // 0x11
    CTL_ALU_A_D8,          // 0x12
    CTL_ALU_R8,            // 0x13
    CTL_ALU_HL_R16,        // 0x14
    CTL_ADD_SP_D8,         // 0x15
    CTL_LD_HL_SP_D8,       // 0x16
    CTL_LD_SP_HL,          // 0x17
    CTL_LD_R8_D8,          // 0x18
    CTL_LD_R8_R8,          // 0x19
    CTL_LD_R16_D16,        // 0x1A
    CTL_LDPTR_R8_HL,       // 0x1B
    CTL_LDPTR_HL_R8,       // 0x1C
    CTL_LDPTR_HL_D8,       // 0x1D
    CTL_LDPTR_R16_A,       // 0x1E
    CTL_LDPTR_A_R16,       // 0x1F
    CTL_LDPTR_R16_D8,      // 0x20
    CTL_LDPTR_R8_R16,      // 0x21
    CTL_LDPTR_D16_SP,      // 0x22
    CTL_LDPTRH_C_A,        // 0x23
    CTL_LDPTRH_A_C,        // 0x24
    CTL_LDPTR_A8_A,        // 0x25
    CTL_LDPTR_A_A8,        // 0x26
    CTL_LDPTR_A16_A,       // 0x27
    CTL_LDPTR_A_A16,       // 0x28
    CTL_INC16,             // 0x29
    CTL_DEC16,             // 0x2A
    CTL_POP_STACK,         // 0x2B
    CTL_PUSH_STACK         // 0x2C
} ctl_op_t;


typedef enum logic [7:0] { //should size this smaller
    EX_IDLE,
    EX_ALU_A_R8,
    EX_ALU_R8,
    EX_ALU_LD1,
    EX_MEM_TO_Z,
    EX_MEM_TO_W,
    EX_MEM_TO_W_COND,
    EX_MEM_WZ_TO_Z,
    EX_Z_TO_MEM,
    EX_R8_TO_MEM,
    EX_A_TO_WZ_MEM,
    EX_WZ_TO_PC,
    EX_WZ_TO_R16,
    EX_INC_R16,
    EX_DEC_R16,
    EX_PCH_TO_MEM,
    EX_PCL_TO_MEM,
    EX_ADJ_PC_TO_WZ,
    EX_HALT
} ex_state_t;

typedef enum logic [2:0] {
    NONE,
    PC,
    PCH,
    SP,
    GP16,
    WZ,
    FF_C
} addr_sel_t;

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
    B0_DEC_R16      = 4'hb,
    B0_ADD_HL_R16   = 4'h9
} b0_op16_t;

typedef enum logic [2:0] {
    B0_RLCA = 3'h0,
    B0_RRCA = 3'h1,
    B0_RLA =  3'h2,
    B0_RRA =  3'h3,
    B0_DAA =  3'h4,
    B0_CPL =  3'h5,
    B0_SCF =  3'h6,
    B0_CCF =  3'h7
} b0_op1_t;

typedef enum logic [2:0] {
    ADD = 3'h0,
    ADC = 3'h1,
    SUB = 3'h2,
    SBC = 3'h3,
    AND = 3'h4,
    XOR = 3'h5,
    OR  = 3'h6,
    CP  = 3'h7
} b2_3_alu_op_t;

typedef enum logic [2:0] {
    RLC  = 3'h0,
    RRC  = 3'h1,
    RL   = 3'h2,
    RR   = 3'h3,
    SLA  = 3'h4,
    SRA  = 3'h5,
    SWAP = 3'h6,
    SRL  = 3'h7
} cb_alu_op_t;

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
    gp_r8_sel_t rd;
    gp_r8_sel_t rs;
} instr_body_b1_ld_r8_r8_t;

typedef struct packed {
    b2_3_alu_op_t alu_op;
    gp_r8_sel_t r8;
} instr_body_b2_alu_op_t;

typedef struct packed {
    b2_3_alu_op_t  alu_op;
    logic [2:0]    const110;
} instr_body_b3_alu_op_t;

typedef struct packed {
    logic       const0;
    j_cond_t    cond;
    logic [2:0] id2;
} instr_body_b3_cond_jp_t;

typedef struct packed {
    logic       id1;
    logic [4:3] id2;
    logic [2:0] id3;
} instr_body_b3_jp_t;

typedef struct packed {
    logic [5:3] target;
    logic [2:0] const111;
} instr_body_b3_rst_t;

typedef struct packed {
    stk_r16_sel_t r16stk;
    logic [3:0]   id;
} instr_body_b3_stack_op_t;

typedef union packed {
    instr_body_b3_alu_op_t    alu;
    instr_body_b3_cond_jp_t   jp_cond;
    instr_body_b3_jp_t        jp;
    instr_body_b3_rst_t       rst;
    instr_body_b3_stack_op_t  stack_op;
    //instr_body_b3_ld_t        ld; // doing explicit compares for now
    //instr_body_b3_sp_t        sp_op;
} instr_body_b3_t;

typedef struct packed {
    cb_alu_op_t alu_op;
    gp_r8_sel_t r8;
} instr_body_cb_alu_op_t;

typedef struct packed {
    cb_alu_op_t bit_idx;
    gp_r8_sel_t r8;
} instr_body_cb_bit_op_t;

typedef union packed {
    instr_body_cb_alu_op_t alu;
    instr_body_cb_bit_op_t bitop;
} instr_body_cb_t;

typedef union packed {
    logic [5:0]              raw;
    instr_body_b0_t          b0;
    instr_body_b1_ld_r8_r8_t b1;
    instr_body_b2_alu_op_t   b2;
    instr_body_b3_t          b3;
    instr_body_cb_t          cb;
} instr_body_t;

typedef struct packed {
    instr_block_t block;
    instr_body_t  body;
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