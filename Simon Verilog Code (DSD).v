Appendix:
Main Module:
module Simon (push,clk,Led,SW,S0,S1,S2,S3);
input [1:0]push;
input [5:0]SW;
input clk;

//Seven Segment wires
output wire [6:0] S0;
output wire [6:0] S2;
output wire [6:0] S1;
output wire [6:0] S3;
output wire [5:0]Led;

//Seven Segments
reg [6:0]sevenSeg0;
assign S0 = sevenSeg0;
reg [6:0]sevenSeg1;
assign S1 = sevenSeg1;
reg [6:0]sevenSeg2;
assign S2 = sevenSeg2;
reg [6:0]sevenSeg3;
assign S3 = sevenSeg3;

//Base Sequence
reg [159:0]rseq = {160'b10101011001000111111100001010111011001001100100110101101000110011111111101101110110101011011111000101100100111111101001110010011011011011010010001001101010101011001000101101111010111111010101100100011111110000101011101100100110010011010110100011001111111110110111011010101101111100010110010011111110100111001001101101101101001000100110101010101100100010110111101011111};

//Output LEDs
reg [5:0]Ledx;
assign Led = Ledx;

//Rounds Array
reg rounds [39:0][3:0];
//RNG sequence Output
reg [159:0]seq;


wire Hz1;
integer currentR = 0; //current round
reg [24:0] count; //for 1 hz countdown
integer k = 0; //Sequence count
integer maxr; //
integer i =0; //Iteration Variable
integer j =0; //Iteration Variable
integer L=0; 
integer b = 0; //LED output iteration
integer maxScore = 0;
integer endGame = 0;

Hz1 hz(.clk(clk),.Hz1(Hz1));//Call 1 hz clk module


//Xor RNG sequence code
  always@(posedge clk) begin
     rseq <= {rseq[159:0], rseq[0] ^ rseq[129] ^ rseq[99] ^ rseq[98]};
  end

  always@(posedge push[1])begin
    seq<=rseq;
  end

//Fill rounds array with the random seq
always @ (posedge clk) begin
maxr = 39;//max rounds

//2D array fill
for(i=0; (i< maxr); i= i+1 )begin
    for(j = 0; j<=3; j = j +1) begin
        if((i*4)-1 >= 0) begin
            rounds[i][j]<= seq[j + ((i*4))];end
        else begin
            rounds[i][j]<= seq[j + (i*4)];
        end
    end
end 
end

//Output each round to Led[3:0]
always @ (posedge Hz1)begin

//Output rounds to leds
    
    //Reset Count
    if(L == 0)begin
        b <= 0;
    end
    //Turn on LED[5] on with First sequence
    if(b == 0) begin
    Ledx[5] <= 1;
    end
    
    //Switch LED's off
    if ((Ledx[0] == 1) || (Ledx[1] == 1) || (Ledx[2] == 1)|| (Ledx[3] == 1)|| (Ledx[4] == 1))begin
        b<=b;
        Ledx[0] <= 0;
        Ledx[1] <= 0;
        Ledx[2] <= 0;
        Ledx[3] <= 0;
        Ledx[4] <= 0;
        Ledx[5] <= 0;
    end
    else begin
    
    if(L == 0)begin //If Push[0] is pushed dont output LED's
    //Output LED Sequences
    if ((b < (currentR +1)))begin
        Ledx[0] <= rounds[b][0];
        Ledx[1] <= rounds[b][1];
        Ledx[2] <= rounds[b][2];
        Ledx[3] <= rounds[b][3];
        Ledx[4] <= 1;
        b <= b +1;
        
            end
        end
    end
end

//Check if inputs are correct
always @(posedge push[0])begin //player inputs for the rounds
    
    //Check Input
    if (((SW[0] == rounds[k][0]) && (SW[1] == rounds[k][1])) && ((SW[2] == rounds[k][2]) && (SW[3] == rounds[k][3])))begin
        if (currentR > (maxr -1))begin
        currentR <= currentR;
    end
    
    if (k == currentR)begin
        currentR <= currentR + 1;
        k <= 0;
        L <= 0;
    end
    if(k < currentR)begin
        k <= k+1;
        L <= 100;
    end
    if(currentR == 0)begin
        if(k==0)begin
            currentR<= currentR + 1;
            k <= 0;
            L <= 0;
        end
    end
end 
    
//End Game
else begin
    currentR <=0;
    endGame = 1;
    k <= 0;
    L <= 0;
end
 
//Max Score Check
if(currentR > maxScore)begin
    maxScore = currentR;
end
end

//Output Current Score
always @(posedge clk)begin
case(currentR)
0:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b1000000;end
1:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b1111001;end
2:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b0100100;end
3:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b0110000;end
4:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b0011001;end
5:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b0010010;end
6:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b0000010;end
7:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b1111000;end
8:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b0000000;end
9:begin sevenSeg1 <= 7'b1000000;sevenSeg0 <= 7'b0011000;end
10:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b1000000;end
11:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b1111001;end
12:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b0100100;end
13:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b0110000;end
14:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b0011001;end
15:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b0010010;end
16:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b0000010;end
17:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b1111000;end
18:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b0000000;end
19:begin sevenSeg1 <= 7'b1111001;sevenSeg0 <= 7'b0011000;end
20:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b1000000;end
21:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b1111001;end
22:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b0100100;end
23:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b0110000;end
24:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b0011001;end
25:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b0010010;end
26:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b0000010;end
27:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b1111000;end
28:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b0000000;end
29:begin sevenSeg1 <= 7'b0100100;sevenSeg0 <= 7'b0011000;end
30:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b1000000;end
31:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b1111001;end
32:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b0100100;end
33:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b0110000;end
34:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b0011001;end
35:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b0010010;end
36:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b0000010;end
37:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b1111000;end
38:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b0000000;end
39:begin sevenSeg1 <= 7'b0110000;sevenSeg0 <= 7'b0011000;end
endcase
end

//Output Highest Score
always @(posedge clk) begin
case(maxScore)
0:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b1000000;end
1:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b1111001;end
2:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b0100100;end
3:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b0110000;end
4:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b0011001;end
5:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b0010010;end
6:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b0000010;end
7:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b1111000;end
8:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b0000000;end
9:begin sevenSeg3 <= 7'b1000000;sevenSeg2 <= 7'b0011000;end
10:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b1000000;end
11:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b1111001;end
12:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b0100100;end
13:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b0110000;end
14:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b0011001;end
15:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b0010010;end
16:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b0000010;end
17:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b1111000;end
18:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b0000000;end
19:begin sevenSeg3 <= 7'b1111001;sevenSeg2 <= 7'b0011000;end
20:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b1000000;end
21:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b1111001;end
22:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b0100100;end
23:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b0110000;end
24:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b0011001;end
25:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b0010010;end
26:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b0000010;end
27:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b1111000;end
28:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b0000000;end
29:begin sevenSeg3 <= 7'b0100100;sevenSeg2 <= 7'b0011000;end
30:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b1000000;end
31:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b1111001;end
32:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b0100100;end
33:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b0110000;end
34:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b0011001;end
35:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b0010010;end
36:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b0000010;end
37:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b1111000;end
38:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b0000000;end
39:begin sevenSeg3 <= 7'b0110000;sevenSeg2 <= 7'b0011000;end
endcase
end
endmodule
1 Hz Clock Module:
module Hz1(clk,Hz1);
input clk;
output Hz1;

reg [24:0] count;
reg Hz1;

always @(posedge clk) begin
  if (count == 24999999) begin
    count <= 0;
    Hz1 <= ~Hz1;
end
else begin
    count <= count + 1;
    end
end
endmodule



