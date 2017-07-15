----------------------------------------------------------------------------------
-- Engineers:       Bryant Gonzaga and Victor Tellez
-- 
-- Create Date:     00:34:05 05/19/2017 
-- Module Name:     binary_counter - Structural 
-- Project Name:    tdc - Time to Digital Converter
-- Target Devices:  Virtex 5 - XC5VLX30
--
-- Description:
--  A binary counter that counts up on every rising edge of a clock. It has a
-- aynchronous count enable signal and an synchronous active low reset signal.
-- When the max count is reached the max_cnt signal goes high for one clock 
-- period.
--
-- Generics:
--  n - The output lenngth.
--
-- Inputs:
--  clk     - System clock.
--  cnt_en  - Synchronous count enable. Must be high for counter to count.
--  rst_bar - Synchronous active low reset. When low the counter outputs zero.
--              rst_bar takes priority over cnt_en.
--
-- Outputs:
--  cnt     - The current count.
--  max_cnt - Signal indicating the counter has reached its max count.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--Work Library--
library WORK;
use WORK.ALL;

entity binary_counter is
	generic(n : integer := 4);
	port(
            --INPUTS--
		clk     : in std_logic;
		cnt_en  : in std_logic;	--synchronous count enable
		rst_bar : in std_logic;	--synchronous reset (active low)
            --OUTPUTS--
		cnt     : out std_logic_vector(n - 1 downto 0); --holds count
		max_cnt : out std_logic --high when count has reached max count
	    );
end binary_counter;

architecture behavioral of binary_counter is
begin
    process(clk)
    variable count : unsigned (n - 1 downto 0);
    begin		
        if(rising_edge(clk))then
            if(rst_bar = '0')then
                max_cnt <= '0';
                count := to_unsigned(0,n);
            elsif(cnt_en = '1')then
                count := count + 1;
                max_cnt <= '0';
                if(count+1 = 0)then
                    max_cnt <= '1';
                end if;
            end if;
        end if;	
        cnt <= std_logic_vector(count);
    end process;
end behavioral;