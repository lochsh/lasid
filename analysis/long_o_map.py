import matplotlib.pyplot as plt

import tools

# Order for map legend
vowel_order = ["ɑ", "ɔ̨", "ɔ", "ǫ", "o", "ọ", "ų", "u"]


def get_vowel_label(vowel: str) -> str:
    if "ɑ" in vowel or "ɑ̃" in vowel:
        return "ɑ"
    if "ɔ̨" in vowel or "ɔ̨̃" in vowel:
        return "ɔ̨"
    if "ɔ" in vowel or "ɔ̃" in vowel:
        return "ɔ"
    if "ǫ" in vowel or "ǫ̃" in vowel:
        return "ǫ"
    if "o" in vowel or "õ" in vowel:
        return "o"
    if "ọ" in vowel or "ọ̃" in vowel:
        return "ọ"
    if "u" in vowel or "ũ" in vowel:
        return "u"
    if "ų" in vowel or "ų̃" in vowel:
        return "ų"
    raise ValueError(f"Vowel not recognised: {vowel}")


low_mid_to_high_mid = "ɔː→oː, low-mid to high-mid"
low_mid_to_near_high = "ɔː→ọː~ųː, low-mid to near-high"
high_mid_to_high = "oː→uː, high-mid to high"
mid_to_near_high = "ǫː→ųː~ọː, mid to near-high"
no_change = "No change in vowel height"
lowered = "Lowered"
high_mid_to_near_high = "oː→ọː~ųː, high-mid to near-high"
near_high_to_high = "ọː~ųː→uː, near-high to high"
mid_to_high_mid = "ǫː→oː, mid to high-mid"

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


def vowel_change_point(vowel_change: str) -> tools.MapPoint:
    other_colour = (220, 220, 220)
    low_mid_colour = (27, 158, 119)
    high_mid_colour = (217, 95, 2)
    slight_raise_colour = (117, 112, 179)

    if "→" not in vowel_change or vowel_change in (
        "ɔ̃ː→ɔː",
        "oː→õː",
        "oː→o",
        "oː→õː",
        "ǫː→ǫ̃ː",
        "oː→õː",
    ):
        return tools.MapPoint.from_rgb_int(no_change, "o", other_colour)

    if vowel_change in ("ɔː→oː", "ɔː→o", "ɔː→õː", "ɔ̃ː→õː"):
        return tools.MapPoint.from_rgb_int(low_mid_to_high_mid, "o", low_mid_colour)

    if vowel_change in ("ɔː→ọː", "ɔː→ųː"):
        return tools.MapPoint.from_rgb_int(low_mid_to_near_high, "^", low_mid_colour)

    if vowel_change in ("oː→ũː", "oː→uː", "oː→ũː", "oː→ũ"):
        return tools.MapPoint.from_rgb_int(high_mid_to_high, "o", high_mid_colour)

    if vowel_change in ("ǫː→ųː", "ǫː→ọː"):
        return tools.MapPoint.from_rgb_int(mid_to_near_high, "^", high_mid_colour)

    if vowel_change in (
        "oː→ɔː",
        "oː→ǫː",
        "oː→ǫ̃ː",
        "ųː→oː",
        "oː→ɔ̨̃ː",
        "oː→ɑː",
        "ọː→oː",
        "oː→ɔ̃ː",
    ):
        return tools.MapPoint.from_rgb_int(lowered, "^", other_colour)

    if vowel_change in ("oː→ọː", "oː→ųː"):
        return tools.MapPoint.from_rgb_int(
            high_mid_to_near_high, "o", slight_raise_colour
        )

    if vowel_change in ("ųː→u", "ọː→uː"):
        return tools.MapPoint.from_rgb_int(near_high_to_high, "^", slight_raise_colour)

    if vowel_change in ("ǫː→oː", "ǫː→õː"):
        return tools.MapPoint.from_rgb_int(mid_to_high_mid, "X", slight_raise_colour)

    raise ValueError(f"Unexpected vowel change: {vowel_change}")


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
    vowel_changes = []
    long_lats = vowels.keys() & changed_vowels.keys()
    for ll in long_lats:
        v = vowels[ll]
        c = changed_vowels[ll]
        if not v or not c:
            continue
        if v == c:
            vowel_changes.append(v)
        else:
            vowel_changes.append(f"{v}→{c}")

    vowel_change_points = [vowel_change_point(vc) for vc in vowel_changes]
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
        "Vowel in 'bó' vs.\nfirst vowel in 'mónadh' etc.",
    )
    map_vowel_changes(
        bó,
        rómhar,
        "vowel_changes_bó_rómhar",
        "Vowel in 'bó' vs.\nfirst vowel in 'rómhar' etc.",
    )
