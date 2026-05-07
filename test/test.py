import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_pm32(dut):

    # Clock
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())

    # Reset (active low)
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # Apply inputs (mapped to ui_in/uio_in)
    dut.ui_in.value = 20
    dut.uio_in.value = 30

    # wait for computation
    for _ in range(20):
        await RisingEdge(dut.clk)

    # Check output (only visible result)
    result = int(dut.uo_out.value)

    assert result != 0, f"Got {result}, expected non-zero output"
