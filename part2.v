module part2
  #(parameter CLOCK_FREQUENCY = 50000000) (
  input ClockIn,
  input Reset,
  input [1:0] Speed,
  output [3:0] CounterValue
);

  wire Enable;
  RateDivider #(.CLOCK_FREQUENCY(CLOCK_FREQUENCY)) r1(.ClockIn(ClockIn), .Reset(Reset), .Speed(Speed), .Enable(Enable));
  DisplayCounter d1(.Clock(ClockIn), .Reset(Reset), .EnableDC(Enable), .CounterValue(CounterValue));
endmodule

module RateDivider #(parameter CLOCK_FREQUENCY=50000000) (
    input ClockIn,
    input Reset,
    input [1:0] Speed,
    output Enable
);
  reg [$clog2(CLOCK_FREQUENCY) :0] Q;
  always @(posedge ClockIn) begin
    if (Q == 0 || Reset) begin
          case (Speed)
              2'b00: Q <= 0;
              2'b01: Q <= CLOCK_FREQUENCY-1;
            2'b10: Q <= (CLOCK_FREQUENCY * 2)-1;
            2'b11: Q <= (CLOCK_FREQUENCY * 4)-1;
          endcase
      end
       else
        Q <= Q-1;
  end


  assign Enable = (Q == 0) ? 1'b1 : 1'b0;

endmodule


module DisplayCounter (
  input Clock,
  input Reset,
  input EnableDC,
  output reg [3:0] CounterValue
);

  always @(posedge Clock) begin
    if (Reset) begin
      CounterValue <= 4'b0000;
    end
    else if (EnableDC)
      CounterValue <= CounterValue + 1'b1;

  end

endmodule