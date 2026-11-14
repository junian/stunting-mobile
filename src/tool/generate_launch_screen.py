"""Generate the native Android launch screen artwork.

The image mirrors the Flutter splash (gradient, bubbles, icon tile, wordmark,
tagline and spinner ring) so the hand-off into Flutter is seamless. The version
label is intentionally left to the Flutter splash, which reads it at runtime.
"""
from __future__ import annotations

from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
RES = ROOT / "android/app/src/main/res"
W, H = 1080, 2400
S = 2  # render at 2x and downsample for crisp text/curves

BLUE_DEEP = (49, 87, 213)
BLUE = (62, 123, 234)
MINT = (46, 196, 182)
WHITE = (255, 255, 255)


def gradient() -> Image.Image:
    xs = np.arange(W * S, dtype=np.float32)[None, :] / (W * S)
    ys = np.arange(H * S, dtype=np.float32)[:, None] / (H * S)
    t = np.clip((xs + ys) * 0.5, 0, 1)
    out = np.zeros((H * S, W * S, 3), dtype=np.float32)
    mask = t < 0.5
    u = np.where(mask, t / 0.5, (t - 0.5) / 0.5)
    a = np.array(BLUE_DEEP, dtype=np.float32)
    b = np.array(BLUE, dtype=np.float32)
    c = np.array(MINT, dtype=np.float32)
    for i in range(3):
        out[..., i] = np.where(mask, a[i] + (b[i] - a[i]) * u, b[i] + (c[i] - b[i]) * u)
    return Image.fromarray(out.clip(0, 255).astype(np.uint8), "RGB")


def circle_overlay(base: Image.Image, cx, cy, r, color):
    layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.ellipse([(cx - r) * S, (cy - r) * S, (cx + r) * S, (cy + r) * S], fill=color)
    base.alpha_composite(layer) if base.mode == "RGBA" else base.paste(layer, (0, 0), layer)


def font(name: str, size: int):
    return ImageFont.truetype(str(ROOT / "assets/fonts" / name), size * S)


def tracked_text(draw, text, center_x, y, fnt, fill, tracking=0.0, anchor_center=True):
    widths = [draw.textlength(ch, font=fnt) for ch in text]
    total = sum(widths) + tracking * S * (len(text) - 1)
    x = center_x * S - total / 2 if anchor_center else center_x * S
    for ch, w in zip(text, widths):
        draw.text((x, y * S), ch, font=fnt, fill=fill)
        x += w + tracking * S
    return total


def rounded_icon(size=360, radius=100) -> Image.Image:
    src = Image.open(ROOT / "images/app_icon.png").convert("RGBA")
    src = src.resize((size * S, size * S), Image.LANCZOS)
    mask = Image.new("L", (size * S, size * S), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        [0, 0, size * S - 1, size * S - 1],
        radius=radius * S,
        fill=255,
    )
    out = Image.new("RGBA", (size * S, size * S), (0, 0, 0, 0))
    out.paste(src, (0, 0), mask)
    return out


def make(locale: str) -> Image.Image:
    base = gradient().convert("RGBA")

    # Same bubbles as the Flutter splash.
    circle_overlay(base, 972, 162, 486, (255, 255, 255, 20))
    circle_overlay(base, 162, 2166, 594, (255, 255, 255, 26))
    circle_overlay(base, 143, 541, 13, (255, 255, 255, 41))
    circle_overlay(base, 901, 774, 6, (255, 255, 255, 56))

    # Icon tile with a soft drop shadow.
    icon = rounded_icon()
    icon_top = 690
    icon_size = 360
    shadow = Image.new("RGBA", base.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle(
        [
            540 * S - 180 * S,
            (icon_top + 24) * S,
            540 * S + 180 * S,
            (icon_top + icon_size + 24) * S,
        ],
        radius=100 * S,
        fill=(3, 18, 51, 120),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(50 * S))
    base.alpha_composite(shadow)
    base.alpha_composite(icon, (540 * S - 180 * S, icon_top * S))

    draw = ImageDraw.Draw(base)
    wordmark = font("PlusJakartaSans-ExtraBold.ttf", 78)
    tracked_text(draw, "KidScale", 540, 1157, wordmark, WHITE, tracking=3.2)

    tagline = font("PlusJakartaSans-Medium.ttf", 34)
    tag = (
        "Tumbuh kembang sehat untuk si kecil"
        if locale == "in"
        else "Healthy growth for happy little ones"
    )
    tracked_text(draw, tag, 540, 1268, tagline, (255, 255, 255, 210))

    # Static spinner ring so the transition to Flutter's spinner is seamless.
    ring = Image.new("RGBA", base.size, (0, 0, 0, 0))
    rd = ImageDraw.Draw(ring)
    rd.ellipse(
        [(540 - 34) * S, (2080 - 34) * S, (540 + 34) * S, (2080 + 34) * S],
        outline=(255, 255, 255, 46),
        width=6 * S,
    )
    rd.arc(
        [(540 - 34) * S, (2080 - 34) * S, (540 + 34) * S, (2080 + 34) * S],
        start=-90,
        end=160,
        fill=(255, 255, 255, 225),
        width=6 * S,
    )
    base.alpha_composite(ring)

    return base.convert("RGB").resize((W, H), Image.LANCZOS)


def main():
    out_en = RES / "drawable-nodpi/launch_screen.png"
    out_id = RES / "drawable-in-nodpi/launch_screen.png"
    out_en.parent.mkdir(parents=True, exist_ok=True)
    out_id.parent.mkdir(parents=True, exist_ok=True)
    make("en").save(out_en, optimize=True)
    make("in").save(out_id, optimize=True)
    print("Launcher screen written:", out_en, out_id)


if __name__ == "__main__":
    main()
