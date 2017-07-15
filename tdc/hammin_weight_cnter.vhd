----------------------------------------------------------------------------------
-- Engineers:       Bryant Gonzaga and Victor Tellez
-- 
-- Create Date:     09:21:13 06/15/2017 
-- Module Name:     hammin_weight_cnter - Behavioral 
-- Project Name:    tdc - Time to Digital Converter
-- Target Devices:  Virtex 5 - XC5VLX30
--
-- Description:
--  Not exactly a hamming weight counter. This module checks in descending order
-- from most significant bit to least significant bit increasing the count each
-- subsequent check until it finds a bit that is high. It checks how many low
-- are in sequence from the most significant to the least significant.
--
-- Generics:
--  input_length  - Lenght of input vector.
--  output_length - Lenght of output vector. = ceiling of log_2(input_length).
--
-- Input:
--  input - Input vector.
--
-- Output:
--  output - Output vector.
------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Work Library--
library WORK;
use WORK.ALL;

entity hammin_weight_cnter is
    generic (
        input_length  : integer := 320;
        output_length : integer := 9
    );
    port (
            --INPUTS--
        input: in std_logic_vector(input_length - 1 downto 0);
            --OUTPUTS--
        output: out std_logic_vector(output_length - 1 downto 0)
    );
end hammin_weight_cnter;

architecture behavioral of hammin_weight_cnter is
begin
    calc_proc: process (input)
    variable count : unsigned (output_length - 1 downto 0);
    begin
        count := to_unsigned(0, output_length);
        for i in input_length - 1 downto 0 loop
            exit when input(i) = '1';
            count := count + 1;
        end loop;
        output <= std_logic_vector(count);
    end process;
end behavioral;