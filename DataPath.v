`timescale 1ns/1ns

module DataPathFase1 (
	input Eclk
);

wire [31:0]Instruccion, C0, C1, C3, C4, C5, C9, C12, C13, C14, C18, C21, C22;
wire [1:0] C15;
wire[2:0] C16;
wire [4:0] C2; 
wire C6, C7, C8, C10, C11, C17, C23;

assign C1 = C0 + 4;
assign C5 = C1 + C4;
assign C8 = C6 & C7;

PC ProgramCounter(
	.Direct1(C9),
	.clk(Eclk),
	.Direct2(C0)
);

InsMemory MemoriaDeInstrucciones(
	.Direccion(C0),
	.Instruc(Instruccion)
);

UnidadControl UC(
	.OP(Instruccion[31:26]),
	.MemRead(C20),
	.Branch(C6),
	.MemToReg(C23),
	.RegWrite(C17),
	.ALUSrc(C11),
	.RegDst(C10),
	.MemToWrite(C19),
	.ALUOp(C15)
);

mux_5 Multiplexor5b(
	.in_0(Instruccion[20:16]),
	.in_1(Instruccion[15:11]),
	.regule(C10),
	.res(C2)
);

banco BR(
	.RegEn(C17),
	.ra1(Instruccion[25:21]),
	.ra2(Instruccion[20:16]),
	.aw(C2),
	.dataIn_b(C22),
	.dr1(C14),
	.dr2(C12)
);

sign_extend SE(
	.instruccionIn(Instruccion[15:0]),
	.instruccionOut(C3)
);

shift_left2 SL(
	.instruccionIn(C3),
	.instruccionOut(C4)
);

mux_32 Multiplexor32_1(
	.in_0(C1),
	.in_1(C5),
	.regule(C8),
	.res(C9)
);

mux_32 Multiplexor32_2(
	.in_0(C12),
	.in_1(C3),
	.regule(C11),
	.res(C13)
);

ALUControl AC(
	.InData(Instruccion[5:0]),
	.UCon(C15),
	.ALUSelect(C16)
);

alu ALU(
	.a(C14),
	.b(C13),
	.sel(C16),
	.res(C18),
	.ZF(C7)
);

memory Mem(
	.MemWrite(C19), 
	.MemRead(C20),
	.dir(C18),
	.dataIn(C12),
	.dataOut(C21)
);

mux_32 Multiplexor32_3(
	.in_0(C18),
	.in_1(C21),
	.regule(C23),
	.res(C22)
);
endmodule
