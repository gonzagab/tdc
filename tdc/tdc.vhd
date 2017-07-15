----------------------------------------------------------------------------------
-- Engineers:       Bryant Gonzaga and Victor Tellez
-- 
-- Create Date:     04:03:01 05/21/2017 
-- Module Name:     tdc - Structural 
-- Project Name:    tdc - Time to Digital Converter
-- Target Devices:  Virtex 5 - XC5VLX30
--
-- Description:
--
-- Generics:
--
-- Inputs:
--
-- Outputs:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library WORK;
use WORK.ALL;

entity tdc is
    generic (
        output_length: integer := 24;
        cnter_length : integer := 4;
        tdl_length   : integer := 4*80;
        bit_cnt_length: integer:= 9
        );
	port (
            --INPUTS--
		start	: in std_logic;
        stop    : in std_logic;
        clk     : in std_logic;
            --OUTPUTS--
        pulse_width : out std_logic_vector(output_length - 1 downto 0)
	);
end tdc;

architecture structural of tdc is
--Conector Signals--
signal pre_tdl_out : std_logic_vector(tdl_length - 1 downto 0);
signal pst_tdl_out : std_logic_vector(tdl_length - 1 downto 0);
signal crs_cnt_out : std_logic_vector(cnter_length - 1 downto 0);

--Counter Control Signals--
signal crs_cnt_en      : std_logic;
signal crs_cnt_rst_bar : std_logic;

--Attributes--
attribute ASYNC_REG : string;
attribute ASYNC_REG of pre_tdl: label is "TRUE";
attribute ASYNC_REG of pst_tdl: label is "TRUE";
begin        
        --TDLs--
    --Pre TDL--
    pre_tdl: entity work.n4bit_carry_chain
    generic map (n => tdl_length)
    port map (
            --Input--
        clk       => clk,
        c_in      => start,
            --Output--
        carry_out => pre_tdl_out
        );
    --Post TDL--
    pst_tdl: entity work.n4bit_carry_chain
    generic map (n => tdl_length)
    port map (
            --Input--
        clk       => clk,
        c_in      => stop,
            --Output--
        carry_out => pst_tdl_out
        );
    --Binary Counter--
    crs_cnt_rst_bar <= start or stop;
    crs_cnt_en  <= '1';	
    crs_cnt: entity work.binary_counter
    generic map (n => cnter_length)
    port map (
            --Input--
        clk     => clk,
        cnt_en  => crs_cnt_en,
        rst_bar => crs_cnt_rst_bar,
            --Output--
        cnt     => crs_cnt_out
        );
    --Calculate Time--
    calc_unit: entity work.calc_unit
    generic map (
        tdl_length     => tdl_length,
        bit_cnt_length => bit_cnt_length,
        cnter_length     => cnter_length,
        output_length  => output_length
        )
    port map (
            --Inputs--
        clk      => clk,
        start    => start,
        stop     => stop,
        pre_cnt  => pre_tdl_out,
        pst_cnt  => pst_tdl_out,
        crs_cnt  => crs_cnt_out,
            --Outputs--
        pulse_width => pulse_width
);
         
end structural;