import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


def to_unsigned(value, bits):
    return value & ((1 << bits) - 1)


async def reset_dut(dut):
    dut.rst.value = 1
    dut.start.value = 0
    dut.mc.value = 0
    dut.mp.value = 0

    await ClockCycles(dut.clk, 3)

    dut.rst.value = 0
    await RisingEdge(dut.clk)


async def run_pm32_test(dut, mc_value, mp_value):
    await reset_dut(dut)

    dut.mc.value = to_unsigned(mc_value, 32)
    dut.mp.value = to_unsigned(mp_value, 32)

    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    done_seen = False

    for _ in range(100):
        await RisingEdge(dut.clk)

        if int(dut.done.value) == 1:
            done_seen = True
            break

    assert done_seen, "PM32 did not finish. done never became 1."

    # wait one extra clock so output p updates
    await RisingEdge(dut.clk)

    expected = to_unsigned(mc_value * mp_value, 64)
    actual = int(dut.p.value)

    assert actual == expected, (
        f"PM32 failed for mc={mc_value}, mp={mp_value}. "
        f"Expected {expected:#018x}, got {actual:#018x}"
    )


@cocotb.test()
async def test_pm32_smoke(dut):
    dut._log.info("Starting PM32 smoke test")

    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    await run_pm32_test(dut, 20, 30)


@cocotb.test()
async def test_pm32_multiple_values(dut):
    dut._log.info("Starting PM32 multiple-value test")

    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    test_cases = [
        (0, 0),
        (1, 1),
        (5, 7),
        (20, 30),
        (1234, 5678),
        (100, 200),
        (255, 255),
        (1024, 4096),
    ]
    for mc_value, mp_value in test_cases:
        await run_pm32_test(dut, mc_value, mp_value)
