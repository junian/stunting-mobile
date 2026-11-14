"""Generate the KidScale brand illustration and launcher artwork.

The art is drawn at 4x and downsampled so it stays crisp at every Android
launcher density. Run with the bundled Python (Pillow required):

    python3 tool/generate_brand_art.py
"""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageColor, ImageDraw, ImageFilter

S = 4  # supersampling factor
ROOT = Path(__file__).resolve().parent.parent
IMAGES = ROOT / "images"

# Brand palette
BLUE = "#3E66EB"
BLUE_LIGHT = "#6F93FF"
MINT = "#2EC4B6"
MINT_DARK = "#139C7E"
MINT_LIGHT = "#BFF3E8"
INK = "#22314F"
SKIN = "#F6C6A4"
SKIN_SHADOW = "#E9AE8C"
CORAL = "#FF9077"
WHITE = "#FFFFFF"
STRING = "#5C6985"
BG_TOP = (243, 249, 255)
BG_BOTTOM = (224, 250, 242)


def P(x: float, y: float) -> tuple[int, int]:
    return int(round(x * S)), int(round(y * S))


def circle(draw, x, y, r, fill, outline=None, width=0):
    draw.ellipse(
        [P(x - r, y - r), P(x + r, y + r)],
        fill=fill,
        outline=outline,
        width=int(width * S),
    )


def ellipse(draw, box, fill, outline=None, width=0):
    draw.ellipse(
        [P(box[0], box[1]), P(box[2], box[3])],
        fill=fill,
        outline=outline,
        width=int(width * S),
    )


def rrect(draw, box, radius, fill):
    draw.rounded_rectangle(
        [P(box[0], box[1]), P(box[2], box[3])],
        radius=int(radius * S),
        fill=fill,
    )


def poly(draw, points, fill):
    draw.polygon([P(x, y) for x, y in points], fill=fill)


def line(draw, points, width, fill, joint="curve"):
    draw.line(
        [P(x, y) for x, y in points],
        fill=fill,
        width=int(width * S),
        joint=joint,
    )
    for x, y in (points[0], points[-1]):
        circle(draw, x, y, width / 2, fill)


def curve_points(p0, p1, p2, steps=64):
    out = []
    for i in range(steps + 1):
        t = i / steps
        x = (1 - t) ** 2 * p0[0] + 2 * (1 - t) * t * p1[0] + t * t * p2[0]
        y = (1 - t) ** 2 * p0[1] + 2 * (1 - t) * t * p1[1] + t * t * p2[1]
        out.append((x, y))
    return out


def gradient_background(size: int) -> Image.Image:
    img = Image.new("RGBA", (1, size))
    for y in range(size):
        t = y / max(size - 1, 1)
        color = tuple(
            int(BG_TOP[i] * (1 - t) + BG_BOTTOM[i] * t) for i in range(3)
        ) + (255,)
        img.putpixel((0, y), color)
    return img.resize((size, size))


def star(draw, x, y, size, fill, alpha=255):
    # A soft four-point sparkle assembled from two thin diamonds.
    color = (*ImageColor.getrgb(fill), alpha)
    long = size
    short = size * 0.28
    poly(
        draw,
        [
            (x, y - long),
            (x + short, y - short),
            (x + long, y),
            (x + short, y + short),
            (x, y + long),
            (x - short, y + short),
            (x - long, y),
            (x - short, y - short),
        ],
        color,
    )


def draw_scene(size: int, with_background: bool) -> Image.Image:
    """Draw the kid + growth balloon at high resolution."""
    canvas = size * S
    img = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    if with_background:
        img.alpha_composite(gradient_background(canvas))

        # Quiet decorative shapes keep the icon lively without adding noise.
        decor = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
        dd = ImageDraw.Draw(decor)
        circle(dd, 170, 190, 260, (255, 255, 255, 55))
        circle(dd, 900, 810, 300, (255, 255, 255, 45))
        circle(dd, 820, 150, 90, (191, 243, 232, 80))
        circle(dd, 170, 870, 70, (220, 233, 255, 95))
        img.alpha_composite(decor)

    draw = ImageDraw.Draw(img)

    # ----------------------------- balloon string ---------------------------
    string_points = curve_points((500, 620), (600, 574), (700, 566), steps=80)
    line(draw, string_points, 4.5, STRING)

    # ----------------------------- balloon ----------------------------------
    balloon_box = (515, 150, 885, 545)
    # soft shadow under the balloon
    shadow = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    ellipse(sd, (535, 500, 865, 590), (20, 80, 90, 45))
    shadow = shadow.filter(ImageFilter.GaussianBlur(18 * S))
    img.alpha_composite(shadow)

    # balloon knot
    poly(draw, [(700, 532), (676, 574), (724, 574)], MINT_DARK)
    circle(draw, 700, 536, 10, MINT_DARK)

    # balloon body with a vertical gradient
    balloon_mask = Image.new("L", (canvas, canvas), 0)
    ImageDraw.Draw(balloon_mask).ellipse(
        [P(balloon_box[0], balloon_box[1]), P(balloon_box[2], balloon_box[3])],
        fill=255,
    )
    grad = Image.new("RGBA", (1, canvas))
    top = (74, 215, 198)
    bottom = (17, 158, 128)
    for y in range(canvas):
        t = y / max(canvas - 1, 1)
        color = tuple(int(top[i] * (1 - t) + bottom[i] * t) for i in range(3)) + (255,)
        grad.putpixel((0, y), color)
    grad = grad.resize((canvas, canvas))
    balloon_layer = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    balloon_layer.paste(grad, (0, 0), balloon_mask)
    img.alpha_composite(balloon_layer)

    # balloon shine
    ellipse(draw, (560, 205, 655, 305), '#8FE8DA')
    circle(draw, 805, 460, 22, '#8FE8DA')

    # ----------------------------- growth chart -----------------------------
    chart = [(585, 440), (645, 382), (700, 405), (800, 282)]
    line(draw, chart, 19, WHITE)
    for x, y in chart[:-1]:
        circle(draw, x, y, 11, WHITE)

    # arrow tip
    tip = chart[-1]
    prev = chart[-2]
    dx, dy = tip[0] - prev[0], tip[1] - prev[1]
    length = math.hypot(dx, dy)
    ux, uy = dx / length, dy / length
    base = (tip[0] - ux * 44, tip[1] - uy * 44)
    perp = (-uy, ux)
    poly(
        draw,
        [
            tip,
            (base[0] + perp[0] * 24, base[1] + perp[1] * 24),
            (base[0] - perp[0] * 24, base[1] - perp[1] * 24),
        ],
        WHITE,
    )

    # ----------------------------- kid --------------------------------------
    # ground shadow
    shadow = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    ellipse(sd, (250, 878, 520, 936), (20, 45, 90, 60))
    shadow = shadow.filter(ImageFilter.GaussianBlur(16 * S))
    img.alpha_composite(shadow)

    # legs + shoes
    rrect(draw, (305, 752, 350, 900), 23, SKIN)
    rrect(draw, (386, 752, 431, 900), 23, SKIN)
    rrect(draw, (272, 870, 354, 922), 23, MINT_DARK)
    rrect(draw, (382, 870, 464, 922), 23, MINT_DARK)
    rrect(draw, (272, 900, 354, 924), 12, MINT)
    rrect(draw, (382, 900, 464, 924), 12, MINT)

    # shorts
    rrect(draw, (286, 748, 440, 846), 34, INK)

    # torso
    rrect(draw, (278, 638, 444, 790), 58, BLUE)
    # neckline
    circle(draw, 361, 654, 15, MINT_LIGHT)
    # neck
    rrect(draw, (342, 594, 382, 658), 17, SKIN)

    # far arm (viewer left)
    line(draw, [(292, 684), (252, 744), (238, 770)], 36, SKIN)
    circle(draw, 238, 770, 20, SKIN)
    # sleeve
    line(draw, [(292, 684), (278, 706)], 48, BLUE)

    # raised arm (viewer right), holding the string
    line(draw, [(424, 682), (470, 650), (500, 624)], 36, SKIN)
    circle(draw, 500, 620, 23, SKIN)
    # sleeve
    line(draw, [(424, 682), (446, 662)], 50, BLUE)
    # finger crease
    line(draw, [(489, 610), (511, 610)], 4, SKIN_SHADOW)

    # head
    circle(draw, 356, 522, 106, INK)           # hair back
    circle(draw, 368, 542, 94, SKIN)           # face
    circle(draw, 455, 566, 15, SKIN)           # ear
    circle(draw, 455, 566, 7, SKIN_SHADOW)     # ear detail

    # hair fringe and tuft
    draw.pieslice(
        [P(274, 430), P(458, 552)],
        start=180,
        end=360,
        fill=INK,
    )
    circle(draw, 318, 436, 26, INK)
    circle(draw, 352, 426, 23, INK)
    circle(draw, 386, 442, 19, INK)
    # small curl over the forehead
    circle(draw, 415, 476, 19, INK)

    # eyebrows, angled up toward the balloon
    line(draw, [(326, 498), (351, 490)], 6, INK)
    line(draw, [(388, 490), (414, 482)], 6, INK)

    # eyes looking up and to the right
    ellipse(draw, (333, 510, 356, 540), INK)
    ellipse(draw, (392, 505, 415, 535), INK)
    circle(draw, 349, 521, 4.5, WHITE)
    circle(draw, 408, 516, 4.5, WHITE)

    # cheeks
    circle(draw, 321, 576, 17, '#F2BEA6')
    circle(draw, 435, 570, 15, '#F2BEA6')

    # nose
    line(draw, [(374, 552), (382, 557), (374, 560)], 3.5, SKIN_SHADOW)

    # smile
    draw.arc(
        [P(342, 540), P(408, 608)],
        start=18,
        end=162,
        fill=INK,
        width=int(7 * S),
    )
    # ----------------------------- accents ----------------------------------
    star(draw, 875, 650, 22, MINT_DARK, 200)
    star(draw, 235, 350, 15, BLUE, 140)

    return img.resize((size, size), Image.LANCZOS)


def font(path: str, size: int):
    from PIL import ImageFont

    return ImageFont.truetype(str(ROOT / path), size)


def build_lockup(mark: Image.Image) -> Image.Image:
    # The lockup uses the same illustration plus the two-tone wordmark.
    W, H = 900, 1040
    canvas = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    art = mark.resize((760, 760), Image.LANCZOS)
    canvas.alpha_composite(art, (70, 0))

    draw = ImageDraw.Draw(canvas)
    bold = font("assets/fonts/PlusJakartaSans-ExtraBold.ttf", 132)
    kid = "Kid"
    scale = "Scale"
    kid_w = draw.textlength(kid, font=bold)
    scale_w = draw.textlength(scale, font=bold)
    total = kid_w + scale_w
    x = (W - total) / 2
    y = 790
    draw.text((x, y), kid, font=bold, fill=BLUE)
    draw.text((x + kid_w, y), scale, font=bold, fill=MINT_DARK)
    return canvas


def main():
    IMAGES.mkdir(exist_ok=True)

    # Transparent illustration for in-app marks. Draw the full design first,
    # then scale, so nothing at the edges is cropped.
    full_art = draw_scene(1024, with_background=False)
    mark = full_art.resize((900, 900), Image.LANCZOS)
    mark.save(IMAGES / "logo_mark.png")

    # Full-bleed app artwork.
    icon_art = draw_scene(1024, with_background=True)
    icon_art.convert("RGB").save(IMAGES / "app_icon.png")

    # Adaptive icon background and foreground.
    gradient_background(1024).convert("RGB").save(IMAGES / "icon_background.png")
    foreground = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    # Keep the character inside the adaptive icon safe zone.
    scaled = full_art.resize((800, 800), Image.LANCZOS)
    foreground.alpha_composite(scaled, ((1024 - 800) // 2, (1024 - 800) // 2))
    foreground.save(IMAGES / "logo_foreground.png")

    # In-app lockup used on Welcome and article fallbacks.
    build_lockup(mark).save(IMAGES / "logo.png")

    print("KidScale artwork written to", IMAGES)


if __name__ == "__main__":
    main()
