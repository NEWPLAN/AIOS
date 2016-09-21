;/*  This file is part of The Firekylin Operating System.
; *
; *  Copyright 2016 Liuxiaofeng
; *
; *  Licensed under the Apache License, Version 2.0 (the "License");
; *  you may not use this file except in compliance with the License.
; *  You may obtain a copy of the License at
; *
; *      http://www.apache.org/licenses/LICENSE-2.0
; *
; *  Unless required by applicable law or agreed to in writing, software
; *  distributed under the License is distributed on an "AS IS" BASIS,
; *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; *  See the License for the specific language governing permissions and
; *  limitations under the License.
; */
;
;1:数据寄存器,一般称之为通用寄存器组     8086 有8个8位数据寄存器，
;	这些8位寄存器可分别组成16位寄存器：
;	AH&AL＝AX：累加寄存器，常用于运算；
;	BH&BL＝BX：基址寄存器，常用于地址索引；
;	CH&CL＝CX：计数寄存器，常用于计数；
;	DH&DL＝DX：数据寄存器，常用于数据传递。   
;
;2:地址寄存器/段地址寄存器     为了运用所有的内存空间，8086设定了四个段寄存器，专门用来保存段地址：
;	CS（Code Segment）：代码段寄存器；
;	DS（Data Segment）：数据段寄存器；
;	SS（Stack Segment）：堆栈段寄存器；
;	ES（Extra Segment）：附加段寄存器。
;
;3：特殊功能的寄存器
;	IP（Instruction Pointer）：指令指针寄存器，与CS配合使用，可跟踪程序的执行过程；
;	SP（Stack Pointer）：堆栈指针，与SS配合使用，可指向目前的堆栈位置。
;	BP（Base Pointer）：基址指针寄存器，可用作SS的一个相对基址位置；
;	SI（Source Index）：源变址寄存器可用来存放相对于DS段之源变址指针；
;	DI（Destination Index）：目的变址寄存器，可用来存放相对于 ES 段之目的变址指针。
;
;4：标志寄存器：保存CPU的运行状态
;	OF overflow flag 溢出标志 操作数超出机器能表示的范围表示溢出,溢出时为1.
;	SF sign Flag 符号标志 记录运算结果的符号,结果负时为1.
;	ZF zero flag 零标志 运算结果等于0时为1,否则为0.
;	CF carry flag 进位标志 最高有效位产生进位时为1,否则为0.
;	AF auxiliary carry flag 辅助进位标志 运算时,第3位向第4位产生进位时为1,否则为0.
;	PF parity flag 奇偶标志 运算结果操作数位为1的个数为偶数个时为1,否则为0.
;	DF direcion flag 方向标志 用于串处理.DF=1时,每次操作后使SI和DI减小.DF=0时则增大.
;	IF interrupt flag 中断标志 IF=1时,允许CPU响应可屏蔽中断,否则关闭中断.
;	TF trap flag 陷阱标志 用于调试单步操作.
;

	bits 16 ;十六位，实模式下
start:;拷贝信息，sx:si->ds:di
	mov ax,0x07c0
	mov ds,ax
	mov ax,0x800
	mov es,ax
	xor si,si
	xor di,di
	mov cx,256
	rep movsw
	jmp 0x800:disp_load

disp_load:
	mov ax,0x800
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov sp,0x2000
	mov cx,10
	mov di,info
	mov ah,0x0e
	mov bx,0x10
.next:
	mov al,[di]
	int 0x10
	inc di
	loop .next

load_kernel:
	mov ax,0x1000
	mov es,ax    	; buf es:bx
	mov dx,0     	; DH-_head,DL--driver
	mov cl,1    	; bit 0-5 begin socter number,ch:cyl number.
	mov ch,1
.loop1:
	xor bx,bx
	mov ah,0x2
	mov al,18	; ah:cmd 2--read,AL:read number of socters
	int 0x13
	jc  .die
	inc ch
	cmp ch,[size]
	je  ok_load
	mov ax,es
	add ax,0x20*18
	mov es,ax
		     	; echo .
	mov ah,0x0e
	mov bx,0x10
	mov al,'.'
	int 0x10
	jmp .loop1
.die:	jmp $
ok_load:	     	; kill floppy motor
	mov dx,0x3f2
	mov al,0
	out dx,al

clear_screen:
	mov ax,0x0600
	xor cx,cx
	mov dh,24
	mov al,79
	mov bh,0x07
	int 0x10

open_A20:
	cli
	in  al,   0x92
	or  al,   2
	out 0x92, al
	lgdt [gdt_48]
	mov eax,  cr0
	or  eax,  1
	mov cr0,  eax
	jmp dword 0x10:0x10000

info:
	db "Loading..."
	align 8
gdt:
	dd 0,0
	dd 0,0
	dd 0x0000ffff,0x00cf9a00
	dd 0x0000ffff,0x00cf9200
	dd 0x0000ffff,0x00cbfa00
	dd 0x0000ffff,0x00cbf200
gdt_48:
	dw 0x100-1
	dd gdt+0x8000

	times 508-($-$$) db 0
size:	dw  8
	dw  0xaa55
