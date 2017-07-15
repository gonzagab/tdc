--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:09:25 02/19/2017
-- Design Name:   
-- Module Name:   C:/Users/Bryant Gonzaga/Documents/Summer 2016 Research/Time To Digital Converter/AdderDelayLine/n4bit_carry_chain_tb.vhd
-- Project Name:  AdderDelayLine
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: n4bit_carry_chain
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
use WORK.ALL;
-- for File IO --
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity n4bit_carry_chain_tb is
	generic (n : integer := 4*80);
end n4bit_carry_chain_tb;
 
architecture testbench of n4bit_carry_chain_tb is 
--Stimulus Signals--
signal clk 	: std_logic := '0';
signal c_in : std_logic := '0';
--Observed Signal
signal carry_out : std_logic_vector(n - 1 downto 0);
--Clock Period--
constant period 	: time := 7 ns;
constant increment  : time := 1 ps;
--Boolean Signals--
signal sim_end : boolean := false;
signal new_data: boolean := false;
--File Declaration--
file result_text: text;
begin
	--Unit Under Test (UUT)
	uut: entity work.n4bit_carry_chain 
	port map(clk => clk, c_in => c_in, carry_out => carry_out);
	
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
	begin
		-- open file --
		file_open(result_text, "n4bit_carry_chain_sim_results.txt", write_mode);

		-- reset all carry4 primitives --
		c_in <= '0';
		wait for period*9.5;
		
		--C_in Pulse Gen--
		for i in 1 to 8000 loop
			c_in <= '1';
			wait for period*2;
			c_in <= '0';
			wait for increment + period*9;
		end loop;

		-- end simulation --
		sim_end <= true;
		-- close file --
		file_close(result_text);
		wait;
	end process;
	
	--File Save Process--
	sav_proc: process
	variable out_line : line;
	begin
		wait for 85.5 ns;

		loop
			new_data <= true;
			write(out_line, carry_out, right, n - 1);
			writeline(result_text, out_line);
			wait for 5 ns;
			new_data <= false;
			wait for 72 ns;
			exit when sim_end = true;
		end loop;
	end process;
end;
