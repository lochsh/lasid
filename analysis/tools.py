import dataclasses
import sqlite3
import statistics

import cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib.pyplot as plt
import numpy as np


def get_long_lats_and_transcriptions(
    map_titles: list[str],
    categories: list[str] | None = None,
) -> tuple[list[tuple[float, float]], list[str]]:
    """
    Get mean decimal GPS co-ordinates and corresponding transcriptions for given maps

    Args:
        map_titles: list of map titles to retrieve transcriptions for
        categories: optional list of word categories to filter on. If none are given
            then all transcriptions for the given maps are retrieved
    """
    con = sqlite3.connect("lasid.db")
    cur = con.cursor()
    query = (
        "select transcription, survey_point_id from map_point "
        "left join map on map_point.map_id = map.id "
        "where map.title "
    )

    if len(map_titles) == 1:
        query += f' = "{map_titles[0]}" '
    else:
        map_titles = [f'"{t}"' for t in map_titles]
        map_titles_str = ",".join(map_titles)
        query += f" in ({map_titles_str}) "

    if categories is not None:
        if len(categories) == 1:
            query += f'and category = "{categories[0]}"'
        else:
            categories = [f'"{c}"' for c in categories]
            cat_str = ",".join(categories)
            query += f"and category in ({cat_str})"
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
            statistics.mean(lat for lat, _ in survey_point),
            statistics.mean(long for _, long in survey_point),
        )
        for survey_point in long_lats
    ]

    return mean_long_lats, [trans for trans, _ in results]


@dataclasses.dataclass
class MapPoint:
    label: str
    marker: str
    colour: np.ndarray

    @classmethod
    def from_rgb_int(cls, label, marker, colour: tuple[int, int, int]):
        return cls(label, marker, [c / 255.0 for c in colour])


def make_map(
    long_lats: list[tuple[float, float]],
    points: list[MapPoint],
    basename: str,
    legend_order: list[str],
    title: str,
):
    """
    Plot and save a map to SVG

    Args:
        long_lats: list of decimal longitude and latitude pairs
        points: list of `MapPoint` instances to plot
        basename: basename of SVG file
        legend_order: order of the labels in the legend
        title: figure title, shown in image
    """
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
    ax.legend(handles, legend_order, fontsize=3.5, loc=(0.05, 0.6))
    ax.set_title(title, fontsize=6, y=0.92)

    fig.savefig(f"{basename}.svg", bbox_inches="tight")
