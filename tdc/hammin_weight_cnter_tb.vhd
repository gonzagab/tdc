--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:42:16 06/15/2017
-- Design Name:   
-- Module Name:   C:/Users/gonza/Documents/Summer 2016 Research/tdc/tdc/hammin_weight_cnter_tb.vhd
-- Project Name:  tdc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hammin_weight_cnter
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library WORK;
use WORK.ALL;  

entity hammin_weight_cnter_tb is
end hammin_weight_cnter_tb;
 
architecture testbench of hammin_weight_cnter_tb is 
--Input Signals--
signal input : std_logic_vector (319 downto 0);
signal clk 	: std_logic := '0';
--Output Signals--
signal output : std_logic_vector (8 downto 0);
--Boolean Signal--
signal sim_end : boolean := false;
--Clock Period--
constant period 	: time := 14 ns;
begin
    --Unit Under Test--
    uut: entity work.hammin_weight_cnter
    port map (
            --Inputs--
--        clk => clk,
        input => input,
            --Outputs--
        output => output
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

    --Stimulus Process--
    stim_proc: process
    constant maxNum : integer := 2**20 - 1;
    begin
        input <= (319 downto 0 => '1'); -- 0
        wait for 500 ns;
        input <=(250 downto 0 => '1', others => '0'); -- 69
        wait for 500 ns;
        input <=(200 downto 0 => '1', others => '0'); -- 119
        wait for 500 ns;
        input <=(150 downto 0 => '1', others => '0'); -- 169
        wait for 500 ns;
        input <=(100 downto 0 => '1', others => '0'); -- 219
        wait for 500 ns;
        input <=(50 downto 0 => '1', others => '0');
        wait for 500 ns;
        input <=(others => '0');
        wait for 500 ns;
        wait;
    end process;
end;
