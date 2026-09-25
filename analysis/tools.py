"""
Analysis tooling

Any identifiers passed to or returned from functions are the display identifiers, not
the internal keys used by the database. For example, for survey point IDs this should be
the name of the survey point in the LASID, e.g. point 83 for Na Cruacha.
"""
import dataclasses
import os
import sqlite3
import statistics

import cartopy.crs as ccrs
import cartopy.feature as cfeature
from matplotlib import patheffects
from matplotlib import pyplot as plt
import numpy as np


def get_mean_long_lat(
    survey_point_id: int,
) -> tuple[float, float]:
    """
    Get mean longitude, latitude for given survey point id

    Args:
        survey_point_id: display survey_point ID
    """
    con = sqlite3.connect(os.path.join(os.path.dirname(__file__), "..", "lasid.db"))
    cur = con.cursor()

    long_lats = cur.execute(
        f"""
        select lon, lat
        from townland
        join survey_point on townland.survey_point_id = survey_point.id
        where survey_point.display_id = "{survey_point_id}";
        """
    ).fetchall()
    con.close()

    return (
        statistics.mean(lat for lat, _ in long_lats),
        statistics.mean(long for _, long in long_lats),
    )


def get_question_prompt_display_id(
    question_prompt: str,
) -> int:
    con = sqlite3.connect(os.path.join(os.path.dirname(__file__), "..", "lasid.db"))
    cur = con.cursor()
    return cur.execute(
        f"select display_id from question where prompt = '{question_prompt}';"
    ).fetchone()[0]


def get_question_response_field(
    question_display_id: int,
    field: str,
) -> list[tuple[str, str]]:
    """
    Get field from `response` table where the question matches the given ID

    Args:
        question_display_id: number of survey question
        field: name of field in `response` table to select

    Returns:
        list of tuples of survey point ID and given field. Not a dict because there
            might be multiple entries for a survey point.
    """
    con = sqlite3.connect(os.path.join(os.path.dirname(__file__), "..", "lasid.db"))
    cur = con.cursor()
    query = (
        f"select survey_point.display_id, response.{field} from response "
        "join survey_point on response.survey_point_id = survey_point.id "
        "join question on response.question_id = question.id "
        f"where question.display_id = {question_display_id}"
    )
    return cur.execute(query).fetchall()


def get_survey_points_matching_category(
    categories: list[str],
) -> list[tuple[str, str, str]]:
    """
    Get list of (survey pt, word category, map title) where category matches those given
    """
    con = sqlite3.connect(os.path.join(os.path.dirname(__file__), "..", "lasid.db"))
    cur = con.cursor()

    if len(categories) == 1:
        cat_query = f'= "{categories[0]}"'
    else:
        categories = [f'"{c}"' for c in categories]
        cat_str = ",".join(categories)
        cat_query = f"in ({cat_str})"

    return cur.execute(
        f"""
        select survey_point.display_id, map_point.category, map.title from map_point
        join map on map_point.map_id = map.id
        join survey_point on map_point.survey_point_id = survey_point.id
        where category {cat_query}
        ;
        """
    ).fetchall()


def get_map_point_field(
    map_titles: list[str],
    field: str,
    categories: list[str] | None = None,
) -> list[tuple[str, str]]:
    """
    Get field from `map_point` table matching given criteria

    Args:
        map_titles: list of map titles to match
        field: field to select from `map_point` table
        categories: optional list of word categories to filter on. If none are given
            then no filtering on word category is applied.

    Returns:
        list of tuples of survey point ID and given field. Not a dict because there
            might be multiple entries for a survey point.
    """
    con = sqlite3.connect(os.path.join(os.path.dirname(__file__), "..", "lasid.db"))
    cur = con.cursor()
    query = (
        f"select survey_point.display_id, map_point.{field} from map_point "
        "join map on map_point.map_id = map.id "
        "join survey_point on map_point.survey_point_id = survey_point.id "
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

    results = cur.execute(query).fetchall()
    con.close()
    return results


@dataclasses.dataclass
class MapPoint:
    label: str
    marker: str
    colour: np.ndarray

    @classmethod
    def from_rgb_int(cls, label, marker, colour: tuple[int, int, int]):
        return cls(label, marker, [c / 255.0 for c in colour])


def make_scatter_map(
    long_lats: list[tuple[float, float]],
    points: list[MapPoint],
    basename: str,
    legend_order: list[str],
    title: str,
):
    """
    Plot and save a scatter plot map to SVG

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


def make_text_map(
    long_lats: list[tuple[float, float]],
    texts: list[str],
    colours: list[np.ndarray],
    basename: str,
    title: str,
):
    """
    Plot and save text map to SVG

    Args:
        long_lats: list of decimal longitude and latitude pairs
        texts: text to be displayed at each corresponding point in `long_lats`
        colour_maps: map of text to RGBA colour
        basename: basename of SVG file
        title: figure title, shown in image
    """
    fig = plt.figure(frameon=False)
    ax = fig.add_subplot(1, 1, 1, projection=ccrs.TransverseMercator())
    ax.set_extent([-11.0, -3.1, 51.3, 59], crs=ccrs.PlateCarree())

    for (long, lat), t, col in zip(long_lats, texts, colours):
        ax.text(
            long,
            lat,
            t,
            transform=ccrs.PlateCarree(),
            color=col,
            fontsize=2.5,
            fontweight="bold",
            path_effects=[patheffects.Stroke(linewidth=0.075, foreground="k")],
        )

    ax.add_feature(cfeature.LAND)
    ax.add_feature(cfeature.LAKES, alpha=0.5)
    ax.add_feature(cfeature.RIVERS)

    # Note when generating SVGs this doubles size, hence just setting background
    # ax.add_feature(cfeature.OCEAN)
    ax.set_facecolor([151 / 255.0, 182 / 255.0, 225 / 255.0])

    ax.set_title(title, fontsize=6, y=0.92)

    fig.savefig(f"{basename}.svg", bbox_inches="tight")
