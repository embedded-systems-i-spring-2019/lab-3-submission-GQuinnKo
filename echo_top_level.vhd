

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



component divider is
port (
  clk_in : in std_logic;
  div : out std_logic
);
end component;

component echo is
  Port (clk, en, ready, newChar : in std_logic;
        charIn : in std_logic_vector(7 downto 0);
        send : out std_logic;
        charOut : out std_logic_vector(7 downto 0) );
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
signal c1, c2 : std_logic_vector(7 downto 0);
signal s, r, nc, div : std_logic;

begin

           
u3: divider
port map ( div => div,
           clk_in => clk );
           
u4: echo
port map ( newChar => nc,
           clk => clk, 
           en => div,
           ready => r,
           charIn => c2,
           send => s,
           charOut => c1);

u5: uart
port map ( charSend => c1,
           clk => clk,
           en => div,
           rst => dbnc(0),
           rx => txd,
           send => s,
           tx => rxd,
           ready => r,
           newChar => nc,
           charRec => c2 );
end Behavioral;
