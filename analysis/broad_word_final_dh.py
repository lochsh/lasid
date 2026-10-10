import tools


def search_for_phones(
    trans: list[str],
    phones: list[str | list[str]],
) -> list[str] | None:
    for p in phones:
        if isinstance(p, list):
            result = search_for_phones(trans, p)
            if result is not None:
                return result
        else:
            if p in trans:
                return trans[trans.index(p) + 1 :]


def main():
    matches = tools.get_map_points_matching_regex(
        "map_point.orthography",
        ".*[a,o]dh\\b",
        ["map_point.transcription", "map.display_id", "map_point.different_form"],
    )

    # The number of phones coresponding to <-adh> or <-odh> varies, so we can't just
    # extract the last phone from the relevant word. The following approach beats
    # manually extracting the relevant sounds, even if it is a little noddy perhaps.
    #
    # We'll list the letters that precede <-adh> or <-odh> and map them to the phones
    # we'd expect to see before the ones that correspond to <-adh> or <-odh>. The order
    # is the order in which the preceding characters will be checked.
    #
    # When a vowel comes before our sounds of interest, it can be difficult to decide
    # where to draw the line, though our analysis will largely care about whether the
    # realisation involves any consonants, so the exactly segmentation is not too
    # important.
    #
    # The choices made here are specific to what is in the relevant data -- this not
    # meant to be a general-purpose tool.
    preceding = {
        "abh": [
            "ˏ",
            "ˌ",
            "ʷ",
            "w",
            "ᵛ",
            "v",
            "j",
            "h",
            "o",
            "o·",
            "oː",
            "ǫ",
            "ɑ̨",
            "ɑ",
            "e",
            "ọː",
            "ɔː",
            "eː",
            "ɛː",
            "u",
        ],
        "agh": ["ˏ", "aː", "ɑː", "a", "eː", "ẹː", "e", "èː", "ɛː", "öː", "ə"],
        "c": ["ḳ", "k", "g̣", "g′", "g̣′", "g", "ḳ", "k′", "t"],
        "ch": ["χ", "x", "h", "ʰ"],
        "d": ["d", "ᴅ", "ᴅː", "d·", "δ", "t"],
        "dhe": ["j"],
        "g": ["g", "ḳ", "g̣"],
        "i": ["iː", "i·", "i"],
        "íthe": ["h", "iː"],
        "l": ["ł", "l", "ʟ", "l′", "ᴌ", "ɫ"],
        "le": ["ʟ′", "l′", "l", "ʟ′ː", "l′·", "l′d′", "ʟ′d′", "l′ː"],
        "n": ["n", "ɴ", "ɴː"],
        "ne": ["n′", "ɴ′", "ɴː′"],
        "p": ["p"],
        "r": ["r"],
        "re": ["r′", "ṟ", "r", "r″", "ř′", "j"],
        "s": ["s"],
        "sí": [["ʃ", "iː"], "iː"],
        "t": ["t", "ḍ"],
        "te": ["d̤", "ṭ′", "t′", "ṯ"],
        "th": ["ˏ", "h"],
    }

    sounds = []
    for sid, orth, t, map_id, different_form in matches:
        if different_form:
            continue

        words = orth.split(" ")
        word_idx = ["adh" in w or "odh" in w for w in words].index(True)
        word_trans = t.split(" ")[word_idx].split("+")
        word_orth = words[word_idx]

        # Compound words like 'cruadh-ae' need specialised processing.
        if orth == "cruadh-ae":
            schwa_idx = word_trans.index("ə")
            if schwa_idx == len(word_trans) - 1:
                # Don't worry about point 69 where the two sounds merge
                continue
            relevant_sounds = word_trans[schwa_idx:schwa_idx + 2]
            sounds.append((sid, map_id, word_orth, "".join(relevant_sounds)))
        else:
            for pre_letters, pre_sounds in preceding.items():
                if word_orth[-3 - len(pre_letters) : -3] != pre_letters:
                    continue

                relevant_sounds = search_for_phones(word_trans, pre_sounds)
                if relevant_sounds is None:
                    raise RuntimeError(
                        "No matching phones, couldn't find any of "
                        f"{pre_sounds} in {word_trans}"
                    )

                sounds.append((sid, map_id, word_orth, "".join(relevant_sounds)))
                break
            else:
                raise RuntimeError(
                    f"'{word_orth}' does not contain any of "
                    f"{list(preceding.keys())}. Cannot extract phones representing "
                    "<-adh> or <-odh>."
                )

    nom_sg_nouns = [
        "231b",  # summer
        "139",  # liver
        "222",  # shelter
        "2",  # cattle
        "56",  # dog
        "88",  # food
        "268",   # smell
        "196b",  # funeral
    ]
    gen_sg_nouns = [
        "164",  # fire,
        "167b",  # turf
    ]
    verbal_nouns = [
        "195",  # melting
        "278",  # folding
        "65",  # digging
        "144",  # closing
        "5",  # castrating
        "187a",  # threshing
        "176b",  # plouging
        "230",  # shining
    ]
    autonomous = [
        "258b",  # (he was) caught
        "204",  # it was said
        "298",  # he died suddenly
        "290",  # I met him (on the road)
        "77",  # (he) was found
    ]

    labial_fricatives = ["v", "f", "φ", "ᵛ", "f′", "ᵠ", "ᶠ"]
    velar_plosives = ["g", "k", "ḳ", "g̣"]
    velar_fricatives = ["x", "x′", "χ", "ɣ̮", "ɣ"]
    for ss in set(s for _, _, _, s in sounds):
        print(ss)


if __name__ == "__main__":
    main()
