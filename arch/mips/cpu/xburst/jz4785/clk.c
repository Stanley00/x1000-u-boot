/*
 * Jz4775 clock common interface
 *
 * Copyright (C) 2013 Ingenic Semiconductor Co.,Ltd
 * Author: Zoro <ykli@ingenic.cn>
 * Based on: newxboot/modules/clk/jz4775_clk.c
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

#include <config.h>
#include <common.h>
#include <asm/io.h>
#include <asm/gpio.h>
#include <asm/arch/cpm.h>
#include <asm/arch/clk.h>

DECLARE_GLOBAL_DATA_PTR;

void cgu_clks_set(struct cgu *cgu_clks, int nr_cgu_clks)
{
	int i;

	for(i = 0; i < nr_cgu_clks; i++) {
		unsigned int xcdr = (cgu_clks[i].sel << cgu_clks[i].sel_bit);
		unsigned int reg = CPM_BASE + cgu_clks[i].off;

		writel(xcdr, reg);
		if (cgu_clks[i].en_bit && cgu_clks[i].busy_bit) {
			writel(xcdr | cgu_clks[i].div | (1 << cgu_clks[i].en_bit), reg);
			while (readl(reg) & (1 << cgu_clks[i].busy_bit))
				printf("wait cgu %x\n",reg);
		}
#ifdef DUMP_CGU_SELECT
		printf("0x%X: value=0x%X\n",
		       reg & ~(0xa << 28), readl(reg));
#endif
	}
}

static unsigned int pll_get_rate(int pll)
{
	unsigned int cpxpcr = cpm_inl(CPM_CPAPCR);
	unsigned int m, n, od;

	m = ((cpxpcr >> 24) & 0x7f) + 1;
	n = ((cpxpcr >> 18) & 0x1f) + 1;
	od = (cpxpcr >> 16) & 0x3;
	od = 1 << od;
#ifdef CONFIG_BURNER
	return (unsigned int)((unsigned long)gd->arch.gi->extal * m / n / od);
#else
	return (unsigned int)((unsigned long)CONFIG_SYS_EXTAL * m / n / od);
#endif
}

static unsigned int get_ddr_rate(void)
{
	unsigned int ddrcdr  = cpm_inl(CPM_DDRCDR);

	switch ((ddrcdr >> 30) & 3) {
	case 1:
		return pll_get_rate(APLL) / ((ddrcdr & 0xf) + 1);
	case 2:
		return pll_get_rate(MPLL) / ((ddrcdr & 0xf) + 1);
	}
	return 0;
}

static unsigned int get_cclk_rate(void)
{
	unsigned int cpccr  = cpm_inl(CPM_CPCCR);

	switch ((cpccr >> 28) & 3) {
	case 1:
		return pll_get_rate(APLL) / ((cpccr & 0xf) + 1);
	case 2:
		return pll_get_rate(MPLL) / ((cpccr & 0xf) + 1);
	}
	return 0;
}

static unsigned int get_msc_rate(unsigned int xcdr)
{
#ifndef CONFIG_SPL_BUILD
	unsigned int msc0cdr  = cpm_inl(CPM_MSC0CDR);
	unsigned int mscxcdr  = cpm_inl(xcdr);
	unsigned int ret = 1;

	switch ((msc0cdr >> 30) & 3) {
	case 1:
		ret = pll_get_rate(APLL) / (((mscxcdr & 0xff) + 1) * 2);
		break;
	case 2:
		ret = pll_get_rate(MPLL) / (((mscxcdr & 0xff) + 1) * 2);
		break;
	default:
		break;
	}

	return ret;
#else
	return CGU_MSC_FREQ;
#endif
}

unsigned int clk_get_rate(int clk)
{
	switch (clk) {
#ifndef CONFIG_SPL_BUILD
	case DDR:
		return get_ddr_rate();
	case CPU:
		return get_cclk_rate();
#endif
	case MSC0:
		return get_msc_rate(CPM_MSC0CDR);
	case MSC1:
		return get_msc_rate(CPM_MSC1CDR);
	case MSC2:
		return get_msc_rate(CPM_MSC2CDR);
	}

	return 0;
}

static unsigned int set_msc_rate(int clk, unsigned long rate)
{
#ifndef CONFIG_SPL_BUILD
	unsigned int msc0cdr  = cpm_inl(CPM_MSC0CDR);
	unsigned int xcdr_addr = 0;
	unsigned int pll_rate = 0;
	unsigned int cdr = 0;

	switch (clk) {
	case MSC0:
		xcdr_addr = CPM_MSC0CDR;
		break;
	case MSC1:
		xcdr_addr = CPM_MSC1CDR;
		break;
	case MSC2:
		xcdr_addr = CPM_MSC2CDR;
		break;
	default:
		break;
	}

	switch ((msc0cdr >> 30) & 3) {
	case 1:
		pll_rate = pll_get_rate(APLL);
		break;
	case 2:
		pll_rate = pll_get_rate(MPLL);
		break;
	default:
		break;
	}

	cdr = ((((pll_rate / rate) % 2) == 0)
		? (pll_rate / rate / 2)
		: (pll_rate / rate / 2 + 1)) - 1;
	cpm_outl((cpm_inl(xcdr_addr) & ~0xff) | cdr | (1 << 29), xcdr_addr);

	while (cpm_inl(xcdr_addr) & (1 << 28));

	debug("%s: %lu mscXcdr%x\n", __func__, rate, cpm_inl(xcdr_addr));
#endif
	return 0;
}

void clk_set_rate(int clk, unsigned long rate)
{
#ifndef CONFIG_SPL_BUILD
	switch (clk) {
	case MSC0:
	case MSC1:
	case MSC2:
		set_msc_rate(clk, rate);
		return;
	default:
		break;
	}

	printf("%s: clk%d is not supported\n", __func__, clk);
#endif
}

struct cgu __attribute__((weak)) spl_cgu_clksel[] = {
	/*
	 * {offset, sel, sel_bit, en_bit, busy_bit, div}
	 */
	[0] = {CPM_DDRCDR, 1, 30, 29, 28, 0},
#ifdef CONFIG_JZ_MMC_MSC0
	{CPM_MSC0CDR, 1, 30, 29, 28, CGU_MSC_DIV},
#endif
#ifdef CONFIG_JZ_MMC_MSC1
	{CPM_MSC1CDR, 1, 30, 29, 28, CGU_MSC_DIV},
#endif
#ifdef CONFIG_NAND
	{CPM_BCHCDR, 2, 30, 29, 28, CGU_BCH_DIV},
#endif
#ifdef CONFIG_VIDEO_JZ4775
	{CPM_LPCDR, 0, 31, 28, 27, CGU_LCD_DIV},
#endif
	{CPM_I2SCDR, 2, 30, 0, 0, 0},
};

void clk_init(void)
{
	unsigned int reg_clkgr = cpm_inl(CPM_CLKGR);
	unsigned int gate = 0
#ifdef CONFIG_JZ_MMC_MSC0
		| CPM_CLKGR_MSC0
#endif
#ifdef CONFIG_JZ_MMC_MSC1
		| CPM_CLKGR_MSC1
#endif
#ifdef CONFIG_JZ_MMC_MSC2
		| CPM_CLKGR_MSC2
#endif
#ifdef CONFIG_VIDEO_JZ4775
		| CPM_CLKGR_LCD
#endif
#ifdef CONFIG_NET_JZ4775
		| CPM_CLKGR_GMAC
#endif
		;

	reg_clkgr &= ~gate;
	cpm_outl(reg_clkgr,CPM_CLKGR);

	spl_cgu_clksel[0].div = gd->arch.gi->ddr_div - 1;
	cgu_clks_set(spl_cgu_clksel, ARRAY_SIZE(spl_cgu_clksel));
}

void enable_uart_clk(void)
{
	unsigned int clkgr = cpm_inl(CPM_CLKGR);

	switch (gd->arch.gi->uart_idx) {
#define _CASE(U, N) case U: clkgr &= ~N; break
		_CASE(0, CPM_CLKGR_UART0);
		_CASE(1, CPM_CLKGR_UART1);
		_CASE(2, CPM_CLKGR_UART2);
		_CASE(3, CPM_CLKGR_UART3);
	default:
		break;
	}
	cpm_outl(clkgr, CPM_CLKGR);
}