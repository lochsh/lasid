import seaborn as sns

import tools


MARKERS = ["o", "^", "s", "X", "d", "P", "*", "p", "<"]


def get_marker(group_idx, word_idx, groups, num_diff_cols) -> str:
    if group_idx < num_diff_cols:
        try:
            return MARKERS[word_idx]
        except IndexError as e:
            raise ValueError(
                f"Can currently only support {len(MARKERS)} words in a group at a time"
            ) from e

    used_friendly_idx = max(len(g) for g in groups[:num_diff_cols])
    used_cblind_marker_idx = used_friendly_idx + sum(
        len(g) for g in groups[num_diff_cols:group_idx]
    )

    try:
        return MARKERS[used_cblind_marker_idx + word_idx]
    except IndexError as e:
        raise ValueError(
            f"Currently support {len(MARKERS)} different markers. The first "
            f"{num_diff_cols} groups use the same markers, as they are assumed to be "
            "differentiable by colour alone. The remaining groups use the remaining "
            "markers without any overlap with each other. You have run out of markers."
        ) from e


def main(
    words: list[tuple[str, str]],
    basename: str,
    title: str,
    cmap_name: str,
    *,
    num_diff_cols: int,
    markers: dict[str, str] | None = None,
    word_groups: list[list[str]] | None = None,
    eq: dict[str:str] | None = None,
):
    words = [(sid, w) for sid, w in words if w]
    long_lats = [tools.get_mean_long_lat(sid) for sid, _ in words]

    # Modify any equivalent words
    if eq is not None:
        words = [(sid, eq[word]) if word in eq else (sid, word) for sid, word in words]

    if not (markers is None) ^ (word_groups is None):
        raise ValueError("Can specify markers or specify word groups, not both")

    if markers is None:
        unique_words = sorted(set(w for _, w in words))
        word_groups = word_groups + [
            [w] for w in unique_words if not any(w in g for g in word_groups)
        ]
    else:
        marker_to_words = {m: [] for m in markers.values()}
        for word, marker in markers.items():
            marker_to_words[marker].append(word)
        word_groups = list(marker_to_words.values())

    num_groups = len(word_groups)
    cmap = sns.color_palette(cmap_name, num_groups)
    group_idxs = [[w in g for g in word_groups].index(True) for _, w in words]
    colours = [cmap[idx] for idx in group_idxs]
    idx_in_group = [
        word_groups[g_idx].index(w) for g_idx, (_, w) in zip(group_idxs, words)
    ]

    tools.make_text_map(long_lats, [w for _, w in words], colours, basename, title)

    if markers:
        points = [tools.MapPoint(w, markers[w], c) for (_, w), c in zip(words, colours)]
    else:
        points = [
            tools.MapPoint(w, get_marker(g, i, word_groups, num_diff_cols), c)
            for (_, w), c, g, i in zip(words, colours, group_idxs, idx_in_group)
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

    parser = argparse.ArgumentParser(
        description="Plot lexical distribution on map, both by printing words on the "
        "map, and with a scatter plot. These are saved as SVGs. Various options are "
        "provided for customising the colour and markers used."
    )
    parser.add_argument(
        "--cmap",
        type=str,
        default="Dark2",
        help="seaborn colourmap name, see seaborn docs for more info",
    )

    display_group = parser.add_mutually_exclusive_group()
    display_group.add_argument(
        "--grouped",
        type=str,
        help="List of lists of words to display in the same colour on the plots. "
        "The inner lists are comma delimited, the outer list is full-stop delimited. "
        "E.g. fosta,fostacht.comh maith,chomh maith. "
        "This can also be used to control the order of words in the "
        "colourmap and legend, without grouping words together. Not every word needs "
        "specified. Markers are automatically selected in the scatter plot.",
    )
    display_group.add_argument(
        "--markers",
        type=str,
        help="List of words and the markers to associate with them. E.g. "
        "eallach:P,beithidhigh:o,crodh:x,an crodh:x. See matplotlib docs for marker "
        "codes. This also specifies the order of the words in the colourmap and "
        "legend. When two words are listed with the same marker, they will be listed "
        "separately in the legend. Alternatively, you can leave equivalent words out "
        "of the list of markers and specify them in the --eq argument. The first word "
        "listed in the --eq argument will be shown. Any subsequent words given there "
        "should not appear in the list of marker mappings. Every word must be "
        "specified in either in --markers or in --eq.",
    )

    parser.add_argument(
        "--eq",
        type=str,
        help="Optionally mark some words as equivalent to each other, e.g. 'crodh,an "
        "crodh.tórramh,tórradh'. The comma delimits words that are to be treated the "
        "same, the full-stop separates lists. The first word will be what is "
        "displayed. If used with the --markers argument, The first word in each "
        "list should appear in the --markers argument, the others should not. "
        "Similarly, if used with the --grouped argument, only the first word in "
        "each list is allowed to be listed in --grouped.",
    )

    parser.add_argument(
        "--num-friendly-cols",
        type=int,
        default=3,
        help="Number of colours in the colour palette that are differentiable to "
        " anomalous trichromacy and dichromatic colourblindness, assumed to be the "
        "first N colours. Set to a number greater than the number of words/groups to "
        "use the same markers for all groups, or 1 to use different markers for each "
        "group. Only used if markers aren't provided.",
    )
    parser.add_argument(
        "--incl-all-forms",
        help="By default, entries with the `different_form` field set to True are "
        "ignored. Set this to include them.",
        action="store_true",
    )
    db_group = parser.add_mutually_exclusive_group()
    db_group.add_argument("--question_prompt", type=str)
    db_group.add_argument("--map_title", type=str)

    args = parser.parse_args()
    word_groups = (
        [g.split(",") for g in args.grouped.split(".")] if args.grouped else None
    )

    if args.markers:
        markers = dict(p.split(":") for p in args.markers.split(","))
    else:
        markers = None

    eq = None
    if args.eq is not None:
        equivalents = [g.split(",") for g in args.eq.split(".")]
        eq = {w: words[0] for words in equivalents for w in words[1:]}

    if args.question_prompt:
        question_display_id = tools.get_question_prompt_display_id(args.question_prompt)
        words = tools.get_question_response_field(question_display_id, "orthography")

        if not args.incl_all_forms:
            different_forms = tools.get_question_response_field(
                question_display_id,
                "different_form",
            )
            words = [w for w, f in zip(words, different_forms) if f[1] == 0]

        main(
            words,
            args.question_prompt,
            f"Words for {args.question_prompt}",
            args.cmap,
            num_diff_cols=args.num_friendly_cols,
            markers=markers,
            word_groups=word_groups,
            eq=eq,
        )
    else:
        words = tools.get_map_point_field([args.map_title], "orthography")
        if not args.incl_all_forms:
            different_forms = tools.get_map_point_field(
                [args.map_title],
                "different_form",
            )
            words = [w for w, f in zip(words, different_forms) if f[1] == 0]
        main(
            words,
            args.map_title,
            f"Words for {args.map_title}",
            args.cmap,
            num_diff_cols=args.num_friendly_cols,
            markers=markers,
            word_groups=word_groups,
            eq=eq,
        )
