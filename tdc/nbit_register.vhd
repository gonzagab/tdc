----------------------------------------------------------------------------------
-- Engineers:       Bryant Gonzaga and Victor Tellez
-- 
-- Create Date:     00:32:36 02/19/2017 
-- Module Name:     nbit_register - Behavioral 
-- Project Name:    tdc - Time to Digital Converter
-- Target Devices:  Virtex 5 - XC5VLX30
--
-- Description:
--  An n-bit register.
--
-- Generics:
--  n - The nuber of bits the register can save.
--
-- Inputs:
--  clk - System clock.
--  d   - Data to be saved.
--
-- Outputs:
--  q - Saved data.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Work Library--
library WORK;
use work.all;

entity nbit_register is
	generic (n : integer := 16);
	port (
            --INPUT--
        clk : in std_logic; --system clock
        d   : in std_logic_vector(n-1 downto 0); --data to be saved
            --OUTPUT--
        q   : out std_logic_vector(n-1 downto 0) --saved data
	);
end nbit_register;

architecture behavioral of nbit_register is
attribute ASYNC_REG : string;
attribute ASYNC_REG of dff: label is "TRUE";
begin
	dff: process(clk)
	begin
		if (rising_edge(clk)) then
			q <= d;
		end if;
	end process;
end behavioral;

