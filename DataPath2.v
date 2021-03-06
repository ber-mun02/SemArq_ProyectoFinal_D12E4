`timescale 1ns/1ns

module DataPathFase2(
	input Eclk
);

wire [31:0]C0, C1, C2, C3, C4, C5, C11, C12, C13, C14, C18, C21, C22, C23, C26, C28, C29, C30, C38, C40, C41, C44, C45, C46;
wire [1:0]C6, C15, C37;
wire [2:0]C7, C9, C16, C27;
wire [4:0]C17, C20, C24, C25, C32, C33;
wire C8, C10, C19, C31, C34, C35, C36, C39, C42, C43;

assign C3 = C1 + 4;					//suma +4
assign C42 = C39 & C34;					//compuerta and
assign C28 = C11 + C26;					//add result
	
PC ProgramCounter(
	.Direct1(C0),
	.clk(Eclk),
	.Direct2(C1)
);

InsMemory MemoriaDeInstrucciones(
	.Direccion(C1),
	.Instruc(C2)
);

IFID IF_ID(
	.clkIFID(Eclk),
	.FAdd4(C3),
	.FMi(C2),
	.Instruccion(C4),
	.tIFID(C5)
);

UnidadControl UC(
	.OP(C4[31:26]),
	.tWB(C15),
	.tM(C16),
	.tEX(C17)
);

sign_extend SE(
	.instruccionIn(C4[15:0]),
	.instruccionOut(C18)
);

banco BR(
	.RegEn(C19),
	.ra1(C4[25:21]),
	.ra2(C4[20:16]),
	.aw(C20),							
	.dataIn_b(C21),
	.dr1(C22),
	.dr2(C23)						
);

IDEX ID_EX(
	.clkIDEX(Eclk),
	.WB1(C15),
	.M1(C16),
	.EX(C17),
	.fIFIDa4(C5),
	.fBR1(C22),
	.fBR2(C23),
	.fSE(C18),
	.fIns1(C4[20:16]),
	.fIns2(C4[15:11]),
	.Wb1(C6),
	.Mem1(C7),
	.RegDst(C8), 
	.ALUOp(C9),
	.ALUSrc(C10),
	.tAdd(C11),
	.tALU(C12),
	.tMux32(C13),
	.tACsl(C14),
	.tMux5_1(C24),
	.tMux5_2(C25)
);

shift_left2 SL(
	.instruccionIn(C14),
	.instruccionOut(C26)
);

ALUControl AC(
	.InData(C14[5:0]),
	.UCon(C9),
	.ALUSelect(C27)
);

mux_32 Multiplexor32_1(
	.in_0(C13),
	.in_1(C14),
	.regule(C10),
	.res(C29)
);

alu ALU(
	.a(C12),
	.b(C29),
	.sel(C27),
	.res(C30),
	.ZF(C31)
);

mux_5 Multiplexor5_1(
	.in_0(C24),
	.in_1(C25),
	.regule(C8),
	.res(C32)
);

EXMEM EX_MEM(
	.clkEXMEM(Eclk),
	.WB2(C6),
	.M2(C7),
	.fAddR(C28),
	.ZF(C31),
	.fALU(C30),
	.fIDEXrd(C13),
	.fMux5(C32),
	.Wb2(C37),
	.Branch(C34),
	.MemRead(C35),
	.MemWrite(C36),
	.tMux32(C38),
	.ZFtAND(C39),
	.AluRes(C40),
	.tWriteData(C41),
	.toMEMWB(C33)
);

memory MEM(
	.MemWrite(C36),
	.MemRead(C35),
	.dir(C40),
	.dataIn(C41),
	.dataOut(C44)
);

MEMWB MEM_WB(
	.clkMEMWB(Eclk),
	.WB3(C37),
	.RegWrite(C19),
	.MemtoReg(C43),
	.fAdd(C40),
	.fRD(C44),
	.fEXMEM(C33),
	.toAW(C20),
	.tMux5_0(C45),
	.tMux5_1(C46)
);

mux_32 Multiplexor32_2(
	.in_0(C45),
	.in_1(C46),
	.regule(C43),
	.res(C21)
);

mux_32 Multiplexor32_3(
	.in_0(C3),
	.in_1(C38),
	.regule(C42),
	.res(C0)
);

endmodule
