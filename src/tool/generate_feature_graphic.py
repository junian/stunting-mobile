"""Builds the 1024x500 Google Play feature graphic from the shipped icon and
real screenshots in docs/img. Run with Pillow available."""
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont, ImageCms

ROOT = Path(__file__).resolve().parent.parent.parent
OUT = ROOT / 'docs/img/play-store-feature-graphic-1024x500.png'
S = 2  # supersampling
W, H = 1024 * S, 500 * S

FONT = ROOT / 'src/assets/fonts'
EXTRA = FONT / 'PlusJakartaSans-ExtraBold.ttf'
BOLD = FONT / 'PlusJakartaSans-Bold.ttf'
SEMI = FONT / 'PlusJakartaSans-SemiBold.ttf'
MEDIUM = FONT / 'PlusJakartaSans-Medium.ttf'
REGULAR = FONT / 'PlusJakartaSans-Regular.ttf'


def f(path, size):
    return ImageFont.truetype(str(path), int(size * S))


def gradient():
    y, x = np.mgrid[0:H, 0:W]
    t = (x / (W - 1) * 0.66 + y / (H - 1) * 0.34).clip(0, 1)
    stops = [(0.0, (35, 65, 190)), (0.52, (62, 124, 234)), (1.0, (46, 196, 182))]
    out = np.zeros((H, W, 3), dtype=np.float32)
    for i in range(len(stops) - 1):
        a, ca = stops[i]
        b, cb = stops[i + 1]
        m = (t >= a) & (t <= b)
        u = ((t[m] - a) / (b - a))[:, None]
        for c in range(3):
            out[m, c] = ca[c] * (1 - u[:, 0]) + cb[c] * u[:, 0]
    return Image.fromarray(out.clip(0, 255).astype(np.uint8), 'RGB').convert('RGBA')


def tracked_text(draw, text, xy, font, fill, tracking=0):
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=font, fill=fill)
        x += draw.textlength(ch, font=font) + tracking * S


def phone(screenshot_path, height, radius=34, bezel=9):
    shot = Image.open(screenshot_path).convert('RGB')
    width = int(round(height * 9 / 16))
    screen_w, screen_h = width - bezel * 2, height - bezel * 2
    screen = shot.resize((screen_w, screen_h), Image.LANCZOS)
    screen_mask = Image.new('L', (screen_w, screen_h), 0)
    ImageDraw.Draw(screen_mask).rounded_rectangle(
        [0, 0, screen_w - 1, screen_h - 1], radius=int(radius - bezel), fill=255
    )

    device = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    d = ImageDraw.Draw(device)
    d.rounded_rectangle(
        [0, 0, width - 1, height - 1], radius=int(radius), fill=(15, 24, 45, 255)
    )
    d.rounded_rectangle(
        [1, 1, width - 2, height - 2],
        radius=int(radius - 1),
        outline=(255, 255, 255, 45),
        width=max(1, int(1.5 * S)),
    )
    device.paste(screen, (bezel, bezel), screen_mask)
    return device


def drop_shadow(size, radius, blur, color=(5, 16, 45, 130), offset=(0, 16)):
    w, h = size
    pad = blur * 3
    shadow = Image.new('RGBA', (w + pad * 2, h + pad * 2), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [pad, pad, pad + w, pad + h], radius=radius, fill=color
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(blur))
    return shadow, (offset[0] - pad, offset[1] - pad)


def rotate(img, angle):
    return img.rotate(angle, expand=True, resample=Image.BICUBIC)


def main():
    base = gradient()
    deco = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(deco)

    glow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse([W * 0.52, -H * 0.35, W * 1.2, H * 1.3], fill=(255, 255, 255, 20))
    gd.ellipse([-W * 0.1, H * 0.55, W * 0.5, H * 1.5], fill=(255, 255, 255, 12))
    glow = glow.filter(ImageFilter.GaussianBlur(40 * S))
    base.alpha_composite(glow)

    for cx, cy, r, col in [
        (0.06, 0.12, 0.055, (255, 255, 255, 16)),
        (0.94, 0.08, 0.14, (255, 255, 255, 13)),
        (0.78, 0.92, 0.09, (17, 188, 173, 50)),
        (0.57, 0.10, 0.018, (255, 255, 255, 45)),
        (0.49, 0.85, 0.011, (255, 255, 255, 65)),
    ]:
        draw.ellipse(
            [(cx * W) - r * W, (cy * H) - r * W, (cx * W) + r * W, (cy * H) + r * W],
            fill=col,
        )

    def sparkle(cx, cy, size, color):
        pts = []
        for i in range(8):
            ang = i * 3.14159265 / 4
            rr = size if i % 2 == 0 else size * 0.22
            pts.append((cx + np.cos(ang) * rr, cy + np.sin(ang) * rr))
        draw.polygon(pts, fill=color)

    sparkle(W * 0.30, H * 0.17, 9 * S, (255, 255, 255, 95))
    sparkle(W * 0.46, H * 0.80, 6 * S, (255, 255, 255, 80))
    sparkle(W * 0.62, H * 0.20, 5 * S, (255, 255, 255, 70))
    base.alpha_composite(deco)

    main_phone = phone(ROOT / 'docs/img/01-home.png', 446 * S)
    growth_phone = phone(ROOT / 'docs/img/03-growth-history.png', 368 * S, radius=30, bezel=8)
    vaccine_phone = phone(ROOT / 'docs/img/05-vaccination-schedule.png', 368 * S, radius=30, bezel=8)

    for asset, pos, angle in [
        (growth_phone, (495 * S, 82 * S), -8),
        (vaccine_phone, (806 * S, 74 * S), 8),
    ]:
        shadow, off = drop_shadow(asset.size, 30 * S, 26 * S, color=(5, 16, 45, 125), offset=(0, 14 * S))
        rot_shadow = rotate(shadow, angle)
        rot_asset = rotate(asset, angle)
        sx = int(pos[0] + (asset.width - rot_shadow.width) / 2 + off[0])
        sy = int(pos[1] + (asset.height - rot_shadow.height) / 2 + off[1])
        base.alpha_composite(rot_shadow, (sx, sy))
        ax = int(pos[0] + (asset.width - rot_asset.width) / 2)
        ay = int(pos[1] + (asset.height - rot_asset.height) / 2)
        base.alpha_composite(rot_asset, (ax, ay))

    mpos = (642 * S, 28 * S)
    shadow, off = drop_shadow(main_phone.size, 34 * S, 30 * S, color=(4, 14, 42, 150), offset=(0, 18 * S))
    base.alpha_composite(shadow, (mpos[0] + off[0], mpos[1] + off[1]))
    base.alpha_composite(main_phone, mpos)

    fg = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(fg)
    icon = Image.open(ROOT / 'docs/img/play-store-app-icon-512.png').convert('RGB')
    tile = 102 * S
    icon_tile = Image.new('RGBA', (tile, tile), (0, 0, 0, 0))
    idraw = ImageDraw.Draw(icon_tile)
    card_shadow = Image.new('RGBA', (tile + 40 * S, tile + 40 * S), (0, 0, 0, 0))
    ImageDraw.Draw(card_shadow).rounded_rectangle(
        [20 * S, 20 * S, 20 * S + tile, 20 * S + tile],
        radius=26 * S,
        fill=(5, 20, 55, 110),
    )
    card_shadow = card_shadow.filter(ImageFilter.GaussianBlur(12 * S))
    base.alpha_composite(card_shadow, (52 * S, 48 * S))
    idraw.rounded_rectangle([0, 0, tile - 1, tile - 1], radius=26 * S, fill=(255, 255, 255, 255))
    icon_size = tile - 12 * S
    icon_small = icon.resize((icon_size, icon_size), Image.LANCZOS)
    icon_mask = Image.new('L', (icon_size, icon_size), 0)
    ImageDraw.Draw(icon_mask).rounded_rectangle(
        [0, 0, icon_size - 1, icon_size - 1], radius=20 * S, fill=255
    )
    icon_tile.paste(icon_small, (6 * S, 6 * S), icon_mask)
    base.alpha_composite(icon_tile, (64 * S, 54 * S))

    tracked_text(draw, 'CHILD GROWTH & IMMUNIZATION', (66 * S, 176 * S), f(MEDIUM, 12.5), (255, 255, 255, 175), tracking=1.6)
    tracked_text(draw, 'KidScale', (63 * S, 198 * S), f(EXTRA, 74), (255, 255, 255, 255), tracking=0.6)
    draw.text((66 * S, 292 * S), 'Healthy growth for happy little ones', font=f(SEMI, 22), fill=(255, 255, 255, 226))

    def pill(x, y, text, icon_kind):
        pad = 14 * S
        font = f(SEMI, 12.5)
        tw = draw.textlength(text, font=font)
        ph = 38 * S
        pw = int(pad * 2 + 18 * S + tw)
        draw.rounded_rectangle(
            [x, y, x + pw, y + ph],
            radius=ph / 2,
            fill=(255, 255, 255, 26),
            outline=(255, 255, 255, 54),
            width=max(1, int(1.2 * S)),
        )
        cx, cy = x + pad + 7 * S, y + ph / 2
        if icon_kind == 'growth':
            draw.line([(cx - 5 * S, cy + 4 * S), (cx - 1 * S, cy - 1 * S), (cx + 3 * S, cy + 2 * S), (cx + 6 * S, cy - 4 * S)], fill=(255, 255, 255, 235), width=max(1, int(2 * S)), joint='curve')
        else:
            draw.rounded_rectangle([cx - 5 * S, cy - 5 * S, cx + 5 * S, cy + 5 * S], radius=2 * S, outline=(255, 255, 255, 235), width=max(1, int(1.8 * S)))
            draw.line([(cx - 1 * S, cy + 4 * S), (cx + 5 * S, cy - 6 * S)], fill=(255, 255, 255, 235), width=max(1, int(1.8 * S)))
        draw.text((x + pad + 18 * S, y + (ph - 12.5 * S * 1.2) / 2 - 1 * S), text, font=font, fill=(255, 255, 255, 238))
        return pw

    x0 = 66 * S
    w1 = pill(x0, 334 * S, 'Growth tracking', 'growth')
    pill(x0 + w1 + 10 * S, 334 * S, 'Vaccine schedule', 'vax')

    draw.text((66 * S, 437 * S), 'Formerly known as STANTAPP', font=f(MEDIUM, 11.5), fill=(255, 255, 255, 170))
    draw.text((66 * S, 456 * S), 'kidscale.juniandev.com', font=f(REGULAR, 10.5), fill=(255, 255, 255, 125))

    base.alpha_composite(fg)
    final = base.resize((1024, 500), Image.LANCZOS).convert('RGB')
    srgb = ImageCms.createProfile('sRGB')
    final.save(OUT, 'PNG', optimize=True, icc_profile=ImageCms.ImageCmsProfile(srgb).tobytes())
    print(OUT, OUT.stat().st_size, final.size, final.mode)


if __name__ == '__main__':
    main()
