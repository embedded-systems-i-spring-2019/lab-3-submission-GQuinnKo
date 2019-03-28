
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity sender is
  Port ( rst, clk, en, btn, ready : in std_logic;
         send : out std_logic;
         char : out std_logic_vector(7 downto 0));
end sender;

architecture Behavioral of sender is
type my_array is array (0 to 3) of std_logic_vector(7 downto 0);
type state is (idle, busyA, busyB, busyC);

signal NETID : my_array;
signal curr : state := idle;
signal i : std_logic_vector(3 downto 0) := (others => '0');



begin
NETID(3) <= x"67";
NETID(2) <= x"71";
NETID(1) <= x"6D";
NETID(0) <= x"34";


process(clk) begin
if rising_edge(clk) and en = '1' then

if(rst = '1') then
    send <= '0';
    char <= (others => '0');
    i <= (others => '0');
    curr <= idle;

else
case curr is
    when idle =>
    if(ready = '1' and btn = '1') then
        if (unsigned(i) < 4) then
            send <= '1';
            char <= NETID(to_integer(unsigned(i)));
            i <= std_logic_vector( unsigned(i) + 1 );
            curr <= busyA;         
        else
            i <= (others => '0');
        end if;
    end if;
    
    when busyA =>
    curr <= busyB;
    
    when busyB =>
    send <= '0';
    curr <= busyC;
    
    when busyC =>
    if(ready = '1' and btn = '0') then
        curr <= idle;
    else
        curr <= busyC;
    end if;

end case;
end if;
end if;
end process;



end Behavioral;
