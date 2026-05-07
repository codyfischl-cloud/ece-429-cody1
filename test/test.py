import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_pm32(dut):

    dut.reset.value = 1
    dut.start.value = 0
    dut.mc.value = 0
    dut.mp.value = 0

    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.reset.value = 0

    dut.mc.value = 20
    dut.mp.value = 30

    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    while dut.done.value == 0:
        await RisingEdge(dut.clk)

    assert int(dut.p.value) == 600, f"Expected 600 got {int(dut.p.value)}"
