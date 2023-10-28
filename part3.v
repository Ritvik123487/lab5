module part3
  #(parameter CLOCK_FREQUENCY=4)(
input wire ClockIn,
input wire Reset,
input wire Start,
input wire [2:0] Letter,
output wire DotDashOut,
output wire NewBitOut
);

  reg Started = 0;
  always@(posedge Start) begin
    Started <= 1;
  end

  RateDivider #(.CLOCK_FREQUENCY(CLOCK_FREQUENCY)) RDInst(.ClockIn(ClockIn), .Reset(Reset), .Letter(Letter), .Started(Started), .NewBitOut(NewBitOut), .DotDashOut(DotDashOut));

endmodule

  module RateDivider #(parameter CLOCK_FREQUENCY=4)(
    input ClockIn,
    input Reset,
    input [2:0] Letter,
    input Started,
    output reg NewBitOut,
    output reg DotDashOut
  );

  reg [11:0] Bletter;
  reg [3:0] Pointer = 0;
  reg [$clog2(CLOCK_FREQUENCY):0] Q;
  reg WireS = 0;

  always @(posedge ClockIn) begin
    if (Reset) 
      WireS <= 0;
    else
      WireS <= Started;
  end

  always @(posedge ClockIn) begin
    if (WireS) begin
      case (Letter) 
        3'b000: Bletter <= 12'b101110000000;
        3'b001: Bletter <= 12'b111010101000;
        3'b010: Bletter <= 12'b111010111010;
        3'b011: Bletter <= 12'b111010100000;
        3'b100: Bletter <= 12'b100000000000;
        3'b101: Bletter <= 12'b101011101000;
        3'b110: Bletter <= 12'b111011101000;
        3'b111: Bletter <= 12'b101010100000;
        default: Bletter <= 12'b0;
      endcase
      Q <= CLOCK_FREQUENCY/2;
      WireS <= 0;
    end

    if (Reset) begin
      Q <= (CLOCK_FREQUENCY/2)-1;
      Pointer <= 0;
      NewBitOut <= 0; 
    end
    else if (Q==0) begin
      NewBitOut <= 1; 
      Q <= (CLOCK_FREQUENCY/2)-1;
      if (Pointer < 8) begin
        DotDashOut <= Bletter[Pointer];
        Pointer <= Pointer + 1'b1;
      end
      else
        DotDashOut <= 1'b0; //Same morse code sequeence but now we have finished
    end
    else begin
      Q <= Q - 1'b1;
      NewBitOut <= 0; 
    end
  end

endmodule





