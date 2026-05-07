import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


# -----------------------
# Reset task
# -----------------------
async def reset(dut):
    dut.rst.value = 1
    dut.start.value = 0
    dut.mc.value = 0
    dut.mp.value = 0

    await ClockCycles(dut.clk, 3)

    dut.rst.value = 0
    await RisingEdge(dut.clk)


# -----------------------
# Main test
# -----------------------
@cocotb.test()
async def test_pm32(dut):

    # Clock
    cocotb.start_soon(Clock(dut.clk, 10, unit="us").start())

    # Reset DUT
    await reset(dut)

    # -----------------------
    # Test 1: 20 * 30
    # -----------------------
    dut.mc.value = 20
    dut.mp.value = 30
    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    # wait for done
    for _ in range(100):
        await RisingEdge(dut.clk)
        if dut.done.value == 1:
            break


    # -----------------------
    # Reset before next test
    # -----------------------
    await reset(dut)

    # -----------------------
    # Test 2: 5 * 7
    # -----------------------
    dut.mc.value = 5
    dut.mp.value = 7
    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    # wait for done
    for _ in range(100):
        await RisingEdge(dut.clk)
        if dut.done.value == 1:
            break

    assert dut.p.value == 35, f"Expected 35 got {dut.p.value}"
