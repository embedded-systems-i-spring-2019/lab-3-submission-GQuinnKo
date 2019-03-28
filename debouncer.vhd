library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity debouncer is
 Port ( clkd, bt : in std_logic;
        debounce: out std_logic);
end debouncer;

architecture Behavioral of debouncer is

signal count : std_logic_vector (21 downto 0) := (others => '0');
signal samp : std_logic_vector (1 downto 0) := (others => '0');

begin
process(clkd) begin
  if rising_edge(clkd) then
  
    samp(1) <= samp(0);
    samp(0) <= bt;
    
    if(samp(1) = '1') then
        if(count /= "1001100010010110100000") then
            count <= std_logic_vector( unsigned(count) + 1);
        end if;
        
        if(count = "1001100010010110100000") then
            debounce <= '1';
        end if;
    else
        count <= (others => '0');
        debounce <= '0';
    end if;

 end if;

end process;

end Behavioral;