--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:08:53 06/15/2017
-- Design Name:   
-- Module Name:   C:/Users/gonza/Documents/Summer 2016 Research/tdc/tdc/calc_unit_tb.vhd
-- Project Name:  tdc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: calc_unit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity calc_unit_tb is
end calc_unit_tb;
 
architecture behavior of calc_unit_tb is 
--Inputs--
signal clk      : std_logic;
signal start    : std_logic;
signal stop     : std_logic;
signal pre_cnt  : std_logic_vector(319 downto 0);
signal pst_cnt  : std_logic_vector(319 downto 0);
signal crs_cnt  : std_logic_vector(3 downto 0);
--Outputs--
signal final_cnt_l : std_logic_vector(8 downto 0);
signal final_cnt_h : std_logic_vector(8 downto 0);
signal crs_cnt_out : std_logic_vector(3 downto 0);
signal valid : std_logic;
--Clock Period--
constant period : time := 10 ns;
begin
    --Unit Under Test--
    uut: entity work.calc_unit 
        port map (
                --Inputs--
            clk     => clk,
            start   => start,
            stop    => stop,
            pre_cnt => pre_cnt,
            pst_cnt => pst_cnt,
            crs_cnt => crs_cnt,
                --Outputs--
            final_cnt_l => final_cnt_l,
            final_cnt_h => final_cnt_h,
            crs_cnt_out => crs_cnt_out,
            valid => valid
        );
	--Clock process--
   clk_process: process
   begin
		clk <= '0';
		wait for period/2;
		loop
			clk <= not clk;
			wait for period/2;
			exit when sim_end = true;
		end loop;
		wait;
   end process;

end;
