import unicodedata

import matplotlib.pyplot as plt

import tools

# Order for map legend
vowel_order = ["ɑ", "ɔ̨", "ɔ", "ǫ", "o", "ọ", "ų", "u"]


def get_vowel_label(vowel: str) -> str:
    """Remove nasalisation diacritic and length markers"""
    normalised = unicodedata.normalize("NFD", vowel)
    return (
        normalised.encode("utf-8")
        .replace(b"\xcc\x83", b"")  # Remove nasalisation diacritic
        .replace(b"\xcb\x90", b"")  # Remove length marker
        .decode()
    )

low_mid_to_high_mid = "ɔ→o, low-mid to high-mid"
low_mid_to_near_high = "ɔ→ọ~ų, low-mid to near-high"
high_mid_to_high = "o→u, high-mid to high"
mid_to_near_high = "ǫ→ų~ọ, mid to near-high"
no_change = "No change in vowel height"
lowered = "Lowered"
high_mid_to_near_high = "o→ọ~ų, high-mid to near-high"
near_high_to_high = "ọ~ų→u, near-high to high"
mid_to_high_mid = "ǫ→o, mid to high-mid"

# Order for map legend
vowel_change_order = [
    low_mid_to_high_mid,
    low_mid_to_near_high,
    high_mid_to_high,
    mid_to_near_high,
    no_change,
    lowered,
    high_mid_to_near_high,
    near_high_to_high,
    mid_to_high_mid,
]


def vowel_change_point(old: str, new: str) -> tools.MapPoint:
    other_colour = (220, 220, 220)
    low_mid_colour = (27, 158, 119)
    high_mid_colour = (217, 95, 2)
    slight_raise_colour = (117, 112, 179)

    if old == new:
        return tools.MapPoint.from_rgb_int(no_change, "o", other_colour)

    if old == "ɔ" and new == "o":
        return tools.MapPoint.from_rgb_int(low_mid_to_high_mid, "o", low_mid_colour)

    if old == "ɔ" and new in ("ọ", "ų"):
        return tools.MapPoint.from_rgb_int(low_mid_to_near_high, "^", low_mid_colour)

    if old == "o" and new == "u":
        return tools.MapPoint.from_rgb_int(high_mid_to_high, "o", high_mid_colour)

    if old == "ǫ" and new in ("ọ", "ų"):
        return tools.MapPoint.from_rgb_int(mid_to_near_high, "^", high_mid_colour)

    if vowel_order.index(new) < vowel_order.index(old):
        return tools.MapPoint.from_rgb_int(lowered, "^", other_colour)

    if old == "o" and new in ("ọ", "ų"):
        return tools.MapPoint.from_rgb_int(
            high_mid_to_near_high, "o", slight_raise_colour
        )

    if old in ("ọ", "ų") and new == "u":
        return tools.MapPoint.from_rgb_int(near_high_to_high, "^", slight_raise_colour)

    if old == "ǫ" and new == "o":
        return tools.MapPoint.from_rgb_int(mid_to_high_mid, "X", slight_raise_colour)

    raise ValueError(f"Unexpected vowel change: {old} to {new}")


def map_first_vowel_after_initial_consonant(
    lasid_map_title,
    basename,
    figure_title,
    categories=None,
):
    long_lats, trans = tools.get_long_lats_and_transcriptions(
        lasid_map_title, categories=categories
    )
    vowels = [t.split("+")[1] for t in trans]
    vowel_labels = [get_vowel_label(v) for v in vowels]
    vowel_indices = [vowel_order.index(v) for v in vowel_labels]

    lowest_vowel_idx = min(vowel_indices)
    highest_vowel_idx = max(vowel_indices)
    colour_span = list(range(lowest_vowel_idx, highest_vowel_idx + 1))
    cmap = plt.get_cmap("plasma")

    points = [
        tools.MapPoint(label, "o", cmap(colour_span.index(v_i) / highest_vowel_idx))
        for label, v_i in zip(vowel_labels, vowel_indices)
    ]
    tools.make_map(long_lats, points, basename, vowel_order, figure_title)

    return dict(zip(long_lats, vowels))


def map_vowel_changes(
    vowels,
    changed_vowels,
    basename,
    title,
):
    long_lats = vowels.keys() & changed_vowels.keys()
    vowel_change_points = []
    for ll in long_lats:
        v = get_vowel_label(vowels[ll])
        c = get_vowel_label(changed_vowels[ll])
        if not v or not c:
            continue
        vowel_change_points.append(vowel_change_point(v, c))
    tools.make_map(
        long_lats,
        vowel_change_points,
        basename,
        vowel_change_order,
        title,
    )


if __name__ == "__main__":
    bó = map_first_vowel_after_initial_consonant(
        ["cow"],
        "bó",
        "vowel in 'bó' ('cow')",
        categories=["bó"],
    )
    móna = map_first_vowel_after_initial_consonant(
        ["turf gen. sg."],
        "mónadh",
        "first vowel in\n'mónadh, móna, móine'\n('turf' gen. sg.)",
    )
    rómhar = map_first_vowel_after_initial_consonant(
        ["digging VN"],
        "rómhar",
        "first vowel in\n'rómhar'\n('digging' v.n.)",
        categories=["rómhar"],
    )
    tórramh = map_first_vowel_after_initial_consonant(
        ["wake", "funeral"],
        "tórramh",
        "first vowel in\n'tórramh, tórradh'\n"
        "('wake' or 'funeral' depending on geography)",
        categories=["tórramh", "tórradh"],
    )

    map_vowel_changes(
        bó,
        móna,
        "vowel_changes_bó_móna",
        "Vowel height in 'bó' vs.\nin first vowel of 'mónadh' etc.",
    )
    map_vowel_changes(
        bó,
        rómhar,
        "vowel_changes_bó_rómhar",
        "Vowel height in 'bó' vs.\nin first vowel of 'rómhar' etc.",
    )
