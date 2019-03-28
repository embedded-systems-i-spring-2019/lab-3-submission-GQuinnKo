

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_level is
  Port (txd, clk : in std_logic;
        btn : in std_logic_vector(1 downto 0);
        rxd : out std_logic;
        cts : out std_logic := '0';
        rts : out std_logic := '0' );
end top_level;

architecture Behavioral of top_level is

component debouncer is
 Port ( clkd, bt : in std_logic;
        debounce: out std_logic);
end component;

component divider is
  Port ( clk : in std_logic;
         Q : out std_logic);
end component;

component sender is
  Port ( rst, clk, en, btn, ready : in std_logic;
       send : out std_logic;
       char : out std_logic_vector(7 downto 0));
end component;

component uart is
port (
    clk , en , send , rx , rst : in std_logic ;
    charSend : in std_logic_vector (7 downto 0) ;
    ready , tx , newChar : out std_logic ;
    charRec : out std_logic_vector (7 downto 0)
) ;
end component;

signal dbnc : std_logic_vector(1 downto 0);
signal c : std_logic_vector(7 downto 0);
signal s, r, div : std_logic;

begin

u1: debouncer
port map ( bt => btn(0),
           clkd => clk,
           debounce => dbnc(0));

u2: debouncer
port map ( bt => btn(1),
           clkd => clk,
           debounce => dbnc(1));
           
u3: divider
port map ( Q => div,
           clk => clk );
           
u4: sender
port map ( btn => dbnc(1),
           clk => clk, 
           en => div,
           ready => r,
           rst => dbnc(0),
           send => s,
           char => c);

u5: uart
port map ( charSend => c,
           clk => clk,
           en => div,
           rst => dbnc(0),
           rx => txd,
           send => s,
           tx => rxd,
           ready => r );
end Behavioral;
