/*
 * Ingenic burner setup code
 *
 * Copyright (c) 2013 Ingenic Semiconductor Co.,Ltd
 * Author: Zoro <ykli@ingenic.cn>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <nand.h>
#include <net.h>
#include <netdev.h>
#include <asm/gpio.h>
#include <asm/arch/cpm.h>
#include <asm/arch/nand.h>
#include <asm/arch/mmc.h>
#include <asm/jz_uart.h>

#ifndef CONFIG_SPL_BUILD
DECLARE_GLOBAL_DATA_PTR;
struct global_info ginfo __attribute__ ((section(".data")));
extern struct jz_uart *uart;
#endif

int board_early_init_f(void)
{
#ifndef CONFIG_SPL_BUILD
	ginfo.extal = CONFIG_SYS_EXTAL;
	ginfo.cpufreq = CONFIG_SYS_CPU_FREQ;
	ginfo.ddrfreq = CONFIG_SYS_MEM_FREQ;
	ginfo.uart_base = CONFIG_SYS_UART_BASE;
	ginfo.baud_rate = CONFIG_BAUDRATE;

	uart = (struct jz_uart *)CONFIG_SYS_UART_BASE;
	gd->arch.gi = &ginfo;
#endif
	return 0;
}

int misc_init_r(void)
{
	return 0;
}

int board_nand_init(struct nand_chip *nand)
{
	return 0;
}


#ifdef CONFIG_MMC
int board_mmc_init(bd_t *bd)
{
	return 0;
}
#endif

#ifdef CONFIG_DRIVER_DM9000

int board_eth_init(bd_t *bis)
{
	return 0;
}

#endif /* CONFIG_DRIVER_DM9000 */

/* U-Boot common routines */
int checkboard(void)
{
	puts("Board: burner_jz4780 (Ingenic XBurst JZ4780 SoC)\n");
	return 0;
}

#ifdef CONFIG_SPL_BUILD

void spl_board_init(void)
{
}

#endif /* CONFIG_SPL_BUILD */