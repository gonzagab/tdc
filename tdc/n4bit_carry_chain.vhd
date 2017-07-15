----------------------------------------------------------------------------------
-- Engineers:       Bryant Gonzaga and Victor Tellez
-- 
-- Create Date:     00:32:36 02/19/2017 
-- Module Name:     n4bit_carry_chain - Structural 
-- Project Name:    tdc - Time to Digital Converter
-- Target Devices:  Virtex 5 - XC5VLX30
--
-- Description:
--  Cascaded CARRY4 primitives to form a Tapped Dalay Line. The outputs of the
-- CARRY4 primitives are the inputs of a register. On every clock cycle the
-- registers save the CARRY4 output.
--
-- Generics:
--  n - TDL length. n/4 = number of CARRY4 primitives.
--
-- Inputs:
--  clk  - System Clock.
--  c_in - Input signal to be cascaded through the CARRY4 primitives.
--
-- Outputs:
--  carry_out - Register output.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Xilinx Primitives--
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
--Work Library--
library WORK;
use WORK.ALL;

entity n4bit_carry_chain is
    generic (n : integer := 4*80);	--n must be a multiple of 4
    port (
            --INPUT--
        clk	: in std_logic;	    --System clock
        c_in: in std_logic;	    --carry input
            --OUTPUT--
		carry_out : out std_logic_vector(n-1 downto 0)--carry out from the carry4 blocks
	);
end n4bit_carry_chain;

architecture structural of n4bit_carry_chain is
--Signal Carriers--
signal data_chain : std_logic_vector(n-1 downto 0);
signal carry_chain: std_logic_vector(n-1 downto 0);

--Constants--
signal a:  std_logic_vector(n-1 downto 0) := (others => '0'); --dont care
signal sel:  std_logic_vector(n-1 downto 0) := (others => '1'); --has to be '1' always
--since sel is the select of the muxes and 1 will allow the carry to propogate

--Attributes--
attribute ASYNC_REG : string;
attribute ASYNC_REG of register_gen: label is "TRUE";
begin
	-- CARRY4: Fast Carry Logic Component
	-- Virtex-5
	-- bits arive in the order 3, 1, 0, 2
	CARRY4_inst : CARRY4
	port map (
		--INPUTS--
	--CI => c_in,           -- 1-bit carry cascade input; must come from another carry chain
	CYINIT => c_in,         -- 1-bit carry initialization
	DI  => a(3 downto 0),   -- 4-bit carry-MUX data in
	S 	=> sel(3 downto 0), -- 4-bit carry-MUX select input
		--OUTPUTS--
	CO  => carry_chain(3 downto 0),
	O	=> data_chain(3 downto 0)
	);
	-- End of CARRY4_inst instantiation
	
	tdl_gen:
	for i in 1 to n/4 -1 generate
		carry_x: 
		CARRY4 port map (
				--INPUTS--
			CI => carry_chain	((i*4)-1),
			DI => a				(3+(i*4) downto 0+(i*4)),
			S 	=> sel			(3+(i*4) downto 0+(i*4)),
				--OUTPUTS--
			CO => carry_chain	(3+(i*4) downto 0+(i*4)),
			O 	=> data_chain 	(3+(i*4) downto 0+(i*4))
			);
	end generate;
	
	register_gen: 
	for i in 0 to (n/4 - 1) generate
		dff: entity work.nbit_register 
		generic map (n => 4)
		port map (
			clk  => clk, 
			d 	 => carry_chain(3+(i*4) downto 0+(i*4)),
			q(0) => carry_out  (3+(i*4)),
            q(1) => carry_out  (1+(i*4)),
            q(2) => carry_out  (0+(i*4)),
            q(3) => carry_out  (2+(i*4))
			);	
	end generate register_gen;	
end structural;

