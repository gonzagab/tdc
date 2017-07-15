--------------------------------------------------------------------------------
-- Engineers:       Bryant Gonzaga and Victor Tellez
-- 
-- Create Date:     15:05:46 05/30/2017
-- Module Name:     tdc_tb - Test Bench 
-- Project Name:    tdc - Time to Digital Converter
-- Target Devices:  Virtex 5 - XC5VLX30
--
-- Description:
--  Test Bench used to test the TDC.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Work Library--
library WORK;
use WORK.ALL;
-- for File IO --
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
 
entity tdc_tb is
    generic (output_length: integer := 24);
end tdc_tb;
 
architecture testbench of tdc_tb is 
--Input Signals--
signal start : std_logic;
signal stop  : std_logic;
signal clk   : std_logic;

--Output Signals--
signal pulse_width: std_logic_vector(output_length - 1 downto 0);

--Pulse Width--
constant stop_delay : time := 25 ns; --pulse width

--Boolean Signal--
signal sim_end  : boolean := false;
signal new_data : boolean := false;
signal strt_end : boolean := false;
signal stp_end  : boolean := false;

--Clock Period--
constant period     : time := 7 ns;
constant increment  : time := 1 ps;

--File Declaration--
file tdc25nsPulse_rslt_txt : text;
begin
    --Unit Under Test--
    uut: entity work.tdc
    port map (
            --Inputs--
        start   => start,
        stop    => stop,
        clk     => clk,
            --Outputs--
        pulse_width => pulse_width
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
   
   start_process: process
   begin
		start <= '0';
		wait for 121.7 ns;
		loop
            start <= not start;
            wait for period*8;
			start <= not start;
			wait for increment + period*8;
			exit when strt_end = true;
		end loop;
		wait;
   end process;
   
   stop_process: process
   begin
		stop <= '0';
		wait for 121.7 ns;
		wait for stop_delay;
		loop
            stop <= not stop;
            wait for period*8;
			stop <= not stop;
			wait for increment + period*8;
			exit when stp_end = true;
		end loop;
		wait;
    end process;

    --Stimulus Process--
    stim_proc: process
    begin
        -- open file --
        file_open(tdc25nsPulse_rslt_txt, "tdc25nsPulseRe_rslt_txt.txt", write_mode);
        
        --Simulation Length--
        wait for 784.5 us;
        strt_end <= true;
        stp_end <= true;
        
        --Close Files--
        file_close(tdc25nsPulse_rslt_txt);
        --End Simulation--
        sim_end <= true;
        wait;
    end process;
    
    --File Save Process--
	sav_proc: process
	variable out_line : line;
	begin
		wait for 227.55 ns;
		loop
			new_data <= true;

            --Save TDC Final Result--
			write(out_line, pulse_width, right, output_length);
			writeline(tdc25nsPulse_rslt_txt, out_line);

			wait for 4 ns;
			new_data <= false;
			wait for 108.001 ns;
			exit when sim_end = true;
		end loop;
	end process;

end;