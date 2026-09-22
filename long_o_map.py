import dataclasses
import sqlite3

import cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib.pyplot as plt
import numpy as np

# Order for map legend
vowel_order = ["ɑ", "ɔ", "ǫ", "o", "ọ", "ų", "u"]

low_mid_to_high_mid = "ɔː→oː, low-mid to high-mid"
low_mid_to_near_high = "ɔː→ọː~ųː, low-mid to near-high"
high_mid_to_high = "oː→uː, high-mid to high"
mid_to_near_high = "ǫː→ųː, mid to near-high"
no_change = "No change in vowel height"
lowered = "Lowered"
high_mid_to_near_high = "oː→ọː~ųː, high-mid to near-high"
near_high_to_high = "ọː~ųː→uː, near-high to high"
mid_to_high_mid = "ǫː→oː, mid to high-mid"


def get_vowel_label(vowel: str) -> str:
    if "ɑ" in vowel or "ɑ̃" in vowel:
        return "ɑ"
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


@dataclasses.dataclass
class Point:
    label: str
    marker: str
    colour: np.ndarray

    @classmethod
    def from_rgb_int(cls, label, marker, colour: tuple[int, int, int]):
        return cls(label, marker, [c / 255.0 for c in colour])


def vowel_change_point(vowel_change: str) -> Point:
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
        return Point.from_rgb_int(no_change, "o", other_colour)

    if vowel_change in ("ɔː→oː", "ɔː→o", "ɔː→õː"):
        return Point.from_rgb_int(low_mid_to_high_mid, "o", low_mid_colour)

    if vowel_change in ("ɔː→ọː", "ɔː→ųː"):
        return Point.from_rgb_int(low_mid_to_near_high, "^", low_mid_colour)

    if vowel_change in ("oː→ũː", "oː→uː"):
        return Point.from_rgb_int(high_mid_to_high, "o", high_mid_colour)

    if vowel_change == "ǫː→ųː":
        return Point.from_rgb_int(mid_to_near_high, "^", high_mid_colour)

    if vowel_change in ("oː→ɔː", "oː→ǫː", "oː→ǫ̃ː", "ųː→oː"):
        return Point.from_rgb_int(lowered, "^", other_colour)

    if vowel_change in ("oː→ọː", "oː→ųː"):
        return Point.from_rgb_int(high_mid_to_near_high, "o", slight_raise_colour)

    if vowel_change in ("ųː→u", "ọː→uː"):
        return Point.from_rgb_int(near_high_to_high, "^", slight_raise_colour)

    if vowel_change == "ǫː→oː":
        return Point.from_rgb_int(mid_to_high_mid, "X", slight_raise_colour)

    raise ValueError(f"Unexpected vowel change: {vowel_change}")


def get_long_lats_and_transcriptions(
    map_titles: list[str],
    categories: list[str] | None = None,
) -> tuple[list[tuple[float, float]], list[str]]:
    con = sqlite3.connect("lasid.db")
    cur = con.cursor()

    query = (
        "select transcription, survey_point_id "
        "from map_point "
        "where map_id = (select id from map where title"
    )

    if len(map_titles) == 1:
        query += f' = "{map_titles[0]}") '
    else:
        map_titles = [f'"{t}"' for t in map_titles]
        map_titles_str = ",".join(map_titles)
        query += f" in ({map_titles_str})) "

    if categories is not None:
        if len(categories) == 1:
            query += f'and category = "{categories[0]}";'
        else:
            categories = [f'"{c}"' for c in categories]
            cat_str = ",".join(categories)
            query += f"and category in ({cat_str});"
    else:
        query += ";"
    print(query)

    results = cur.execute(query).fetchall()

    long_lats = [
        cur.execute(
            "select lon, lat "
            "from townland "
            f"where survey_point_id = {survey_point_id};"
        ).fetchall()
        for _, survey_point_id in results
    ]
    mean_long_lats = [
        (
            np.mean([lat for lat, _ in survey_point]),
            np.mean([long for _, long in survey_point]),
        )
        for survey_point in long_lats
    ]

    return mean_long_lats, [r[0] for r in results]


def make_map(
    long_lats: list[tuple[float, float]],
    points: list[Point],
    basename: str,
    legend_order: list[str],
):
    fig = plt.figure(frameon=False)
    ax = fig.add_subplot(1, 1, 1, projection=ccrs.TransverseMercator())
    ax.set_extent([-11.0, -3.1, 51.3, 59], crs=ccrs.PlateCarree())

    for (long, lat), p in zip(long_lats, points):
        ax.scatter(
            long,
            lat,
            transform=ccrs.PlateCarree(),
            color=p.colour,
            s=6.0,
            marker=p.marker,
            label=p.label,
            edgecolors="k",
            linewidth=0.1,
        )

    ax.add_feature(cfeature.LAND)
    ax.add_feature(cfeature.LAKES, alpha=0.5)
    ax.add_feature(cfeature.RIVERS)

    # Note when generating SVGs this doubles size, hence just setting background
    # ax.add_feature(cfeature.OCEAN)
    ax.set_facecolor([151 / 255.0, 182 / 255.0, 225 / 255.0])

    # Avoid duplicate entries in legend
    handles, labels = ax.get_legend_handles_labels()
    handle_map = dict(zip(labels, handles))
    handles = [handle_map[lab] for lab in legend_order if lab in labels]

    legend_order = [lab for lab in legend_order if lab in labels]
    ax.legend(handles, legend_order, fontsize=3.5, loc="upper left")

    fig.savefig(f"{basename}.svg")


def map_first_vowel_after_initial_consonant(lasid_map_title, basename, categories=None):
    long_lats, trans = get_long_lats_and_transcriptions(
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
        Point(label, "o", cmap(colour_span.index(v_i) / highest_vowel_idx))
        for label, v_i in zip(vowel_labels, vowel_indices)
    ]
    make_map(long_lats, points, basename, vowel_order)

    return dict(zip(long_lats, vowels))


if __name__ == "__main__":
    bó = map_first_vowel_after_initial_consonant(["cow"], "bó", categories=["bó"])
    móna = map_first_vowel_after_initial_consonant(["turf gen. sg."], "mónadh")

    vowel_changes = []
    long_lats = bó.keys() & móna.keys()
    for ll in long_lats:
        bv = bó[ll]
        mv = móna[ll]
        if not bv or not mv:
            continue
        if bv == mv:
            vowel_changes.append(mv)
        else:
            vowel_changes.append(f"{bv}→{mv}")

    vowel_change_points = [vowel_change_point(vc) for vc in vowel_changes]
    make_map(
        long_lats,
        vowel_change_points,
        "vowel_changes",
        vowel_change_order,
    )

    rómhar = map_first_vowel_after_initial_consonant(
        ["digging VN"], "rómhar", categories=["rómhar"]
    )
    tórramh = map_first_vowel_after_initial_consonant(
        ["wake", "funeral"], "tórramh", ["tórramh", "tórradh"]
    )
