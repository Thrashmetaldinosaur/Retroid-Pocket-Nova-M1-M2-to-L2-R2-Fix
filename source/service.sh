#!/system/bin/sh
# Nova-only native button-to-axis bridge; doesn't create a virtual controller.
# Works with both the "xbox" (2022:3002) and "retro" (2022:3001) controller styles.
MODDIR=${0%/*}
BIN="$MODDIR/bin/nova_m1m2_native_v3"
LOG="$MODDIR/bridge.log"
case "$(getprop ro.product.model)" in *Nova*|*nova*) ;; *) exit 0 ;; esac
n=0
while [ "$n" -lt 90 ]; do
    n=$((n + 1))
    [ -e "$MODDIR/disable" ] && exit 0
    [ "$(getprop sys.boot_completed)" = 1 ] && break
    sleep 2
done
[ -f "$LOG" ] && mv -f "$LOG" "$MODDIR/bridge.previous.log"
echo "boot $(date)" > "$LOG"
while [ ! -e "$MODDIR/disable" ]; do
    NODE=''
    for p in /sys/class/input/event*/device/name; do
        [ -r "$p" ] || continue
        base=${p%/device/name}
        NAME=$(cat "$p" 2>/dev/null)
        VEN=$(cat "$base/device/id/vendor" 2>/dev/null)
        PROD=$(cat "$base/device/id/product" 2>/dev/null)
        case "$NAME|$VEN|$PROD" in
            'Xbox Wireless Controller|2022|3002'|'Retroid Pocket Controller|2022|3001') ;;
            *) continue ;;
        esac
        NODE="/dev/input/${base##*/}"
        break
    done
    if [ -n "$NODE" ] && [ -c "$NODE" ] && [ -x "$BIN" ]; then
        echo "attached $(date) $NODE" >> "$LOG"
        "$BIN" "$NODE" 0 quiet >> "$LOG" 2>&1
        echo "bridge stopped rc=$? $(date)" >> "$LOG"
    fi
    sleep 3
done
