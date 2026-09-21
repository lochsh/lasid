import csv

import sqlite3


if __name__ == "__main__":
    with open("maps.csv", "r") as f:
        reader = csv.DictReader(filter(lambda row: row[0:2] != "/*", f))
        con = sqlite3.connect("lasid.db")
        cur = con.cursor()

        processed_maps = []
        for row in reader:
            map_display_id = row["map"]
            title = row["prompt"]

            if map_display_id not in processed_maps:
                cur.execute(
                    f"""
                    insert into
                        map (title, display_id)
                        values (
                            "{title}",
                            "{map_display_id}"
                        );
                    """
                )
                processed_maps.append(map_display_id)

            survey_point_id = row["survey_point_id"]
            transcription = row["transcription"]
            note = row["note"]
            category = row["category"]

            cur.execute(
                f"""
                insert into
                    map_point (transcription, note, category, map_id, survey_point_id)
                    values (
                        "{transcription}",
                        "{note}",
                        "{category}",
                        (select id from map where display_id = "{map_display_id}"),
                        (select id
                            from survey_point
                            where display_id = "{survey_point_id}")
                    );

                """
            )

        con.commit()
