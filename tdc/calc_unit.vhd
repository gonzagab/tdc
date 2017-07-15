----------------------------------------------------------------------------------
-- Engineers:       Bryant Gonzaga and Victor Tellez
-- 
-- Create Date:     13:18:12 05/29/2017 
-- Module Name:     calc_unit - Structural 
-- Project Name:    tdc - Time to Digital Converter
-- Target Devices:  Virtex 5 - XC5VLX30
--
-- Description:
--
--
-- Generics:
--  tdl_length     -
--  cnter_length   -
--  bit_cnt_length -
--  output_length  -
--
-- Inputs:
--  clk     
--  start   
--  stop    
--  pre_cnt 
--  pst_cnt 
--  crs_cnt 
--
-- Outputs:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Work Library--
library WORK;
use WORK.ALL;

entity calc_unit is
	generic (
        tdl_length     : integer := 4*80;
        cnter_length   : integer := 4;
        bit_cnt_length : integer := 9;
        output_length  : integer := 24
        );
	port (
			--INPUTS--
        clk     : in std_logic;
        start   : in std_logic;
        stop    : in std_logic;
		pre_cnt : in std_logic_vector(tdl_length - 1 downto 0);
		pst_cnt : in std_logic_vector(tdl_length - 1 downto 0);
		crs_cnt : in std_logic_vector(cnter_length - 1 downto 0);
			--OUTPUTS--
        pulse_width: out std_logic_vector(output_length - 1 downto 0)
	);
end calc_unit;

architecture structural of calc_unit is
--Register Triggers--
signal pre_trig 	: std_logic := '0';
signal pst_trig     : std_logic := '0';
signal output_trig  : std_logic := '0';

--Register Output--
signal pre_reg_cnt : std_logic_vector (tdl_length - 1 downto 0);
signal pst_reg_cnt : std_logic_vector (tdl_length - 1 downto 0);
signal crs_reg_cnt : std_logic_vector (cnter_length - 1 downto 0);

--Bit Count--
signal pre_bit_cnt : std_logic_vector (bit_cnt_length - 1 downto 0);
signal pst_bit_cnt : std_logic_vector (bit_cnt_length - 1 downto 0);

--Calc Proccess Output--
signal calc_proc_out : std_logic_vector (output_length - 1 downto 0);
--Zero Constant--
signal zero   : std_logic_vector (cnter_length - 1 downto 0) := (others => '0');

--Attributes--
attribute ASYNC_REG : string;
attribute ASYNC_REG of pre_reg: label is "TRUE";
attribute ASYNC_REG of pst_reg: label is "TRUE";
attribute ASYNC_REG of crs_reg: label is "TRUE";
attribute ASYNC_REG of pretrig_proc: label is "TRUE";
attribute ASYNC_REG of psttrig_proc: label is "TRUE";
begin
		--TRIGGER PROCESSES--
    --Pre TDL Reg Trig--
    pretrig_proc: process(clk, start)
    begin
        if (rising_edge(clk)) then
            pre_trig <= start;
        end if;
    end process;
    --Pst TDL Reg Trig--
    psttrig_proc: process(clk, stop)
    begin
        if (rising_edge(clk)) then
            pst_trig <= stop;
        end if;
    end process;
    --Output Reg Trig--
    out_reg_trig: entity work.binary_counter
        generic map (n => 3)
        port map (
            --Input--
        clk     => clk,
        cnt_en  => stop,
        rst_bar => stop,
            --Output--
        max_cnt     => output_trig
		);
        --REGISTER INSTANCES--
    --Pre TDL Reg--
    pre_reg: entity work.nbit_register
        generic map (n => tdl_length)
        port map (
                --Input--
            clk => pre_trig,
            d   => pre_cnt,
                --Output--
            q   => pre_reg_cnt
        );
	--Pst TDL Reg--
    pst_reg: entity work.nbit_register
        generic map (n => tdl_length)
        port map (
                --Input--
            clk => pst_trig,
            d   => pst_cnt,
                --Output--
            q   => pst_reg_cnt
        );
    --Crs Cnt Reg--
    crs_reg: entity work.nbit_register
        generic map (n => cnter_length)
        port map (
                --Input--
            clk => pst_trig,
            d   => crs_cnt,
                --Output--
            q   => crs_reg_cnt
        );
    --Output Reg--
    output_reg: entity work.nbit_register
        generic map (n => output_length)
        port map (
                --Inputs--
            clk => output_trig,
            d   => calc_proc_out,
                --Output--
            q   => pulse_width
        );
        --TDL BIT COUNTERS--
	--Pre TDL Bit Coutner--
    pre_tdl_bit_cnt: entity work.hammin_weight_cnter
        generic map (
            input_length => tdl_length,
            output_length => bit_cnt_length
        )
        port map (
            input  => pre_reg_cnt,
            output => pre_bit_cnt
        );
    --Pst TDL Bit Coutner--
    pst_tdl_bit_cnt: entity work.hammin_weight_cnter
        generic map (
            input_length => tdl_length,
            output_length => bit_cnt_length
        )
        port map (
            input  => pst_reg_cnt,
            output => pst_bit_cnt
        );
        --Calculation Process--
    calc_proc: process (pre_bit_cnt, pst_bit_cnt, crs_reg_cnt, crs_cnt, pre_trig)
    constant C      : integer := 2312;   --constant
    constant period : integer := 700000; --period in ps * 100
    variable L_pre  : integer;           --time signal came in
    variable L_pst  : integer;           --time signal came in
	 variable cnt_offset: integer := 0;
    begin
        L_pre := C*(320 - to_integer(unsigned(pre_bit_cnt)));
        L_pst := C*(320 - to_integer(unsigned(pst_bit_cnt)));
        if (rising_edge(pre_trig)) then
            if (crs_cnt = zero) then
                cnt_offset := 0;
            else
                cnt_offset := 1;
            end if;
        end if;
        
        calc_proc_out <= std_logic_vector(to_unsigned(
            (L_pre + (to_integer(unsigned(crs_reg_cnt)) - cnt_offset)*period - L_pst - 30000)
                , output_length));		
    end process;	 
end structural;