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

typedef logic [8:0] r8_t;

typedef struct {
    r8_t msb;
    r8_t lsb;
} r16_t;

typedef union {
    r16_t r16;
    r8_t [0:1] r8;
} r8_16_t;

typedef struct {
    logic ir;
    logic ie;
    logic a;
    logic f;
    logic gp8;
    logic gp16;
    logic pc;
    logic sp;
} reg_wen_vec_t;

typedef struct {
    r8_t    ir;
    r8_t    ie;
    r8_t    a;
    r8_t    f;
    r8_16_t b_c;
    r8_16_t d_e;
    r8_16_t h_l;
    r16_t   pc;
    r16_t   sp;
} reg_vec_t;

endpackage