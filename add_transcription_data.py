import csv
import os

import sqlite3


if __name__ == "__main__":
    con = sqlite3.connect("lasid.db")
    cur = con.cursor()
    with open(os.path.join(os.path.dirname(__file__), "data", "maps.csv"), "r") as f:
        reader = csv.DictReader(filter(lambda row: row[0:2] != "/*", f))

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

            cur.execute(
                f"""
                insert into
                    map_point (
                        transcription,
                        note,
                        category,
                        sourced_elsewhere,
                        map_id,
                        survey_point_id
                    ) values (
                        "{row['transcription']}",
                        "{row['note']}",
                        "{row['category']}",
                        {row['sourced_elsewhere']},
                        (select id from map where display_id = "{map_display_id}"),
                        (select id
                            from survey_point
                            where display_id = "{row['survey_point_id']}")
                    );

                """
            )

    for q_csv in os.listdir(
        os.path.join(os.path.dirname(__file__), "data", "questions")
    ):
        with open(
            os.path.join(os.path.dirname(__file__), "data", "questions", q_csv), "r"
        ) as f:
            reader = csv.DictReader(f)

            display_id, prompt = os.path.basename(q_csv).split("-")

            cur.execute(
                f"""
                insert into
                    question (display_id, prompt)
                    values ({display_id}, "{prompt}");
                """
            )
            for row in reader:
                survey_point_id = row["survey_point_id"]
                informant_label = row["informant_label"]
                if informant_label:
                    cur.execute(
                        f"""
                        insert into
                            response (
                                response,
                                notes,
                                question_id,
                                survey_point_id,
                                informant_id
                            ) values (
                                "{row['transcription']}",
                                "{row['note']}",
                                {display_id},
                                "{survey_point_id}",
                                (
                                    select informant.id from informant
                                    left join
                                        townland on informant.townland_id = townland.id
                                    left join
                                        survey_point on
                                            townland.survey_point_id = survey_point.id
                                    where survey_point.display_id= "{survey_point_id}"
                                    and label = "{informant_label}"
                                )
                            );
                        """
                    )
                else:
                    cur.execute(
                        f"""
                        insert into
                            response (
                                response,
                                notes,
                                question_id,
                                survey_point_id
                            ) values (
                                "{row['transcription']}",
                                "{row['note']}",
                                {display_id},
                                "{survey_point_id}"
                            );
                        """
                    )

    con.commit()
