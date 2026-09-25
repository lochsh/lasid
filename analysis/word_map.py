import seaborn as sns

import tools


def main(
    words: list[tuple[str, str]],
    basename: str,
    title: str,
    cmap_name: str,
):
    words = [(sid, w) for sid, w in words if w]

    long_lats = [tools.get_mean_long_lat(sid) for sid, _ in words]
    unique_words = sorted(set(w for _, w in words))
    cmap = sns.color_palette(cmap_name, len(unique_words))
    colours = [cmap[unique_words.index(w)] for _, w in words]
    tools.make_text_map(long_lats, [w for _, w in words], colours, basename, title)

    points = [tools.MapPoint(w, "o", c) for (_, w), c in zip(words, colours)]
    tools.make_scatter_map(
        long_lats, points, f"{basename}-scatter", unique_words, title
    )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--cmap", type=str, default="Dark2")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--question_prompt", type=str)
    group.add_argument("--map_title", type=str)

    args = parser.parse_args()

    if args.question_prompt:
        question_display_id = tools.get_question_prompt_display_id(args.question_prompt)
        words = tools.get_question_response_field(question_display_id, "category")
        main(
            words,
            args.question_prompt,
            f"Words for {args.question_prompt}",
            args.cmap,
        )
    else:
        words = tools.get_map_point_field([args.map_title], "category")
        main(
            words,
            args.map_title,
            f"Words for {args.map_title}",
            args.cmap,
        )
