import itertools

import seaborn as sns

import tools


def main(
    words: list[str],
    cmap_name: str,
):
    matching = tools.get_survey_points_matching_orthography(words)
    long_lats = [tools.get_mean_long_lat(sid) for sid, _, _ in matching]

    unique_meanings = sorted(set(title for _, _, title in matching))

    cmap = sns.color_palette(cmap_name, len(unique_meanings))
    marker_dict = {c: ["o", "^", "s", "x"][i] for i, c in enumerate(words)}

    legend_order = sorted(
        set(
            f"{title}: {word}"
            for title, word in itertools.product(
                [title for _, _, title in matching], words
            )
        )
    )

    points = [
        tools.MapPoint(
            f"{title}: {word}", marker_dict[word], cmap[unique_meanings.index(title)]
        )
        for _, word, title in matching
    ]

    tools.make_scatter_map(
        long_lats,
        points,
        "_".join(words) + "_usage",
        legend_order,
        "Meaning of " + ", ".join(words),
    )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("-word", action="append")
    parser.add_argument("--cmap", type=str, default="Dark2")

    args = parser.parse_args()
    main(args.word, args.cmap)
