import sqlite3
import statistics

import cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib.pyplot as plt

# Order for map legend
vowel_order = ["ɔ", "ǫ", "o", "ọ", "ų", "u"]

low_mid_to_high_mid = "ɔː→oː, low-mid to high-mid"
low_mid_to_near_high = "ɔː→ọː~ųː, low-mid to near-high"
high_mid_to_high = "oː→uː, high-mid to high"
mid_to_near_high = "ǫː→ųː, mid to near-high"
no_change = "No change in vowel height"
lowered = "Lowered"
high_mid_to_near_high = "oː→ọː~ųː, high-mid to near-high"
near_high_to_high = "ọː~ųː→uː, near-high to high"
mid_to_high_mid = "ǫː→oː, mid to high-mid"

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


def vowel_colour_shape_label(vowel: str) -> tuple[tuple[int, int, int], str, str]:
    if "ɔ" in vowel or "ɔ̃" in vowel:
        return ((0, 61, 92), "o", "ɔ")
    if "ǫ" in vowel or "ǫ̃" in vowel:
        return ((61, 75, 124), "o", "ǫ")
    if "o" in vowel or "õ" in vowel:
        return ((117, 85, 143), "o", "o")
    if "ọ" in vowel or "ọ̃" in vowel:
        return ((171, 93, 146), "o", "ọ")
    if "u" in vowel or "ũ" in vowel:
        return ((215, 108, 134), "o", "u")
    if "ų" in vowel or "ų̃" in vowel:
        return ((242, 135, 114), "o", "ų")
    raise ValueError(f"Vowel not recognised: {vowel}")


def vowel_change_colour_shape_label(
    vowel_change: str,
) -> tuple[tuple[int, int, int], str, str]:
    other = (220, 220, 220)
    low_mid = (27, 158, 119)
    high_mid = (217, 95, 2)
    slight_raise = (117, 112, 179)

    if "→" not in vowel_change or vowel_change in (
        "ɔ̃ː→ɔː",
        "oː→õː",
        "oː→o",
        "oː→õː",
        "ǫː→ǫ̃ː",
        "oː→õː",
    ):
        return (other, "o", no_change)

    if vowel_change in ("ɔː→oː", "ɔː→o", "ɔː→õː"):
        return (low_mid, "o", low_mid_to_high_mid)

    if vowel_change in ("ɔː→ọː", "ɔː→ųː"):
        return (low_mid, "^", low_mid_to_near_high)

    if vowel_change in ("oː→ũː", "oː→uː"):
        return (high_mid, "o", high_mid_to_high)

    if vowel_change == "ǫː→ųː":
        return (high_mid, "^", mid_to_near_high)

    if vowel_change in ("oː→ɔː", "oː→ǫː", "oː→ǫ̃ː"):
        return (other, "^", lowered)

    if vowel_change in ("oː→ọː", "oː→ųː"):
        return (slight_raise, "o", high_mid_to_near_high)

    if vowel_change in ("ųː→u", "ọː→uː"):
        return (slight_raise, "^", near_high_to_high)

    if vowel_change == "ǫː→oː":
        return (slight_raise, "X", mid_to_high_mid)

    raise ValueError(f"Unexpected vowel change: {vowel_change}")


def get_long_lats_and_transcriptions(
    map_title: str,
) -> tuple[list[tuple[float, float]], list[str]]:
    con = sqlite3.connect("lasid.db")
    cur = con.cursor()

    results = cur.execute(
        "select transcription, survey_point_id "
        "from map_point "
        f"where map_id = (select id from map where title='{map_title}') "
        "and transcription is not null;"
    ).fetchall()

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
            statistics.mean(lat for lat, _ in survey_point),
            statistics.mean(long for _, long in survey_point),
        )
        for survey_point in long_lats
    ]

    return mean_long_lats, [r[0] for r in results]


def make_map(
    long_lats: list[tuple[float, float]],
    data: list[str],
    basename: str,
    data_colour_shape_label,
    legend_order: list[str],
):
    fig = plt.figure(frameon=False)
    ax = fig.add_subplot(1, 1, 1, projection=ccrs.TransverseMercator())
    ax.set_extent([-11.0, -3.1, 51.3, 59], crs=ccrs.PlateCarree())

    for (long, lat), d in zip(long_lats, data):
        colour, shape, label = data_colour_shape_label(d)
        ax.scatter(
            long,
            lat,
            transform=ccrs.PlateCarree(),
            color=[c / 255.0 for c in colour],
            s=6.0,
            marker=shape,
            label=label,
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
    ax.legend(handles, legend_order, fontsize=3.5, loc="upper left")

    fig.savefig(f"{basename}.svg")


def map_first_vowel_after_initial_consonant(lasid_map_title, basename):
    long_lats, trans = get_long_lats_and_transcriptions(lasid_map_title)
    # TODO adapt this so database does not need adjusted for bó
    vowels = [t.split("+")[1] for t in trans]
    make_map(long_lats, vowels, basename, vowel_colour_shape_label, vowel_order)

    return dict(zip(long_lats, vowels))


if __name__ == "__main__":
    bo = map_first_vowel_after_initial_consonant("cow", "bó")
    mona = map_first_vowel_after_initial_consonant("turf gen. sg.", "mónadh")

    vowel_changes = []
    long_lats = bo.keys() & mona.keys()
    for ll in long_lats:
        bv = bo[ll]
        mv = mona[ll]
        if not bv or not mv:
            continue
        if bv == mv:
            vowel_changes.append(mv)
        else:
            vowel_changes.append(f"{bv}→{mv}")

    make_map(
        long_lats,
        vowel_changes,
        "vowel_changes",
        vowel_change_colour_shape_label,
        vowel_change_order,
    )
