library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
use ieee.numeric_std.all;
library work;
use work.all;
use work.pkg.all;

entity processor is
    port (
        clock : in std_logic;
        reset : in std_logic;
        ok : out std_logic
    );
end processor;

architecture arch of processor is
signal PW_sig               : std_logic; 
signal IorD_sig             : std_logic_vector(1 downto 0) ;
signal MR_sig               : std_logic;
signal MW_sig               : std_logic;
signal IW_sig               : std_logic;
signal DW_sig               : std_logic;
signal Rsrc_sig             : std_logic;
signal M2R_sig              : std_logic_vector(2 downto 0) ;
signal RW_sig               : std_logic;
signal AW_sig               : std_logic;
signal BW_sig               : std_logic;
signal Asrc1_sig            : std_logic_vector(1 downto 0) ;
signal Asrc2_sig            : std_logic_vector(2 downto 0) ;
signal Fset_sig             : std_logic;
signal ReW_sig              : std_logic;

-- do we still need this ?
signal mem_enable_sig       : std_logic_vector(3 downto 0) ;

signal mul_w_sig            : std_logic;
signal shift_w_sig          : std_logic;
signal Rsrc1_sig            : std_logic;
signal L_sig                : std_logic;
signal p2m_opcode_sig       : std_logic_vector(1 downto 0) ;
signal sign_opcode_sig      : std_logic;
signal p2m_offset           : std_logic_vector(1 downto 0) ;
signal RWAD_sig             : std_logic_vector(1 downto 0) ;
signal state_sig            : state_type;

signal sh_code_sig          : std_logic;
signal sh_op_sig            : std_logic;
signal sh_amt_sig           : std_logic_vector(1 downto 0) ;
signal predicate_sig        : std_logic;

signal Flags_sig            : std_logic_vector(3 downto 0) ;
signal IR_sig               : std_logic_vector(31 downto 0) ;

-- alu opcode 4 bits
signal op_sig               : std_logic_vector(3 downto 0) ;

signal instruction_type_sig : std_logic_vector(1 downto 0) ;
signal DP_subtype_sig       : DP_type;
signal DT_subtype_sig       : DT_type;
signal op_sig_decoder       : opcode;
signal undef_sig            : std_logic;
signal not_implemented_sig  : std_logic;


begin
    -- controller has 30 signals while datapath has 29 
    CONTROLLER:
    entity work.controller (arch)
    port map (
        PW          => PW_sig,
        IorD        => IorD_sig,
        MR          => MR_sig,
        MW          => MW_sig,
        IW          => IW_sig,
        DW          => DW_sig,
        Rsrc        => Rsrc_sig,
        M2R         => M2R_sig,
        RW          => RW_sig,
        AW          => AW_sig,
        BW          => BW_sig,
        Asrc1       => Asrc1_sig,
        Asrc2       => Asrc2_sig,
        Fset        => Fset_sig,
        ReW         => ReW_sig,
        mem_enable  => mem_enable_sig,
        mul_w       => mul_w_sig,
        shift_w     => shift_w_sig,
        Rsrc1       => Rsrc1_sig,
        L           => L_sig,
        p2m_opcode  => p2m_opcode_sig,
        sign_opcode => sign_opcode_sig,
        p2m_offset  => p2m_offset,
        RWAD        => RWAD_sig,
        state       => state_sig,
        reset       => reset,
        sh_code     => sh_code_sig,
        sh_op       => sh_op_sig,
        sh_amt      => sh_amt_sig,
        predicate   => predicate_sig
    );


    DATAPATH:
    entity work.data_path(arch)
    port map(
        PW          => PW_sig,
        IorD        => IorD_sig,
        MR          => MR_sig,
        IW          => IW_sig,
        DW          => DW_sig,
        Rsrc        => Rsrc_sig,
        M2R         => M2R_sig,
        RW          => RW_sig,
        AW          => AW_sig,
        BW          => BW_sig,
        Asrc1       => Asrc1_sig,
        Asrc2       => Asrc2_sig,
        Fset        => Fset_sig,
        ReW         => ReW_sig,
        clk         => clock,
        mul_w       => mul_w_sig,
        shift_w     => shift_w_sig,
        sh_op       => sh_op_sig,
        sh_code     => sh_code_sig,
        sh_amt      => sh_amt_sig,
        Rsrc1       => Rsrc1_sig,
        L           => L_sig,
        p2m_opcode  => p2m_opcode_sig,
        sign_opcode => sign_opcode_sig,
        p2m_offset  => p2m_opcode_sig,
        RWAD        => RWAD_sig,
        Flags       => Flags_sig,
        IR          => IR_sig,
        op          => op_sig -- this would come from ACtrl
        );

    ACTRL:
    entity work.Actrl(arch) 
    port map (
        IR          => IR_sig,
        op          => op_sig
    ) ;
    
    BCTRL:
    entity work.Bctrl(arch) 
    port map (
        IR          => IR_sig,
        nzvc        => Flags_sig,
        p           => predicate_sig
    ) ;

    FSM:
    entity work.controller_states(arch)
    port map (
        instruction_type => instruction_type_sig,
        DP_subtype       => DP_subtype_sig,
        DT_subtype       => DT_subtype_sig,
        reset            => reset,
        instruction      => IR_sig,
        clock            => clock,
        state_out        => state_sig
    );

    DECODER:
    entity work.decoder(arch) 
    port map (
        instruction      => IR_sig,
        instruction_type => instruction_type_sig,
        DP_subtype       => DP_subtype_sig,
        DT_subtype       => DT_subtype_sig,
        op               => op_sig_decoder, -- redundant as alu ctrl does the same
        undef            => undef_sig,
        not_implemented  => not_implemented_sig
    );

end arch;

--entity controller is
--  port (
--    PW          : out std_logic;
--    IorD        : out std_logic_vector(1 downto 0);
--    MR          : out std_logic;
--    MW          : out std_logic;
--    IW          : out std_logic;
--    DW          : out std_logic;
--    Rsrc        : out std_logic;
--    M2R         : out std_logic_vector(1 downto 0); --changed
--    RW          : out std_logic;
--    AW          : out std_logic;
--    BW          : out std_logic;
--    Asrc1       : out std_logic_vector(1 downto 0); --changed
--    Asrc2       : out std_logic_vector(1 downto 0);
--    Fset        : out std_logic;
--    ReW         : out std_logic;
--    mem_enable  : out std_logic_vector(3 downto 0) ;
--    mul_w       : out std_logic;
--    shift_w     : out std_logic;
--    Rsrc1       : out std_logic;
--    L           : out std_logic;
--    p2m_opcode  : out std_logic_vector(1 downto 0);
--    sign_opcode : out std_logic;
--    p2m_offset  : out std_logic_vector(1 downto 0);
--    RWAD        : out std_logic_vector(1 downto 0);
--    state       : in state_type;
--    reset       : in std_logic;
--    sh_code     : out std_logic;
--    sh_op       : out std_logic;
--    sh_amt      : out std_logic_vector(1 downto 0);
--    predicate   : in std_logic
--  ) ;
--end controller ;


--entity data_path is
--  port (
--    PW          : in std_logic;
--    IorD        : in std_logic_vector(1 downto 0);
--    MR          : in std_logic;
--    IW          : in std_logic;
--    DW          : in std_logic;
--    Rsrc        : in std_logic;
--    M2R         : in std_logic_vector(2 downto 0);  --changed
--    RW          : in std_logic;
--    AW          : in std_logic;
--    BW          : in std_logic;
--    Asrc1       : in std_logic_vector(1 downto 0);  --changed
--    Asrc2       : in std_logic_vector(2 downto 0);
--    op          : in std_logic_vector(3 downto 0);
--    Fset        : in std_logic;
--    ReW         : in std_logic;
--    clk         : in std_logic;
--    mul_w       : in std_logic;
--    shift_w     : in std_logic;
--    sh_op       : in std_logic;
--    sh_code     : in std_logic;
--    sh_amt      : in std_logic_vector(1 downto 0);
--    Rsrc1       : in std_logic;
--    L           : in std_logic;
--    p2m_opcode  : in std_logic_vector(1 downto 0);
--    sign_opcode : in std_logic;
--    p2m_offset  : in std_logic_vector(1 downto 0);
--    RWAD        : in std_logic_vector(1 downto 0);
--    Flags       : out std_logic_vector(3 downto 0);
--    IR          : out std_logic_vector(31 downto 0)
--  ) ;
--end entity ;

--entity Actrl is
--  port (
--    IR   : in std_logic_vector(31 downto 0);
--    op   : out std_logic_vector(3 downto 0)
--  ) ;
--end Actrl ;

--entity Bctrl is
--  port (
--    IR   : in std_logic_vector(31 downto 0);
--    nzvc : in std_logic_vector(3 downto 0); --flags
--    p    : out std_logic
--  ) ;
--end Bctrl ;


--entity controller_states is
--  port (
--    instruction_type : in std_logic_vector(1 downto 0);
--    DP_subtype       : in DP_type;
--    DT_subtype       : in DT_type;
--    reset            : in std_logic;
--    instruction      : in std_logic_vector(31 downto 0) ;
--    clock            : in std_logic;
--    state_out        : out state_type
--  ) ;
--end controller_states ;

--entity decoder is
--  port (
--    instruction      : in std_logic_vector(31 downto 0) ;
--    instruction_type : out std_logic_vector(1 downto 0);
--    DP_subtype       : out DP_type;
--    DT_subtype       : out DT_type;
--    op               : out opcode;
--    undef            : out std_logic;
--    not_implemented  : out std_logic
--  ) ;
--end decoder ;