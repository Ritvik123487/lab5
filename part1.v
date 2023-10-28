module part1 (
  input Clock,
  input Enable,
  input Reset,
  output [7:0] CounterValue
);

  wire en1 = Enable&CounterValue[0];
  wire en2 = en1&CounterValue[1];
  wire en3 = en2&CounterValue[2];
  wire en4 = en3&CounterValue[3];
  wire en5 = en4&CounterValue[4];
  wire en6 = en5&CounterValue[5];
  wire en7 = en6&CounterValue[6];


  Tflipflop u1(Clock, Enable, Reset, CounterValue[0]);
  Tflipflop u2(Clock, en1, Reset, CounterValue[1]);
  Tflipflop u3(Clock, en2, Reset, CounterValue[2]);
  Tflipflop u4(Clock, en3, Reset, CounterValue[3]);
  Tflipflop u5(Clock, en4, Reset, CounterValue[4]);
  Tflipflop u6(Clock, en5, Reset, CounterValue[5]);
  Tflipflop u7(Clock, en6, Reset, CounterValue[6]);
  Tflipflop u8(Clock, en7, Reset, CounterValue[7]);



endmodule


module Tflipflop (Clock, Enable, Reset, Q);

  input Clock;
  input Enable;
  input Reset;
  output reg Q;

  wire Hold;
  assign Hold = Enable^Q;
  always@(posedge Clock)

  begin
    if (Reset) Q <= 1'b0;
    else Q <= Hold;
  end




endmodule
