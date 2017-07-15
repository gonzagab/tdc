----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:36:05 07/05/2017 
-- Design Name: 
-- Module Name:    freq_div - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library WORK;
use WORK.ALL;

entity freq_div is
	port( 
		 --Inputs--
 		 divisor : in STD_LOGIC_VECTOR(3 downto 0);	--Divider for clock
		 rst_bar : in STD_LOGIC;				   	--Reset	(active low)
		 clk : in STD_LOGIC;						--Clock
   	 	 --Outputs--
		 clk_dvd : inout STD_LOGIC					--Divided Clock
	     );
end freq_div;

architecture behavioral of freq_div is
begin	 
	freq_div: process(clk)
	variable count : unsigned(3 downto 0);
	begin
		if(rising_edge(clk))then 
			if(rst_bar = '1')then
				if(clk_dvd = '0')then
					if(std_logic_vector(count) = divisor)then
						clk_dvd <= '1';
						count := "0000";
					end if;
				else
					clk_dvd <= '0';
				end if;
				count := count + 1;
			else
				count := "0000";
				clk_dvd <= '0';
			end if;
		end if;
	end process;
end behavioral;
