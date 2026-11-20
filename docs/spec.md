# DES IP Core: Specification

**Module:** EDA for Circuit, 4th-Year Master (Microelectronics NSNN)
**Supervisor:** Dr. Bakiri Mohammed
**Author:** Hamdi Pacha Mouad
**Version:** 0.1 (draft)

## 1. Overview

This project implements a Data Encryption Standard (DES) cryptographic IP core in Verilog. It supports encryption and decryption of 64-bit blocks and is verified in simulation, then implemented on FPGA and ASIC flows.

## 2. Algorithm Parameters

| Parameter | Value |
|---|---|
| Block size | 64 bits |
| Key size | 64 bits (56 effective + 8 parity) |
| Rounds | 16 (Feistel network) |
| Subkey size | 48 bits per round |
| Decryption | Same datapath, subkeys applied in reverse order |

Reference: FIPS 46-3. The permutation and S-box tables are defined in the RTL files and are not repeated here.

## 3. Functional Blocks

| Block | Size | Role |
|---|---|---|
| IP (initial permutation) | 64 → 64 | Applied to the input block |
| FP (final permutation) | 64 → 64 | Applied to the output block |
| E (expansion) | 32 → 48 | Expands the right half in the round function |
| S-boxes (8x) | 6 → 4 each | Non-linear substitution |
| P (permutation) | 32 → 32 | Permutes the S-box output |
| PC-1 | 64 → 56 | Key schedule, initial key selection |
| PC-2 | 56 → 48 | Key schedule, subkey selection |
| Key shifts | | 1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1 |

Round function: `f(R, K) = P(S(E(R) XOR K))`, then `L' = R`, `R' = L XOR f(R, K)`.

## 4. Interface

| Port | Dir | Width | Description |
|---|---|---|---|
| clk | in | 1 | System clock |
| rst_n | in | 1 | Active-low reset |
| start | in | 1 | Begin operation (1-cycle pulse) |
| mode | in | 1 | 0 = encrypt, 1 = decrypt |
| key | in | 64 | DES key |
| data_in | in | 64 | Input block |
| data_out | out | 64 | Output block |
| done | out | 1 | Result valid |

## 5. Architecture

- **Iterative design:** one Feistel round per clock cycle.
- Latency: about 16 cycles per block, plus load and output.
- Main parts: control FSM, key schedule, round datapath, IP/FP.
- Possible later upgrade: pipelined version for higher throughput.

## 6. Target Platforms

- **FPGA:** Sipeed Tang Nano 1K (Gowin GW1NZ-LV1): 1152 LUT4, 864 FF, 72 Kbit B-SRAM, onboard USB-C JTAG programmer
- **Tools:** TBD (simulator, synthesis tool)
- **ASIC:** TBD (flow and technology)

## 7. Verification Plan

Known-answer test (classic DES vector):

| Item | Value |
|---|---|
| Key | `133457799BBCDFF1` |
| Plaintext | `0123456789ABCDEF` |
| Expected ciphertext | `85E813540F0AB405` |

Tests:
1. Encrypt the vector above and compare with the expected ciphertext.
2. Decrypt the ciphertext and recover the plaintext.
3. Unit testbenches for IP/FP, E, S-boxes, P and the key schedule.
4. Check the `done` handshake and reset behaviour.

## 8. Deliverables

- RTL (Verilog) and testbenches
- Simulation results
- FPGA implementation results
- ASIC implementation results
- Git repository: https://github.com/m1ghost05/des-ip-core
- IEEE-format technical report
- Demo
