
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity  global_reg is
    port (
        -- Inputs
        CLR:    in std_logic;
        EN:     in std_logic;
        C:      in std_logic;
        Y:      in std_logic_vector(2 downto 0);
        X:      in std_logic_vector(3 downto 0);
        Z:      in std_logic_vector(3 downto 0);
        -- For logic compliment
        SHIFT0: in std_logic;
        SHIFT1: in std_logic;
        SHIFT2: in std_logic;

        -- Outputs
        D:      buffer std_logic_vector(3 downto 0)
        
    );
end global_reg;

architecture global_reg_arch of global_reg is
    signal s0: std_logic_vector(3 downto 0);
    signal s1: std_logic_vector(3 downto 0);
    signal s2: std_logic_vector(3 downto 0);
    signal s3: std_logic_vector(3 downto 0);
    signal s4: std_logic_vector(3 downto 0);
    signal s5: std_logic_vector(3 downto 0);
    signal s6: std_logic_vector(3 downto 0);
    signal s_mux: std_logic_vector(3 downto 0);
    signal s_D: std_logic_vector(3 downto 0);

    component mux
        port(
            s0: in std_logic_vector(3 downto 0);
            s1: in std_logic_vector(3 downto 0);
            s2: in std_logic_vector(3 downto 0);
            s3: in std_logic_vector(3 downto 0);
            s4: in std_logic_vector(3 downto 0);
            s5: in std_logic_vector(3 downto 0);
            s6: in std_logic_vector(3 downto 0);
            Y:  in std_logic_vector(2 downto 0);
            s_mux: out std_logic_vector(3 downto 0)
        );
    end component;

    component reg
        port(
            s_mux:      in std_logic_vector(3 downto 0);
            CLR:        in std_logic;
            C:          in std_logic;
            EN:         in std_logic;
            s_D:        buffer std_logic_vector(3 downto 0)
        );
    end component;

    component outp
        port(
            s_D:      in std_logic_vector(3 downto 0);
            D:        buffer std_logic_vector(3 downto 0)
        );
    end component;

-- Parallel load from X and Z 
    component OP0
        port(
            X:      in std_logic_vector(3 downto 0);
            Z:      in std_logic_vector(3 downto 0);
            s0:     out std_logic_vector(3 downto 0)
        );
    end component;

-- Logic shift to left (compliments with 3 inputs)
    component OP1
        port(
            X:      in std_logic_vector(3 downto 0);
            Z:      in std_logic_vector(3 downto 0);
            SHIFT0: in std_logic;
            SHIFT1: in std_logic;
            SHIFT2: in std_logic;
            D:      in std_logic_vector(3 downto 0);
            s1:     out std_logic_vector(3 downto 0)
        );
    end component;

-- Arithmetic shift to right (compliments with sign)
    component OP2
        port(
            D:      in std_logic_vector(3 downto 0);
            s2:     out std_logic_vector(3 downto 0)
        );
    end component;

-- Masking D with chanel X
    component OP3
        port(
            X:      in std_logic_vector(3 downto 0);
            D:      in std_logic_vector(3 downto 0);
            s3:     out std_logic_vector(3 downto 0)
        );
    end component;

-- Change sign of number
    component OP4
        port(
            D:      in std_logic_vector(3 downto 0);
            s4:     out std_logic_vector(3 downto 0)
        );
    end component;

-- Logic and between D and Z
    component OP5
        port(
            D:      in std_logic_vector(3 downto 0);
            Z:      in std_logic_vector(3 downto 0);
            s5:     out std_logic_vector(3 downto 0)
        );
    end component;

-- Operation with zeros and ones
    component OP6
        port(
            X:      in std_logic_vector(3 downto 0);
            Z:      in std_logic_vector(3 downto 0);
            s6:     out std_logic_vector(3 downto 0)
        );
    end component;
begin
    F0: OP0 port map(
        X => X,
        Z => Z,
        s0 => s0
    );
    F1: OP1 port map(
        X => X,
        Z => Z,
        SHIFT0 => SHIFT0,
        SHIFT1 => SHIFT1,
        SHIFT2 => SHIFT2,
        D => D,
        s1 => s1
    );
    F2: OP2 port map(
        D => D,
        s2 => s2
    );
    F3: OP3 port map(
        X => X,
        D => D,
        s3 => s3
    );
    F4: OP4 port map(
        D => D,
        s4 => s4
    );
    
    F5: OP5 port map(
        D => D,
        Z => Z,
        s5 => s5
    );
    F6: OP6 port map(
        X => X,
        Z => Z,
        s6 => s6
    );
    RG: reg port map(
        s_mux => s_mux,
        CLR => CLR,
        C => C,
        EN => EN,
        s_D => s_D
    );

    M: mux port map(
        s0 => s0,
        s1 => s1,
        s2 => s2,
        s3 => s3,
        s4 => s4,
        s5 => s5,
        s6 => s6,
        Y  => Y,
        s_mux => s_mux
    );

    OU: outp port map(
        s_D => s_D,
        D => D
    );
    
end global_reg_arch;


-- Parallel load from X and Z 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity OP0 is
    port(
        X:      in std_logic_vector(3 downto 0);
        Z:      in std_logic_vector(3 downto 0);
        s0:     out std_logic_vector(3 downto 0)
    );
end OP0;

architecture OP0_arch of OP0 is
begin
    process (X, Z) is
    begin
        s0(3) <= X(3);
        s0(2) <= Z(2);
        s0(1) <= X(1);
        s0(0) <= Z(0);
    end process;
end OP0_arch;

-- Logic shift to left (compliments with 3 inputs)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity OP1 is
    port(
        X:      in std_logic_vector(3 downto 0);
        Z:      in std_logic_vector(3 downto 0);
        SHIFT0: in std_logic;
        SHIFT1: in std_logic;
        SHIFT2: in std_logic;
        D:      in std_logic_vector(3 downto 0);
        s1:     out std_logic_vector(3 downto 0)
    );
end OP1;

architecture OP1_arch of OP1 is
begin
    process (X, Z, SHIFT0, SHIFT1, SHIFT2, D) is
    begin
        if (X(2) = '0' and Z(2) = '0') then
            s1 <= D;
        elsif (X(2) = '0' and Z(2) = '1') then
            s1(3) <= D(2);
            s1(2) <= D(1);
            s1(1) <= D(0);
            s1(0) <= SHIFT0;
        elsif (X(2) = '1' and Z(2) = '0') then
            s1(3) <= D(1);
            s1(2) <= D(0);
            s1(1) <= SHIFT1;
            s1(0) <= SHIFT0;
        elsif (X(2) = '1' and Z(2) = '1') then
            s1(3) <= D(0);
            s1(2) <= SHIFT2;
            s1(1) <= SHIFT1;
            s1(0) <= SHIFT0;
        end if;
    end process;
end OP1_arch;

-- Arithmetic shift to right (compliments with sign)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity OP2 is
    port(
        D:      in std_logic_vector(3 downto 0);
        s2:     out std_logic_vector(3 downto 0)
    );
end OP2;

architecture OP2_arch of OP2 is
begin
    process (D) is
    begin
        s2(0) <= D(1);
        s2(1) <= D(2);
        s2(2) <= D(3);
        s2(3) <= D(3);
    end process;
end OP2_arch;

-- Masking D with chanel X
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity OP3 is
    port(
        X:      in std_logic_vector(3 downto 0);
        D:      in std_logic_vector(3 downto 0);
        s3:     out std_logic_vector(3 downto 0)
    );
end OP3;

architecture OP3_arch of OP3 is
begin
    process (D, X) is
    begin
        for i in 0 to 3 loop
            s3(i) <= D(i) and X(i);
        end loop;
    end process;
end OP3_arch;

-- Change sign of number
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity OP4 is
    port(
        D:      in std_logic_vector(3 downto 0);
        s4:     out std_logic_vector(3 downto 0)
    );
end OP4;

architecture OP4_arch of OP4 is
begin
    process (D) is
        variable buf_vector : std_logic_vector(3 downto 0);
        variable buf : std_logic;
        variable buf2 : std_logic;
    begin
        buf_vector := D;
        buf_vector(0) := not buf_vector(0);
        buf_vector(1) := not buf_vector(1);
        buf_vector(2) := not buf_vector(2);
        buf_vector(3) := not buf_vector(3);
        buf := '1';
        buf2 := buf_vector(0);
        buf_vector(0) := (buf_vector(0) and (not buf)) or ((not buf_vector(0)) and buf);

        buf := buf2 and buf;
        buf2 := buf_vector(1);
        buf_vector(1) := (buf_vector(1) and (not buf)) or ((not buf_vector(1)) and buf);

        buf := buf2 and buf;
        buf2 := buf_vector(2);
        buf_vector(2) := (buf_vector(2) and (not buf)) or ((not buf_vector(2)) and buf);

        buf := buf2 and buf;
        buf_vector(3) := (buf_vector(3) and (not buf)) or ((not buf_vector(3)) and buf);
        s4 <= buf_vector;
    end process;
end OP4_arch;

-- Logic and between D and Z (CHANGE)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity OP5 is
    port(
        D:      in std_logic_vector(3 downto 0);
        Z:      in std_logic_vector(3 downto 0);
        s5:     out std_logic_vector(3 downto 0)
    );
end OP5;

architecture OP5_arch of OP5 is
begin
    process (D, Z) is
    begin
        for i in 0 to 3 loop
            s5(i) <= D(i) and Z(i);
        end loop;
    end process;
end OP5_arch;

-- Operation with zeros and ones (CHANGE)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity OP6 is
    port(
        X:      in std_logic_vector(3 downto 0);
        Z:      in std_logic_vector(3 downto 0);
        s6:     out std_logic_vector(3 downto 0)
    );
end OP6;

architecture OP6_arch of OP6 is
begin
    process (X, Z) is
        variable zerosQuantity : integer := 0;
        variable firstGroupOnesQnt : integer := 0;
    begin
        if (X(3) = '1' and X(2) = '1') then
            null;
        elsif ((X(3) = '0' and X(2) = '1') or (X(3) = '1' and X(2) = '0')) then
            zerosQuantity := 1;
            zerosQuantity := zerosQuantity * 4; 
        elsif (X(3) = '0' and X(2) = '0') then
            zerosQuantity := 2;
            zerosQuantity := zerosQuantity * 4; 
        end if;
        if (Z = "0000") then
            null;
        elsif (Z = "0001" or Z = "0010" or Z = "0100" or Z = "0101" or Z = "1000"
             or Z = "1001" or Z = "1010" or Z = "1101") then
            firstGroupOnesQnt := 1;
        elsif (Z = "0011" or Z = "0110" or Z = "1011" or Z = "1100") then
            firstGroupOnesQnt := 2;
        elsif (Z = "0111" or Z = "1110") then
            firstGroupOnesQnt := 3;
        elsif (Z = "1111") then
            firstGroupOnesQnt := 4;
        end if;
        zerosQuantity := zerosQuantity + firstGroupOnesQnt;
        s6 <= std_logic_vector(to_unsigned(zerosQuantity, 4));
    end process;
end OP6_arch;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity mux is
    port(
        s0: in std_logic_vector(3 downto 0);
        s1: in std_logic_vector(3 downto 0);
        s2: in std_logic_vector(3 downto 0);
        s3: in std_logic_vector(3 downto 0);
        s4: in std_logic_vector(3 downto 0);
        s5: in std_logic_vector(3 downto 0);
        s6: in std_logic_vector(3 downto 0);
        Y:  in std_logic_vector(2 downto 0);
        s_mux: out std_logic_vector(3 downto 0)
    );
end mux;

architecture mux_arch of mux is
begin
    process (Y, s0, s1, s2, s3, s4, s5, s6) is
    begin
        if (Y = o"0") then
            s_mux <= s0;
        elsif (Y = o"1") then
            s_mux <= s1;
        elsif (Y = o"2") then
            s_mux <= s2;
        elsif (Y = o"3") then
            s_mux <= s3;
        elsif (Y = o"4") then
            s_mux <= s4;
        elsif (Y = o"5") then
            s_mux <= s5;
        elsif (Y = o"6") then
            s_mux <= s6;
        elsif (Y = o"7") then
            s_mux <= s6;
        end if;
    end process;
end mux_arch;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity reg is
    port(
        s_mux:      in std_logic_vector(3 downto 0);
        CLR:        in std_logic;
        C:          in std_logic;
        EN:         in std_logic;
        s_D:        out std_logic_vector(3 downto 0)
    );
end reg;

architecture reg_arch of reg is
begin
    process (s_mux, CLR, C, EN) is
    begin
        if (CLR = '1') then
            s_D <= x"0";
        elsif (C'event and C = '1') then
            if (EN = '1') then
                s_D <= s_mux;
            end if;
        end if;
    end process;
end reg_arch;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity outp is
    port(
        s_D:      in std_logic_vector(3 downto 0);
        D:        buffer std_logic_vector(3 downto 0)
    );
end outp;

architecture outp_arch of outp is
begin
    process (s_D) is
    begin
        D <= s_D;
    end process;
end outp_arch;