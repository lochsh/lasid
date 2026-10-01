import seaborn as sns

import tools


MARKERS = ["o", "^", "s", "X"]


def main(
    words: list[tuple[str, str]],
    basename: str,
    title: str,
    cmap_name: str,
    word_groups: list[list[str]] | None = None,
):
    words = [(sid, w) for sid, w in words if w]
    long_lats = [tools.get_mean_long_lat(sid) for sid, _ in words]
    unique_words = sorted(set(w for _, w in words))

    if word_groups is None:
        word_groups = [[w] for w in unique_words]
    else:
        word_groups = word_groups + [
            [w] for w in unique_words if not any(w in g for g in word_groups)
        ]

    num_groups = len(word_groups)
    cmap = sns.color_palette(cmap_name, num_groups)
    group_idxs = [[w in g for g in word_groups].index(True) for _, w in words]
    colours = [cmap[idx] for idx in group_idxs]
    idx_in_group = [
        word_groups[g_idx].index(w) for g_idx, (_, w) in zip(group_idxs, words)
    ]

    tools.make_text_map(long_lats, [w for _, w in words], colours, basename, title)
    points = [
        tools.MapPoint(w, MARKERS[i], c)
        for (_, w), c, i in zip(words, colours, idx_in_group)
    ]
    tools.make_scatter_map(
        long_lats,
        points,
        f"{basename}-scatter",
        [w for g in word_groups for w in g],
        title,
    )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--cmap", type=str, default="Dark2")
    parser.add_argument(
        "--grouped",
        type=str,
        help="List of lists of words to display in the same colour on the plots. "
        "The inner lists are comma delimited, the outer list is full-stop delimited. "
        "E.g. fosta,fostacht;comh maith,chomh maith. Each sub-list can have up to four "
        "words in it."
    )
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--question_prompt", type=str)
    group.add_argument("--map_title", type=str)

    args = parser.parse_args()
    word_groups = (
        [g.split(",") for g in args.grouped.split(".")] if args.grouped else None
    )

    if args.question_prompt:
        question_display_id = tools.get_question_prompt_display_id(args.question_prompt)
        words = tools.get_question_response_field(question_display_id, "category")
        main(
            words,
            args.question_prompt,
            f"Words for {args.question_prompt}",
            args.cmap,
            word_groups,
        )
    else:
        words = tools.get_map_point_field([args.map_title], "category")
        main(
            words,
            args.map_title,
            f"Words for {args.map_title}",
            args.cmap,
            word_groups,
        )
