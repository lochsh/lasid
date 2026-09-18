import re

import sqlite3


if __name__ == "__main__":
    with open("mapdata_u.dat", "r") as f:
        lines = f.readlines()
    con = sqlite3.connect("lasid.db")
    cur = con.cursor()

    n = 101
    for i in range(0, len(lines) - 1, n):
        m = lines[i:i+n]

        res = re.search(
            r"<M ([0-9]*[a,b,c]?) (.*)>",
            m[1],
        )
        display_id = res.group(1)
        title = res.group(2)

        print(m[2])
        categories = re.search(
            r"<F (.*)>",
            m[2],
        ).groups()
        categories = "; ".join(categories)


        cur.execute(
            f"""
            insert into
                map (title, categories, display_id)
                values (
                    "{title}",
                    "{categories}",
                    "{display_id}"
                );
            """
        )

        for p in m[3:]:
            p = p.replace("|", "").rstrip().lstrip("0")
            try:
                survey_point_id, transcriptions = p.split(" ", 1)
            except ValueError:
                continue

            cur.execute(
                f"""
                insert into
                    map_point (transcription, map_id, survey_point_id)
                    values (
                        "{transcriptions}",
                        (select id from map where display_id = "{display_id}"),
                        (select id
                            from survey_point
                            where display_id = "{survey_point_id}")
                    );

                """
            )

    con.commit()
