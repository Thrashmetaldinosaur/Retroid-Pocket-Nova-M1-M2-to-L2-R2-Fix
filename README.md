# Retroid Pocket Nova — permanent M1/M2 → L2/R2 trigger replacement

**A reversible, systemless Magisk module for a Retroid Pocket Nova with the flat-back mod (physical L2/R2 triggers removed).** M1 becomes L2 and M2 becomes R2 throughout Android, without per-game profiles, a paid mapper, or a second virtual controller.

**Tested working on November 7, 2026:** a Retroid Pocket Nova running **stock Android 13 and Magisk 31.1**. After reboot, both GameNative and an independent gamepad tester recognized the remapped triggers. The Retroid **built-in keypad test still labels the physical buttons M1/M2**; that is expected and does not mean the fix failed.

## Download and install (already Magisk-rooted)

1. Download **[NOVA-M1M2-TRIGGER-REPLACEMENT-MAGISK-v3.zip](module/NOVA-M1M2-TRIGGER-REPLACEMENT-MAGISK-v3.zip)** onto your Nova (use the file itself, **not** GitHub's *Download ZIP* for the entire repository).
2. In **Retroid Handheld Settings**, set **M1 = Default** and **M2 = Default**. Leave both at Default whenever this module is enabled. Do **not** first remap them to L2/R2 in Retroid's settings.
3. Open **Magisk → Modules → Install from storage**, select `NOVA-M1M2-TRIGGER-REPLACEMENT-MAGISK-v3.zip`, and allow the installation to finish.
4. **Reboot** the Nova once.
5. Test M1/M2 in a third-party controller tester or a game. M1 should act as L2 and M2 as R2; each trigger is either **fully pressed or released**.

> **Requirements:** Already-rooted Retroid Pocket Nova, Android 13 / Magisk tested above; rear M buttons producing their original Default-mode codes. No PC, ADB, or additional remapping application is required to install the ZIP using Magisk. **This module is Nova-specific; don't flash it on other Retroid models.** Back up your existing setup and keep access to Magisk before experimenting.

### How it works

The Nova presents an Xbox Wireless Controller (**vendor/product 2022:3002**) to Android.

| Physical button | Original Linux event in Retroid Default mode | Android output with module |
| --- | --- | --- |
| **M1** | `BTN_C` (306) | `BUTTON_L2` plus full-range L2 analog trigger |
| **M2** | `BTN_Z` (309) | `BUTTON_R2` plus full-range R2 analog trigger |

A device-specific `Vendor_2022_Product_3002.kl` maps keycodes 306/309 to `BUTTON_L2`/`BUTTON_R2` while preserving the Nova's other mappings. A small native **root boot service** watches the original controller and injects full pressure (32767) or release (0) into its existing `ABS_BRAKE`/`ABS_GAS` axes. The key layout exposes these as Android's `LTRIGGER`/`RTRIGGER`. The original controller identity is retained. The changes are *systemless*—no controller firmware or stock partitions are flashed.

Because M1/M2 are physical digital buttons, the resulting triggers have no variable pressure (only 0% or 100%).

### Disable / restore M1 and M2

To use the rear buttons for other purposes, open **Magisk → Modules**, disable **Nova M1 M2 Physical Trigger Replacement**, and **reboot**. Then remap M1/M2 normally using Retroid settings. To restore this fix, set both back to **Default**, re-enable the module in Magisk, and reboot. You can also uninstall the module entirely in Magisk and reboot.

Changing Retroid's built-in M-button settings while the module is enabled is *not* the supported configuration and may cause conflicting input. Retroid's own keypad tester may continue showing `M1`/`M2` even while apps see standard L2/R2.

### Troubleshooting and device compatibility

- If the buttons still do not work after reboot, verify both are set to **Default** and the Magisk module is enabled.
- With root ADB, inspect `/data/adb/modules/nova_m1m2_triggers/bridge.log` to diagnose the boot service.
- This v3 package was built for the **Nova** and its controller identity **2022:3002**; scan codes and firmware behavior may differ on other revisions/devices.
- V1/V2 test builds did not work. **Use v3**.
- No guarantee of compatibility with every Android game; tested on one Nova with GameNative and an independent Android controller tester.

### Verification of the tested build

The v3 temporary native test recorded **28 M1 events, 26 M2 events, 28 L2-axis writes, 26 R2-axis writes, and zero reported errors**. Magisk accepted the module; after reboot both applications recognized the triggers.

SHA-256 of the **Magisk-installable ZIP**:

```
f6302eb58537a7d5a4ba19c42bd28fbc8e1da047c994cf1fcf7bb03a8093ebb1
```

The matching full PC diagnostic/installer bundle has SHA-256 `bcafff208e21af7b7a62d27381fc2da7edf1d87915a7af23bae74828b5c53776` (not the Magisk-installable ZIP).

## Source and licensing

The ARM64 helper source, boot service, Magisk metadata and device-specific key layout are in [source/](source/). The helper and module logic are MIT licensed. The key-layout file derives from Android's `Generic.kl` and retains its Apache 2.0 header. No root or firmware images are distributed.

**Disclaimer:** Community device modification. Install at your own risk; keep a known-good backup and a way to disable Magisk modules if your device behaves unexpectedly.
