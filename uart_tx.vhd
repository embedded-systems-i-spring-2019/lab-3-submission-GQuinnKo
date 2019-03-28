
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
port (
    clk , en , send , rst : in std_logic;
    char : in std_logic_vector (7 downto 0);
    ready , tx : out std_logic  );
end uart_tx ;

architecture Behavioral of uart_tx is

    -- state type enumeration and state variable
    type state is (idle, start, data);
    signal curr : state := idle;
    
    signal temp : std_logic_vector (7 downto 0);
    signal counter : std_logic_vector (3 downto 0);
begin
    process(clk) begin
        if rising_edge(clk) then
            if(rst = '1') then
                temp <= (others => '0');
                counter <= (others => '0');
                curr <= idle;
                tx <= '1';
                ready <= '1';
            end if;
            
            
            
            if(en = '1') then
                case curr is
                    
                    when idle =>
                    if(send = '1') then
                        temp <= char;
                        curr <= start;
                        ready <= '0';
                    else
                        tx <= '1';
                        ready <= '1'; 
                    end if;
                    
                    when start =>
                    tx <= '0';
                    counter <= "0000";
                    curr <= data;
                    
                    when data =>
                    if(unsigned(counter) < 8) then
                        tx <= temp(to_integer(unsigned(counter)));
                        counter <= std_logic_vector(unsigned(counter) + 1);
                    
                    else
                        tx <= '1';
                        ready <= '1';
                        curr <= idle;   
                    end if;

                    
                 end case;
                
            end if;
        end if;
    
    end process;

end Behavioral;
