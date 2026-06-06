create table if not exists "volume" (
    id integer primary key autoincrement not null,
    vol_idx integer not null unique,
    authors text not null,
    subtitle text not null
);

create table if not exists "area" (
    id integer primary key autoincrement not null,
    ainm nvarchar(64) not null unique,
    name nvarchar(64) not null unique,
    display_id nvarchar(8) not null,
    remarks text,
    volume_id integer not null,
    foreign key (volume_id) references "volume" (id)
);

create table if not exists "survey_point" (
    id integer primary key autoincrement not null,
    display_id nvarchar(8) not null unique,
    ainm nvarchar(32) not null unique,
    name nvarchar(32) not null unique,
    transcription nvarchar(64),
    year nvarchar(32) not null,
    language_position text,
    other_fieldworker_notes text,
    notes text,
    area_id integer not null,
    foreign key (area_id) references "area" (id)
);

create table if not exists "townland" (
    id integer primary key autoincrement not null,
    ainm nvarchar(32) not null unique,
    name nvarchar(32) not null unique,
    transcription nvarchar(128),
    lat real not null,
    lon real not null,
    survey_point_id integer not null,
    foreign key (id) references "survey_point" (id)
);

create table if not exists "informant" (
    id integer primary key autoincrement not null,
    name nvarchar(32) not null,
    transcription nvarchar(32),
    age nvarchar(16),
    occupation nvarchar(128),
    label nvarchar(8),
    fieldworker_notes text,
    notes text,
    townland_id integer not null,
    foreign key (townland_id) references "townland" (id)
);

create table if not exists "question" (
    id integer primary key autoincrement not null,
    display_id integer not null unique,
    prompt nvarchar(64) not null unique
);

create table if not exists "category" (
    id integer primary key autoincrement not null,
    display_text nvarchar(64) not null unique,
    question_id integer not null,
    foreign key (question_id) references "question" (id)
);

create index if not exists question_categories on "category" (question_id);

create table if not exists "response" (
    id integer primary key autoincrement not null,
    response nvarchar(128) not null,
    notes text,
    question_id integer not null,
    survey_point_id integer not null,
    category_id integer not null,
    informant_id integer,
    foreign key (question_id) references "question" (id),
    foreign key (survey_point_id) references "survey_point" (id),
    foreign key (category_id) references "category" (id),
    foreign key (informant_id) references "informant" (id)
);

create table if not exists "map" (
    id integer primary key autoincrement not null,
    title nvarchar(32) not null,
    categories nvarchar(64) not null,
    display_id nvarchar(16) not null
);

create table if not exists "map_point" (
    id integer primary key autoincrement not null,
    transcription nvarchar(64) not null,
    map_id integer not null,
    survey_point_id integer not null,
    foreign key (map_id) references "map" (id),
    foreign key (survey_point_id) references "survey_point" (id)
);

create table if not exists "map_questions" (
    id integer primary key autoincrement not null,
    question_id integer,
    map_id integer,
    foreign key (question_id) references "question" (id),
    foreign key (map_id) references "map" (id)
);

/*
  Volumes
*/

insert into
    volume (vol_idx, subtitle, authors)
    values (
        2,
        "Vol. II. The Dialects of Munster",
        "Heinrich Wagner"
    );

insert into
    volume (vol_idx, subtitle, authors)
    values (
        3,
        "Vol. III. The Dialects of Connaught",
        "Heinrich Wagner"
    );

insert into
    volume (vol_idx, subtitle, authors)
    values (
        4,
        "Vol. IV. The Dialects of Ulster and the Isle of Man. Specimens of Scottish Gaelic Dialects. Phonetic Texts of East Ulster Irish",
        "Heinrich Wagner and Colm O Baoill, Ph. D."
    );

/*
  Areas
*/

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Condae Phort Láirge, Condae Thiobraid Árann, Condae Chill Chainnighe",
        "County Waterford, County Tipperary, County Kilkenny",
        (select id from volume where vol_idx = 2),
        "Irish is almost dead in points 2-5 and has died a good while ago in points 6, 6a. The material obtained in points 2-5 contains a good deal of corrupt sentences.",
        "I"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Condae Chorcaí agus Condae Chiarraí",
        "County Cork and County Kerry",
        (select id from volume where vol_idx = 2),
        null,
        "II"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Condae an Chláir",
        "County Clare",
        (select id from volume where vol_idx = 2),
        "In this county, Irish has almost disappeared. In point 22a, only a small section of the questionnaire was recorded.",
        "III"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Condae na Gaillimhe",
        "County Galway",
        (select id from volume where vol_idx = 3),
        "Galway is the only county where native speakers can still be found in every district. In points 25-33, however, there were only a few speakers remaining from whom we were able to get more or less complete material. There are large gaps in the material collected in points 26, 27, 29, 31.<br><br>A line connecting points 40-43-44-46-49-50-51, must be considered as the last vein of <i>Connaught</i> Irish, if not of the Irish language in general, which has not yet run dry.",
        "IV"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Condae Mhaigh Eo",
        "County Mayo",
        (select id from volume where vol_idx = 3),
        "With the exception of the districts between 52 and 53, native Irish speakers can be found around the Mayo coast in isolated packets.",
        "V"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Oirthuaisceart Chonnacht",
        "North East Connaught",
        (select id from volume where vol_idx = 3),
        "<i>Letrim</i> and <i>Cavan</i> Irish died before they were studied systematically. This is a considerable loss to Irish studies, as it must have been in these districts that <i>East Ulster</i> Irish and <i>Connaught</i> Irish clashed.",
        "VI"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Oirthear Uladh",
        "East Ulster",
        (select id from volume where vol_idx = 4),
        "Unfortunately Irish had almost disappeared from <i>East Ulster</i> by the time we began our scheme. Twenty years ago, we would have got excellent subjects, not only in <i>North East Connaught (Leitrim, North Sligo, Roscommon)</i>, but also in most northern counties <i>(Louth, Argmagh, Monaghan, Fermanagh, Derry</i> and <i>Antrim)</i>. In <i>Omeath (Louth)</i>, which was undoubtedly the last stronghold of <i>South East Ulster Irish</i>, one native speaker has survived (pt. 65). In County <i>Monaghan</i>, in a place called <i>Inishkeen</i> near <i>Dundalk</i>, I met another one. Native Irish is dead in County <i>Antrim</i>, apart from <i>Rathlin Island</i> (point 67), where a few fairly good speakers can still be found. The language of this island, however, is essentially a Scottish Gaelic dialect.",
        "VII"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Condae Dhún na nGall",
        "County Donegal",
        (select id from volume where vol_idx = 4),
        null,
        "VIII"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        remarks,
        display_id
    ) values (
        "Mannin",
        "Isle of Man",
        (select id from volume where vol_idx = 4),
        "In 1950, I collected a fair amount of material from the remaining native speakers of Manx Gaelic, which is practically dead now. It was from the same speakers that Professor <i>Carmody</i> had collected the material for his article 'Spoken Manx' (ZCPh 24, 58 ff.) and that Professor Jackson subsequently collected material for his booklet 'Contributions to the study of Manx Phonology' (Edinburgh 1955). Further details on recent Manx studies are found in my review of Jackson's book in Modern Language Review LI, 1, p. 109. A section of my own Manx material will be published in my book 'Das Verbum in den Sprachen der britischen Isneln' (Beihelf zur ZCPh, Tübingen 1959).<br><br>Owing to a statement made by C. Marstrander some twenty years ago, it was generally believed that spoken Manx had died out completely. But during the late thirties and the forties a small group of Manx enthusiasts, having acquired a knowledge of literary Bible Manx, began to comb the countryside in search of surviving speakers. Finding about twelve to twenty old people who spoke some Manx in their youth, they sought to revive the old native tongue in these people by visiting them at regular intervals. Gradually the old people began to remember phrases of ordinary conversation, little sayings and stories which they had used or heard many years before.<br><br>The pronunciation of our informants was mostly unclear and therefore an accurate acousitc reception was seldom forthcoming. Our phonetic notations must be used with great care. In how far our material is 'corrupted' is hard to say (cf. also Jackson op. cit. 3 s.). Manx is a Gaelic language which has been influenced in its structure by Britannic Celtic and later by English, in its phonetics and vocabulary also by Norse. It is a very mixed Celtic dialect.",
        "IX"
    );

insert into
    area (
        ainm,
        name,
        volume_id,
        display_id
    ) values (
        "Alba",
        "Scotland",
        (select id from volume where vol_idx = 4),
        "Appendix I"
    );

/*
  Survey points
*/

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "1",
        "An Rinn",
        "Ring",
        "ən raĩŋ′",
        "1950",
        "Irish is still alive in the two small fishing villages <i>Baile na nGall</i> and <i>Helvik</i>, but English has become predominant at least with the younger generation. Our subjects in this area were equally fluent in both languages.",
        "<ol><li>There exists a strong tendency in this dialect to depalatalise slender consonants. Slender dentals have almost become alveolars and are difficult to distinguish acoustically from broad (pure) dentals.</li><li>'ŋ′' which has developed historically from slender 'nn' is only slightly velarised [sic? palatalised?] and may be described as an intermediate sound between 'ŋ′' and 'ɴ′'. This applies to most Irish dialects which have developed 'ŋ′' from slender 'nn'.</li><li>'kŁ' is strongly uvularised.</li></ol>",
        "No notes on which informant gave which answers",
        (select id from area where display_id = "I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "2",
        "Cnoc Mheilearaí",
        "Mount Melleray",
        null,
        "1950",
        "Only a few native speakers have survived in this rather desolate mountain area.",
        "What has been said in note 1 to point 1 applies also this dialect.",
        null,
        (select id from area where display_id = "I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "3",
        "Sliabh gCua",
        "Slieve Gua",
        "ʃl′iĕˈguə",
        "1954",
        "This mountain district is now almost deserted.",
        "A shorter version of our questionnaire has been used here.",
        null,
        (select id from area where display_id = "I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "4",
        "Droichead na nGabhar",
        "Goatenbridge",
        null,
        "1950",
        "In South Tipperary, at the foot of the <i>Knockmealdown</i> mountains, there was quite a number of speakers left, all belonging to the oldest generation. None of them, however, was as fluent in Irish as in English.",
        "<ol><li>What has been said in note 2 to point 1 also applies to this dialect.</li><li>Slender consonants generally show stronger palatalisation here than at points 1 and 2.</li><li>'kl' is strongly velarised.</li><li>Uvularised 'L' is rare as in point 5.</li><li>'Newcastle' refers to a speaker from Newcastle some miles west of our point 4.</li></ol>",
        null,
        (select id from area where display_id = "I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "5",
        "Cill Síoláin",
        "Kilsheelan",
        "k′eil′ ʃiːˈlɑːn",
        "1950",
        "In the townland of <i>Glenpatrick</i> I met two speakers only who were able to translate about 60 per cent of my items; these were no longer able to speak Irish fluently.",
        null,
        "No notes on which informant gave which answers",
        (select id from area where display_id = "I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "6",
        "Cill Chainnigh Thuaidh",
        "North Kilkenny",
        null,
        "before 1939",
        "In <i>North</i> and <i>South Kilkenny</i>, material had been collected some twenty years ago by Professor R. A. Breatnach (Cork). It was presented as a thesis ('Gaedhilg Cho. Chille Choinnigh', Coláiste na hOllscoile, Baile Atha Cliath 1939) but, unfortunately, has never been published.. With Professor Breatnach's kind permission, we were able to make use of this material. Only a limited number, however, of our items were found in this collection and are entered in the maps. Professor Breatnach relied mainly on two informants, neither of them being a fluent Irish speaker. His transcription differs in details from ours and is a fairly broad one.",
        null,
        null,
        (select id from area where display_id = "I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "6a",
        "Cill Chainnigh Theas",
        "South Kilkenny",
        null,
        "before 1939",
        "In <i>North</i> and <i>South Kilkenny</i>, material had been collected some twenty years ago by Professor R. A. Breatnach (Cork). It was presented as a thesis ('Gaedhilg Cho. Chille Choinnigh', Coláiste na hOllscoile, Baile Atha Cliath 1939) but, unfortunately, has never been published.. With Professor Breatnach's kind permission, we were able to make use of this material. Only a limited number, however, of our items were found in this collection and are entered in the maps. Professor Breatnach relied mainly on two informants, neither of them being a fluent Irish speaker. His transcription differs in details from ours and is a fairly broad one.",
        null,
        null,
        (select id from area where display_id = "I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "7",
        "Baile Mhac Óda",
        "Ballymacoda",
        "bɑl′əv′ïˈkoːdə",
        "1952",
        "This is our only point in East Cork. There is a number of native speakers left in the townland of <i>Knockadoon</i>, but Irish has not been spoken very much for at least thirty years. All speakers are, therefore, more fluent in English than in Irish.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "8",
        "Cloich na Coillte",
        "Clonakilty",
        "klɑnəˈk′iːl′ĕ",
        "1952",
        "Irish is almost dead in this area. None of our informants could speak it fluently, but they knew sufficient to answer about two-thirds of our questions.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "9",
        "Cuan Dor",
        "Glandore",
        null,
        "1952",
        "Irish is almost dead in this area. Our informant could not speak it fluently.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "10",
        "An Sciobairín",
        "Skibbereen",
        "n̥ ʃḳ′ïb′əˈr′iːn′",
        "1952",
        "Irish is almost dead in this area. Our material from this point is, however, better than the material collected at points 7-9.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "11",
        "Cléire",
        "Clear Island",
        "əˈl′ɑːn ˈk′l′eːr′ĕ <i>or</i> ...x′l′eːr′ĕ",
        "1952",
        "A little Irish is still spoken on this island. Islands, as well as mountains, are the last refuge of the language. It is significant that I had to go to the remote part of the island in order to find the best informants. English is strongest around the ports, as we have noticed on other islands, for example <i>Aranmore</i> (79). On <i>Tory Island</i> (75), which is still entirely Irish-speaking, I have noticed that the people of the western village (bɑl′ə ˈhiər) were more fluent than those of the eatern village (bɑl′ə ˈher′) when they spoke English to strangers. We may attribute this to the fact that most of the traffic with the mainland is through the western village. On <i>Clear Island</i>, Irish is dying rapidly, as this island is open to modern civilization. On the whole we got very realiable material in this place.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "12",
        "Com Sheola",
        "Coomhola",
        "kuːmˈhoːlə",
        "1952",
        "Only a very few speakers have survived in this area. Both our informants were more fluent in English.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "13",
        "An Láithreach",
        "Lauragh",
        "lɑːrhəx, lɑːrəx",
        "1951",
        "Irish is almost extinct in this area. Fortunately one excellent speaker was found in whose house Irish is still the common vernacular.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "14",
        "Baoi Bhéarra",
        "Dursey Sound",
        "bʷɪː ˈv′ɛrə",
        "1952",
        "My subject was considered the last native speaker of the entire district but was more fluent in English than in Irish.",
        null,
        "The name given in the LASID is <i>Dursey Sound</i>, but the transcription shows <i>Baoi Bhéarra</i> rather than <i>Sunda Baoi</i>.",
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "15",
        "Cúil Aodha",
        "Coolea",
        "kuːˈl′eː",
        "1952",
        "In <i>Coolea</i> and its neighbourhood, Irish is still spoken in some houses, English having become the ordinary vernacular at least of the younger generation. We got perfect material.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "16",
        "Gleann Fleisce",
        "Glenflesk",
        "g′l′oun ˈf′l′eʃḳĕ",
        "1952",
        "In the mountain valley of the river <i>Clydagh</i> (klEːdəx), there are a few Irish speakers left, none of them being really fluent.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "17",
        "Cill Gharbháin",
        "Kilgarvan",
        "k′iːl′ gərəˈvɑːn′",
        "1952",
        "In the mountain area east of Kilgarvan I found a good Irish speaker who could answer most of my questions.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "18",
        "An Coireán",
        "Waterville",
        "əŋ kəˈrɑːn",
        "1950",
        "There may be some houses, especially along the coast between <i>Waterville</i> and <i>Cahirciveen</i> on the <i>Ballinskelligs Bay</i>, where Irish is still spoken. Apart from the questionnaire I have collected a large amount of material in the area between <i>Caberdaniel</i> and <i>Ballinskelligs</i>. Most of our informants were equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "19",
        "Cill Orglan",
        "Killorglin",
        "k′il′orəgən",
        "1952",
        "In <i>Cromane</i> and <i>Glenbeigh</i>, west of <i>Killorglin</i>, only a few native speakers have survived. Only one of our two informants (a) was fluent in Irish. Other speakers proved less useful than (b).",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "20",
        "Dún Chaoin",
        "Dunquin",
        "duːn ˈxɪːn′",
        "1953",
        "This is the only spot in the province of Munster where Irish is still predominant, and English spoken only to strangers who are flocking in increasing numbers to this beautiful spot at the end of the Dingle peninsula. I met a number of monoglots during my stay in <i>Dunquin<i> in 1945/46. It was here I learnt my first Irish. Since then, the <i>Blasket</i> islander have been migrated to Dunquin on the mainland. These people have never spoken anything but Irish. It must be remembered, however, that the entire population of <i>Dunquin</i> including the <i>Blasket</i> islanders, scarcely exceeds 500. Irish is spoken in a few other villages in the immediate neighbourhood of <i>Dunquin</i>> and in the direction of <i>Mount Brandon</i> (between points 20 and 21 [...]).",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "21",
        "Clochán",
        "Cloghane",
        "kloˈxɑːn",
        "1952",
        "There are only a few speakers left, and there is no longer any Irish spoken in this area. Our subject was equally fluent in both languages and provided good material.",
        null,
        null,
        (select id from area where display_id = "II")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "22",
        "Cill Bheathach",
        "Kilbaha, Loop Head",
        null,
        "1951 and 1952",
        "Irish is on the verge of dying in this area although most of the older generation can speak it. Our subjects were equally fluent in both langauges.",
        null,
        null,
        (select id from area where display_id = "III")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "22a",
        "An Corrbhaile",
        "Corbally",
        null,
        "1951 and 1952",
        null,
        null,
        null,
        (select id from area where display_id = "III")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "23",
        "Dúlainn agus Sráid na nIascairí",
        "Doolin and Fisherstreet",
        "duːlən",
        "1951 and 1952",
        "Irish is on the verge of dying although most of the older generation can speak it.",
        null,
        null,
        (select id from area where display_id = "III")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "24",
        "Fánóir",
        "Fanore",
        null,
        "1951 and 1952",
        "Only a few speakers are left in the area west of <i>Ballyvaughan</i> along the coastline. Our informant in this area was the best speaker we have met in <i>County Clare</i>. He had been brought up by his grandparents who did not know any English at all.",
        null,
        null,
        (select id from area where display_id = "III")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "25",
        "Cinn Mhara",
        "Kinvara",
        "k′iːn ˈvɑrə",
        "1951",
        "A limited number of good speakers can still be found along the coast west of <i>Kinvara</i>. Our subject was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "26",
        "Caithríní",
        "Careeny",
        "kɑr′hiːn′i",
        "1951",
        "None of our informants in this mountain area could speak Irish. We were, however, able to collect a few hundred words and little sentences from them. They must have spoken some Irish in their childhood. The area is situated on the <i>Galway/Clare</i> border.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "27",
        "Loch an Tóraic",
        "Lough Attorick",
        "lox ə ˈtoːrik′",
        "1951",
        "Only one speaker has survived in this desolate mountain area. He was by no means fluent in Irish.>",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "28",
        "Sonnach",
        "Sonnagh",
        "sonəx",
        "1951",
        "One good speaker was found in this mountain area who translated most of our questions.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "29",
        "Creachmhaoil",
        "Craughwell",
        "k′rax ˈvɪːl",
        "1951",
        "Only a very few speakers have survived in this area, none of them being fluent.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "30",
        "Poll an Chrosáin",
        "Colmanstown",
        "ˈpol ən ˈxro̤sɑn",
        "1953",
        "Our informant could not speak Irish fluently",
        null,
        "The English name given in the LASID is <i>Colmanstown</i> (which would be <i>Baile Uí Chlúmháin</i>), but the transcription shows nearby <i>Poll an Chrosáin</i> (<i>Pollacrossaun</i>).",
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "31",
        "Droichead Nua",
        "Newbridge",
        "dröhəd ˈnuː",
        "1951",
        "There are only a very few people left in this area who know some Irish. Our informant could not speak it fluently. One other speaker was consulted.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "32",
        "Ceathrú an Tairbh",
        "Carrowntarriff",
        null,
        "1956",
        "This point represents a place in <i>County Roscommon</i>, about eight miles west of <i>Athlone</i>. Professor T. O Máille (Galway) discovered here two native speakers a few years ago. He recorded answers to our short questionnaire on tape. One of the two informants (a) was very good and could answer most of the questions.",
        null,
        "At writing, logainm.ie only has an English name for this place.",
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "33",
        "Camdhoire",
        "Camderry (near Creggs)",
        "kɑmv̠er′ĕ",
        "1953",
        "Two fluent Irish speakers were found in this area where Irish must have been alive some twenty years ago. Most of our questions were answered.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "34",
        "An Caiseal",
        "Cashel (near Glenmaddy)",
        "kaʃəl",
        "1950",
        "In a village called <i>Lisín na hEillte</i> (ʟ′iʃiːn′ə ˈheʟ′t′ə), beside <i>Cashel</i>, Irish may still be spoken. Our subject was equally fluent in both languages and answered most of our questions. His son knew no Irish!",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "35",
        "Béal Átha Glúinín",
        "Ballyglunin",
        "b′ɛːl ɑː gluːn′iːn′",
        "1953",
        "South of Tuam, there is a number of small villages where Irish has been alive up to recently. Our chief informant was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "36",
        "Eanach Dhúin",
        "Anaghdown",
        null,
        "1953",
        "A limited number of good speakers can still be found east of <i>Lough Corrib</i>. Our informant who rendered all our questions lives now in kro̤k ˈduːə, near <i>Clare-Galway</i>.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "37",
        "Carn Mór",
        "Carnmore",
        "kɑːr ˈmoːr",
        "1953",
        "In this place, Irish is still spoken in some houses. Our informants were equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "38",
        "Gort an Chalaidh",
        "Angliham",
        "gort ə ˈxɑlə",
        "1953",
        "In the neighbourhood of <i>Galway City</i>, there are a few small villages (<i>Carnmore</i>, pt. 37, <i>Menlough</i>, <i>Moontiagh</i>) where Irish is still spoken by the majority of the people. I have met monoglots in <i>Moontiagh</i>. The way of life has remained extremely primitive in the last mentioned village. It is astonishing that the dialect of this area being quite different from <i>Conamara</i>-Irish has never been studied systematically.",
        null,
        "Also known in English as <i>Gortcallow</i>, but <i>Angliham</i> is what is listed in the LASID.",
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "39",
        "Maigh Cuilinn",
        "Moycullen",
        null,
        "1953",
        "There is no Irish spoken in <i>Moycullen</i> itself. Our informant was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "40",
        "An Lochán Beag",
        "Loughaun Beg",
        "n̥ loxɑːn b′øg",
        "1953",
        "About 10 miles west of Galway City, immediately behind the village of <i>Spiddal</i>, we enter an almost one-hundred per cent Irish-speaking district, stretching out along the coast between points 40 and 46. A large amount of monoglots may be found in this area. The population is fairly dense, but the younger generation is emigrating in large numbers. This coastline has neither fishing ports nor arable land, and is really a stone desert to which the people were driven in times of persecution. The same is true, to a certain extent, of the coastal districts in the counties of <i>Mayo</i> (points 52, 53-59) and <i>Donegal</i> (points 68-86). The country behind the stony coast of points 40-46 consists of rocky land or of immense boggy mountains, which are, apart from little pockets, practically uninhabited.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "41",
        "Inis Oírr",
        "Inisheer, Aran",
        "ˈɪn′əsɪːr",
        "1955",
        "<i>Inisheer</i>, the smallest of the three <i>Aran</i> Islands, is perhaps the only place in Ireland where the Irish language has gained ground over the past decades. Although English has become predominant on the largest of the three islands (not represented as a point on our map), the <i>Aran</i> islands have remained a stronghold of the language.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "42",
        "Inis Meáin",
        "Inishmaan",
        "ˈɪn′ɪʃˈm′ɑːn′",
        "1953",
        "This island is entirely Irish speaking and there is a number of monoglots.",
        "This place has been recorded by Professor M. Dillon. There are some small differences between his transcription and mine.",
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "43",
        "An Cheathrú Rua",
        "Carraroe",
        "ən x′arhuː ˈruːə",
        "1953",
        "Irish speaking place. Our subject was equally fluent in both languages. Monoglots are not rare.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "43a",
        "Garmna",
        "Gorumna Island",
        null,
        "1963",
        null,
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "44",
        "Ros Muc",
        "Rosmuck",
        "ros ˈmuk",
        "1955",
        "Irish speaking place where monoglots are not rare. Our subject was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "45",
        "Gleann Trasna",
        "Glentrasna, near Screeb",
        "g′l′ɑːn t̠r̠asnə",
        "1953",
        "Within the area enclosed by points 44-49-50-46, Irish is still spoken in small pockets. This almost uninhabited countryside consists mainly of turf bogs.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "46",
        "Cárna",
        "Carna",
        "kɑːrnə",
        "1953",
        "In the village of <i>Cárna</i> English is widely used by the younger generation. But Irish is still predominant in this district.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "47",
        "Imleach Mór",
        "Emlaghmore",
        "ɪm′l′əxˈmoːr",
        "1953",
        "North and west of <i>Bertraghboy Bay</i> there is hardly any Irish spoken. North of <i>Roundstone</i>, however, there seems to be a restricted number of speakers left. Our informant from this area was questioned in the county home of Loughrea. He was more fluent in English than in Irish.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "48",
        "Leitir Fraic",
        "Letterfrack",
        "ʟ′et′ər′frak′",
        "1955",
        "Only a few speakers have survived in this area. Our informant was equally fluent in both languages. There may still be a few native speakers left on <i>Inishark</i>, the smaller of the two islands opposite point 48.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "49",
        "Corr na Móna",
        "Cornamona",
        "koːrnəˈmuːnŭ",
        "1953",
        "In some mountain valleys of <i>Joyce's Country</i>, represented by points 49, 50, Irish is still spoken at least by the older generation. Our subject in pt. 49 could not speak English, but understood it. She was an ideal subject.",
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "50",
        "Loch na Fuaiche",
        "Lough Nafooey",
        "lox nə ˈfuəih′ĕ",
        "1953",
        null,
        null,
        null,
        (select id from area where display_id = "IV")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "51",
        "Tuar Mhic Éadaigh",
        "Tourmakeady",
        "tuər v′ɪˈk′eːdɪ",
        "1951",
        "In this district, belonging to the same mountain area as points 49, 50, Irish is still spoken to a certain extent. My informants were equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "52",
        "Cluain Cearbán",
        "Louisburgh",
        "klųːn ˈk′arəbɑːn",
        "1951",
        "Only a few speakers have survived in this area, none of them being fluent in Irish.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "53",
        "Corrán",
        "Curraun Peninsula",
        "ko̤rɑːn",
        "1950",
        "No native speakers seem to be left in the stretch of country between <i>Louisburgh</i>, <i>Westport</i>, <i>Newport</i>, and almost as far as <i>Mallarany</i> (about 15 miles east of point 53). A speaker whom I contacted in <i>Newport</i> originally came from <i>Rosturk</i>, a few miles east of <i>Mallarany</i>, where I also met another speaker. In point 53, some Irish is still spoken. My informant told me, when I revisted him in 1956, that Irish has been losing ground rapidly during the six years since I last visited him. He is equally fluent in both languages. ",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "54",
        "Acaill",
        "Achill",
        "ɑkəl′",
        "1950",
        "In <i>Salia</i> (sɑːl′ə), Irish may still be used in some houses. Our informants were equally fluent in both languages. On <i>Inishbiggle</i>, a little island almost opposite point 54, Irish was also spoken. The population of this island has moved to the mainland, and now lives in the <i>Ballycroy</i> area.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "55",
        "Dumha Thuama",
        "Dohooma",
        "dəˈhuːmə",
        "1951",
        "There are only a few native speakers left in this area. One set of questions was asked, divided equally between places 55 and 55a. Additional notes were taken down from our informant in point 55.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "55a",
        "Dumha Locha",
        "Doolough",
        "dųːˈlǫx <i>or</i> dųːˈlɑxə",
        "1951",
        "There are only a few native speakers left in this area. One set of questions was asked, divided equally between places 55 and 55a. Additional notes were taken down from our informant in point 55.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "56",
        "Fód Dubh",
        "Blacksod",
        "fɔːd ˈdəuʷ",
        "1951",
        "At the end of the <i>Belmullet</i> peninsula, in the two villages <i>Fallmore</i> (fɑlˈmɔːr) and Glash (glaʃ), Irish is still predominant but the population is sparse. <i>Glash</i> is inhabited by the <i>Inishkea</i> islanders. I have met a few monoglots in this area.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "57",
        "Port an Chlóidh",
        "Portacloy",
        null,
        "1951",
        "Geographically and economically it is the most isolated area I visited in <i>County Mayo</i>. The best speakers of <i>Mayo</i> Irish may be found here.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "58",
        "Béal Deirg",
        "Belderg",
        null,
        "1951",
        "Only a few native speakers have survived in this area. Our main informant was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "59",
        "Baile an Chaisil",
        "Ballycastle",
        "bɑl′ə ˈxasəl′",
        "1951",
        "In point 59, representing the district between <i>BallyCastle</i> and <i>Lackenbay</i>, only a few native speakers have survived, none of them being fluent in Irish.",
        null,
        null,
        (select id from area where display_id = "V")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "60",
        "Áth an Chláir",
        "Aclare",
        "ɑ. ˈxlɑːr′",
        "1950",
        "At the foot of the <i>Ox</i> mountains, there are a few Irish speakers left. None of my informants could speak it fluently, however.",
        null,
        null,
        (select id from area where display_id = "VI")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "61",
        "Tobar an Choire agus Baile na Coradh",
        "Tobercurry and Curry",
        "tǫbər ə xör′′ə, ˈbɑl′ə nə ˈkorųφ",
        "1950",
        "My informant from near <i>Tobercurry</i> was considered the only person in the area who knew native Irish. He could not speak it fluently. In <i>Curry</i> I met an old lady who could speak it a bit better.",
        null,
        null,
        (select id from area where display_id = "VI")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "62",
        "Cill Mobhí",
        "Kilmovee",
        "k′iʟ′ː moːv′iː",
        "1950",
        "This place is situated on the <i>Roscommon/Mayo</i> border. There are a few native speakers left between <i>Swineford</i> and <i>Kiltimagh</i> and north of <i>Ballaghadereen</i> (County <i>Roscommon</i>) in a boggy district called <i>Cloontia</i>. I met some of the <i>Cloontia</i> people, but none of them was able to give me much material. Our informant in <i>Kilmovee</i> was by far the best.",
        null,
        null,
        (select id from area where display_id = "VI")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "63",
        "Sliabh na Cille",
        "Slievenakilla",
        "ʃʟ′iəv nə ˈk′il′ə",
        "1950",
        "In this mountain district, east of <i>Lough Allen</i>, I met two old men who were able to remember some words and phrases of their native dialect, which they must have spoken in their childhood, probably to their grandparents, who knew Irish only. Apart from single words, proverbs, and some little phrases, it was impossible to get morphological material. Only a small portion of our questions was answered. I also contacted a person near <i>Glenfarn</i> (<i>North Leitrim</i>) who knew some little native Irish.",
        null,
        null,
        (select id from area where display_id = "VI")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "64",
        "Gleann Ghaibhle",
        "Glangevlin",
        "g′l′aɴː",
        "1954",
        "This district belongs geographically and partly also linguistically to <i>Ulster</i>. Our material obtained in this area is extremely scanty, too.",
        null,
        null,
        (select id from area where display_id = "VI")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "87",
        "Baile Uí Choinéil",
        "Ballyconnell",
        null,
        "1956",
        "In this place, north-west of <i>Sligo</i> town, near <i>Lissadell</i> estate on <i>Drumcliff Bay</i>, I contacted an old lady who had spoken some Irish in her youth and was able to give me some little information on the dialect. As a matter of interest, she had spent most of her life in America.<br><br>Up to recently, there was some Irish on <i>Inishmurray</i> in the <i>Donegal Bay</i>, but the people of this island have migrated to the mainland, and live in <i>Grange</i>. Our visit to <i>Grange</i> in 1950 proved fruitless, however, as I was unable to contact anybody who had Irish.",
        null,
        null,
        (select id from area where display_id = "VI")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "65",
        "Ó Méith",
        "Omeath",
        "ɔ̨ˈm′ɛː",
        "1950",
        "I was able to collect a considerable amount of material from a person who is considered the last native speaker of Omeath Irish.",
        null,
        null,
        (select id from area where display_id = "VII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "66",
        "Creagán",
        "Creggan",
        "krögən",
        "1950",
        "In 1950, I collected in a few mountain valley of <i>County Tyrone</i> (between <i>Creggan</i> and the <i>Sperrin</i> mountains) a considerable amount of material from about twelve native speakers. Only one of them could speak Irish as fluently as English.",
        null,
        null,
        (select id from area where display_id = "VII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "67",
        "Reachlainn",
        "Rathlin Island",
        "rɑːxlɑ̌n",
        "1952",
        null,
        null,
        null,
        (select id from area where display_id = "VII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "68",
        "Cluain Maine, Inis Eoghan",
        "Clonmany, Inishowen",
        "kluːɪn′ˈm′anʰa, ɛn′əˈʃɔːn′",
        "1950",
        "The dialect of <i>Inishowen</i> is in my opinion an <i>East Ulster</i> dialect. Only two persons could be found on this big peninsula who gave reasonably good information on the Irish dialect which they could no longer speak freely. Some other persons were consulted who knew just some words and little phrases.",
        null,
        null,
        (select id from area where display_id = "VII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "69",
        "Baile Uí Fhuaruisce, Fánaid",
        "Ballyhooriskey, Fanad",
        "bɑl′ə ˈwo̤rəsg̣i, fɑːnəd′",
        "1950",
        "Irish is still spoken in this village, but nowhere else in the whole peninsula. This dialect, which is quite different from other Donegal dialects, has not yet been studied. Our informants were equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "70",
        "Gleann Bhairr, Fánaid",
        "Glenvar, Fanad",
        "ˈg′ʟ′aɴˈwɑːr",
        "1954",
        "The dialect of <i>Glenvar</i> is quite different from the dialect of <i>Ballyhooriskey</i> and seems to be close to the dialect of points 82, 83. Only a few native speakers have survived here. Our informant could not speak the language fluently.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "71",
        "Na Dúnaibh/Ros Goill",
        "Downings/Rosgill",
        null,
        "1954",
        "There is little Irish spoken in this area now. Our informant was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "72",
        "Baile an Chraoslaigh",
        "Creeslough",
        "ˈbɑl′ə ˈxrλːsʟi",
        "1954",
        "Only a few native speakers are left in this area. A second informant was consulted in <i>Drumnaraw</i> but could not give comprehensive material.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "73",
        "Coill Darach",
        "Kildarragh",
        "k′ɪʟdɑ̣rɑ̣",
        "1954",
        "Our informant was equally fluent in both languages. He was interviewed in the county home of <i>Stranorlar</i>. Native Irish speakers are very scarce in his home place now.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "74",
        "Gort an Choirce",
        "Gortahork",
        "gɔrt ə ˈxör′k′ĕ",
        "1954",
        "Between <i>Gortahork</i> and <i>Mount Errigal</i>, in the parish of <i>Cloghaneely</i>, Irish is still predominant, but English is coming in strongly. This applies even more to the parish of <i>Gweedore</i>, the extreme north west corner of Ireland (west of point 74).",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "74a",
        "Mín an Chladaigh",
        "Meenaclady",
        "m′iːn′ ə ′xʟɑᴅi",
        "1964",
        null,
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "75",
        "Oileán Thoraigh",
        "Tory Island",
        "ˈel′ɑ̣n hɔ̨ri",
        "1954",
        "On this island, Irish is still the only spoken language, apart from the light keepers who come from outside. My informant could not speak much English. <i>Tory</i> must be considered the firmest stronghold of <i>Ulster</i> Irish. There are about 300 people on this island, who live mainly from seasonal emigration to Scotland [footnote: This applies to native <i>Donegal</i> in general, as well as to <i>Achill</i> (53, 54).]. Having spent more than two months on <i>Tory</i>, I shall be able to present fairly comprehensive material on this dialect in the second volume [actually in volume IV].",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "76",
        "Dún Lúiche",
        "Dunlewy",
        "do̤n ˈʟûəix′ĕ",
        "1954",
        "Irish is not much spoken in this area at the southern foot of <i>Mount Errigal</i>. Our subject was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "77",
        "Loch an Iúir",
        "Loughanure",
        "ʟɔhəˈɴûːr′",
        "1954",
        "The population has become sparse in this barren mountain area, and Irish is not spoken much. My subject was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "78",
        "Rann na Feirste",
        "Rannafast",
        "rɑɴːəˈf′ařʃ̌ṭ′ĕ",
        "1954",
        "<i>Rannafast</i> on the coast, one of the bleakest spots in the west of Ireland, is still Irish-speaking.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "79",
        "Árainn Mhór",
        "Aranmore",
        "aːrɪn′ ˈwoːr",
        "1954",
        "There is still some Irish spoken in the southwestern part of the island. Our informants were more fluent in Irish than in English.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "80",
        "Leitir Mhic an Bhaird",
        "Lettermacaward",
        "ˈʟ′et′ər ik′ ə ˈwɑːrd",
        "1954",
        "There is hardly much Irish spoken in this area. My informant was almost as fluent in Irish as in English. The areas between points 77-78, 78-80 and 77-81 are English speaking.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "81",
        "Beifleacht",
        "Beflaght",
        "b′ɛflɑxt",
        "1954",
        "This place seems to be empty of habitation except for one solitary house. Our informant was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "82",
        "Cionn Garbh",
        "Kingarroo",
        "k′ɪɴ′garu",
        "1954",
        "<i>Kingarroo</i>, near <i>Fintown</i>, is still Irish-speaking. Our informants were equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "83",
        "Na Cruacha Gorma",
        "Croaghs",
        "ɴə kruəhə gɔrəmə",
        "1954 (speakers D and E) and 1964 (speakers A-C)",
        "This point, representing a remote valley of the <i>Blue Stack Mountains</i>, was the most inaccessible place I have visited in Ireland. It was, therefore, not surprising to find there were quite a number of monoglots, who could not speak a word of English. I have visited this area several times. Most of the young people have left it. The way of life has not changed here for hundreds of years. Rearing of sheep is the main occupation of the people.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "83a",
        "Dúbinn",
        "Doobin",
        "dïb′ɪɴ′",
        "1966",
        "[The informants] were all fluent Irish speakers.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "84",
        "Ard an Ratha",
        "Ardara",
        "ɑːrd ə ˈrɑː",
        "1954",
        "Only a few native speakers have survived in this area. My subject was more fluent in English than in Irish.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "85",
        "Mín an Chearrbhaigh",
        "Meenacharvy",
        "m′iːn′ ə ˈxɑːrwi",
        "1954",
        "Very little Irish is heard now in this mountain area but most of the people are native speakers of it. My informant was equally fluent in both languages.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "86",
        "Teilionn",
        "Teelin",
        "t′ʃel′o̤ɴ",
        "1954",
        "English has become predominant in this place recently, but everybody is still a native speaker of Irish. In <i>Glencolumbkill</i>, the area west of points 85, 86, the position of the language is about the same as in Teelin. Irish ceased to be the regular vernacular in <i>South West Donegal</i> some twenty years ago.",
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "86a",
        "Cionn na Coilleadh",
        "Kinnakillew",
        "k′aɴə ˈkïʟ′u.ʷ",
        "1954",
        null,
        null,
        null,
        (select id from area where display_id = "VIII")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "88",
        "Mannin",
        "Isle of Man",
        null,
        "1950",
        null,
        null,
        null,
        (select id from area where display_id = "IX")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "A",
        "Arainn",
        "Arann",
        null,
        "1961",
        null,
        null,
        null,
        (select id from area where display_id = "Appendix I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "B",
        "Cinn Tìre",
        "Kintyre",
        null,
        "1961",
        null,
        null,
        null,
        (select id from area where display_id = "Appendix I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "C",
        "Meadhan Earra Ghàidheal",
        "Mid-Argyll",
        null,
        "1965",
        "Native Gaelic speakers have become very scarce in the area covered by our survey.",
        null,
        null,
        (select id from area where display_id = "Appendix I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "D",
        "Beinn nam Fadhla",
        "Benbecula",
        null,
        "1958",
        "Gaelic is still the main language on this island. All our informants were over forty five years of age.",
        null,
        null,
        (select id from area where display_id = "Appendix I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "E",
        "Leòdhas",
        "Lewis",
        null,
        "1958",
        "Gaelic is still the main language on this island. Our main informants were well over sixty years of age.",
        null,
        null,
        (select id from area where display_id = "Appendix I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "F",
        "Ros an Iar",
        "Wester Ross",
        null,
        "1963",
        null,
        null,
        null,
        (select id from area where display_id = "Appendix I")
    );

insert into
    survey_point (
        display_id,
        ainm,
        name,
        transcription,
        year,
        language_position,
        other_fieldworker_notes,
        notes,
        area_id
    ) values (
        "G",
        "Asainte",
        "Sutherland",
        null,
        "1962",
        null,
        null,
        "Sutherland in English refers to a few traditional areas. The one surveyed here is known in English as <i>Assynt</i>, hence the choice of Gaelic name.",
        (select id from area where display_id = "Appendix I")
    );

/*
  Townlands and informants
*/
insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile na nGall",
        "Ballynagaul",
        "bɑl′ə nə ŋauɫ",
        52.0456,
        -7.56354,
        (select id from survey_point where display_id = "1")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Míchéal Traoin",
        "m′iˈhiːəɫ...",
        "about 75",
        "fisherman",
        "a",
        null,
        "This could be a speaker of the same name recorded as part of the Doegen project. You can read a short biography and listen to recordings of his speech at <a href=https://www.doegen.ie/node/2369>doegen.ie</a>. Although the birthplace doesn't match, the biography states his family moved to Ballynagaul as a child, and the age given in the LASID would agree with the birth year stated in the Doegen biography. Looking at census returns did not make me certain of them being the same person, however.",
        (select id from townland where ainm = "Baile na nGall")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Heilbhic",
        "Helvik",
        null,
        52.0511,
        -7.54365,
        (select id from survey_point where display_id = "1")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pats Cuddihy",
        "...kül′ihĕ",
        "about 70",
        "small farmer",
        "b",
        null,
        null,
        (select id from townland where name = "Helvik")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Tuartha an Airchinn",
        "Tooranaraheen",
        "tuər ən arəˈhiːn′",
        52.2035,
        -7.82666,
        (select id from survey_point where display_id = "2")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Brown",
        "ʃɑːn bruːn",
        "74",
        "small farmer",
        null,
        null,
        "Seán Brún",
        (select id from townland where name = "Tooranaraheen")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ré na dTiompán",
        "Reanadampaun",
        "rᴇː nə dauˈmpɑːn",
        52.232,
        -7.67781,
        (select id from survey_point where display_id = "3")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Ó Con-Fhaola",
        "ʃɑːn oː kïˈn′iːlɘ",
        "about 65",
        "small farmer",
        null,
        "He speaks both languages equally.",
        null,
        (select id from townland where name = "Reanadampaun")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cnoc Bhaile an Oidhre",
        "Knockballiniry",
        "knuk wɑl′əˈneir′ɘ",
        52.2622,
        -7.88117,
        (select id from survey_point where display_id = "4")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Míchéal Ó Maoldhamhna",
        "m′iːhɑːl oː məˈlounə",
        "63",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Knockballiniry")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Gleann Phádraig",
        "Glenpatrick",
        "g′l′ɑun ˈfɑːrik′",
        52.3214,
        -7.59573,
        (select id from survey_point where display_id = "5")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "William O'Hickey",
        null,
        "86",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where name = "Glenpatrick")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pat Haussey",
        null,
        "about 80",
        "inmate of home",
        "b",
        null,
        null,
        (select id from townland where name = "Glenpatrick")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Tulach Uí Bhroin",
        "Tullowbrin",
        null,
        52.7143,
        -7.17777,
        (select id from survey_point where display_id = "6")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Matthew Byrne",
        null,
        "84",
        null,
        "a",
        null,
        null,
        (select id from townland where name = "Tullowbrin")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Gleann Mór",
        "Glenmore",
        null,
        52.5163,
        -7.20006,
        (select id from survey_point where display_id = "6a")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Patrick Power",
        null,
        "92",
        null,
        "b",
        null,
        null,
        (select id from townland where name = "Glenmore")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cnoc an Dúin",
        "Knockadoon",
        null,
        -7.87118,
        51.881,
        (select id from survey_point where display_id = "7")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Tomás Ó Sé",
        "təˈmɑːs oː ʃèː",
        "about 75",
        "Has been small farmer and fisherman",
        "a",
        null,
        null,
        (select id from townland where name = "Knockadoon")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Máirtín Breathnach",
        "mɑ̨ːrt′iːn′ br̥ˈn′ax",
        "about 75",
        "Has been small farmer and fisherman",
        "b",
        null,
        null,
        (select id from townland where name = "Knockadoon")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dún Mór",
        "Dunmore",
        "duːn muər",
        51.5845,
        -8.87468,
        (select id from survey_point where display_id = "8")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Ó Donnabháin",
        "pɑːdrig′ oː duːnəvɑːn′",
        "about 70",
        "Informants described collectively as <i>small farmers and fishermen<i>",
        "a",
        null,
        null,
        (select id from townland where name = "Dunmore")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile an Ghleanna",
        "Ballinglanna",
        "ˈbɑl′ə ˈŋ′l′anə",
        51.5993,
        -8.81247,
        (select id from survey_point where display_id = "8")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál de Búrc",
        "m′iːˈhɑːl də buːrk",
        "about 70",
        "Informants described collectively as <i>small farmers and fishermen<i>",
        "b",
        null,
        null,
        (select id from townland where name = "Ballinglanna")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dún Eoghain",
        "Dunowen",
        "duːn ˈǫːn′ (or: duːn  ˈoːiŋ′; both forms were used by this speaker)",
        51.5473,
        -8.90803,
        (select id from survey_point where display_id = "8")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Donncha Ó Finn",
        "ˈdonəxə oː ˈfiːŋ′",
        "about 50",
        "Informants described collectively as <i>small farmers and fishermen<i>",
        "c",
        null,
        null,
        (select id from townland where name = "Dunowen")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Carraig na gCat",
        "Carrignagat",
        "kɑrig′ nə gɑt",
        51.549075,
        -9.083818,
        (select id from survey_point where display_id = "9")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Jerry Hayes",
        "d′iərmïd′ oː hèːə",
        "77",
        "retired sailor",
        null,
        null,
        "Diarmuid Ó hAodha",
        (select id from townland where ainm = "Carraig na gCat")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Muinigh",
        "Munnig",
        "mɪn′ig′",
        51.5223,
        -9.30508,
        (select id from survey_point where display_id = "10")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Ó hÉagartaigh",
        "ʃ̣ɑ̣ːn ǫː hɛːgərtig′",
        "80",
        "small farmer",
        null,
        "<i>Seán</i> has spent a long spell in America",
        null,
        (select id from townland where name = "Munnig")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ó hÉagartaigh",
        "m′iːhɑːl ǫː hɛːgərtig′",
        "87",
        "small farmer",
        null,
        "<i>Mícheál</i> has never left the place",
        null,
        (select id from townland where name = "Munnig")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Gort na Lobhar",
        "Gortnalour",
        "gort nə ˈlour",
        51.445,
        -9.4786,
        (select id from survey_point where display_id = "11")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Tadhg Ó Druisceóil",
        "töig′ oː drïˈs′ḳ′oːl′ or ...drɪˈʃḳ′oːl′",
        "75",
        "shopkeeper and small farmer",
        "a",
        null,
        null,
        (select id from townland where name = "Gortnalour")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cnocán na mBairneach",
        "Knockannamaurnagh",
        "kno̤ˈkɑːn nə ˈmɑːrn′əx",
        51.4484,
        -9.4827,
        (select id from survey_point where display_id = "11")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Cáit Ní Shíocháin",
        "kɑ̣t̠ n′iː hiːxɑːn′",
        "over sixty",
        null,
        "b",
        null,
        null,
        (select id from townland where ainm = "Cnocán na mBairneach")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Fearann Fada",
        "Farranfadda",
        "kno̤ˈkɑːn nə ˈmɑːrn′əx",
        51.7569,
        -9.47439,
        (select id from survey_point where display_id = "12")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Ó Ceócháin",
        "pɑːdərig′ ų k′ʲoːˈhɑːn",
        "83",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where ainm = "An Fearann Fada")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Drom an Chláraigh",
        "Dromaclarig",
        "droum ə xlɑːrig′",
        51.7291,
        -9.41926,
        (select id from survey_point where display_id = "12")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ó Súileabháin",
        "m′iːˈhɑːl oː suːl′əˈvɑːn",
        "over 80",
        "small farmer",
        "b",
        null,
        null,
        (select id from townland where name = "Dromaclarig")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Gleann Eo Trasna",
        "Glantrasna",
        "g′l′ɑun ɔː trɑːsnə",
        51.7774,
        -9.69315,
        (select id from survey_point where display_id = "13")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Feidhlime Mac Cártha",
        "f′eil′ɪm′ĕ mɑːˈkɑːrʰə",
        "66",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where name = "Glantrasna")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Eisc an Dobhair",
        "Eskadawer",
        "eʃḳ′ədour′",
        51.7645,
        -9.82156,
        (select id from survey_point where display_id = "13")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Ó Síocháin",
        "pɑːdrig′oː ʃiːxɑːn′",
        "79",
        "fisherman and small farmer",
        "b",
        null,
        null,
        (select id from townland where name = "Eskadawer")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile na Carraige",
        "Ballynacarriga",
        "bɑ̣l′ə nə karig′ĕ",
        51.594,
        -10.1471,
        (select id from survey_point where display_id = "14")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Patrick Harrington",
        "pɑːdrɪg′uːrdɪl′",
        "about 75",
        "small farmer",
        null,
        null,
        "Pádraig Úrdail",
        (select id from townland where name = "Ballynacarriga")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Doire an Chuilinn",
        "Derreenaculling",
        "dür′ĕ n̥ xül′iŋ′",
        51.9188,
        -9.23054,
        (select id from survey_point where display_id = "15")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ó Laoghaire",
        "m′iːˈhɑːl oː lèːr′ĕ ",
        "72",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Derreenaculling")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cnoc na Bró",
        "Knocknabro",
        "knuk nə brɔː",
        52.0062,
        -9.21576,
        (select id from survey_point where display_id = "16")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Cruimín",
        "m′iːˈhɑːl krïˈm′iːn′",
        "70",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Knocknabro")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Na hInsí",
        "Incheese",
        "iːn′ˈʃiːəs",
        51.9229,
        -9.32815,
        (select id from survey_point where display_id = "17")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Kate Carey",
        "kɑ̣ːt̠ n′iː xᵊrɑːn′",
        null,
        null,
        null,
        "maiden name: n′iː ɣɪˈŋ′iːn′ from iːn′ˈʃiːəs , now living in kuːm ə ˈxül′iŋ′[Coomacullen] near <i>Cloonkeen</i>[...]. Her father from whome she claims to have got most of her Irish comes from <i>Ballyvourney</i> (Co. Cork). Her speech, however, contains certain elements which are not typical of <i>Ballyvourney</i> Irish. They point to the dialect which was spoken long ago in the <i>Kilgarvan</i> area.",
        "Cáit Ní Chorráin(?). No age given, but cross-referencing the 1926 census in Coomacullen, her marriage record, and her birth record suggests she was born in 1867, and so would have been about 85. Maiden name is Ní Dhuinnín, anglicised as Dinneen. Birthplace is indexed on <a href=https://www.logainm.ie/en/22964>logainm.ie</a>, though name doesn't quite match, but it is listed as Inchees on <a href=https://www.irishgenealogy.ie/files/civil/birth_returns/births_1867/03491/2283171.pdf>birth record</a>, Incheese on Google Maps, and various other 's' ending names on historical records given on logainm.ie. No one in that townland or its DED filled in the 1926 census in Irish so I can't check what they wrote for the townland name that would match the pronunciation.",
        (select id from townland where name = "Incheese")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Imleach Draighneach",
        "Emlaghdreenagh",
        "ïm′l′əx drɪːənəx",
        51.8536,
        -10.2012,
        (select id from survey_point where display_id = "18")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Carey",
        null,
        "about 80",
        "shoemaker and small farmer",
        "a",
        null,
        null,
        (select id from townland where ainm = "Imleach Draighneach")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Imleach Mór",
        "Emlaghmore",
        null,
        51.8701,
        -10.2362,
        (select id from survey_point where display_id = "18")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Mhártain Ó Súileabháin",
        null,
        "about 50",
        "small farmer",
        "b",
        null,
        null,
        (select id from townland where ainm = "Imleach Mór")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Dónall Ó Murchú",
        null,
        "about 45",
        "small farmer",
        "c",
        null,
        null,
        (select id from townland where ainm = "Imleach Mór")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cill Choimhtheach",
        "Kilkeehagh",
        "kɪːl′xɪːhəx",
        52.0329,
        -10.027,
        (select id from survey_point where display_id = "19")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Párthalán Ó Muirchearta",
        "pɑːrhəlɑːn oː mürəhərətə",
        "84",
        "shopkeeper",
        "a",
        "now of Killorglin; has spent some time in America",
        null,
        (select id from townland where name = "Kilkeehagh")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cromán",
        "Cromane",
        "krŭmɑːn",
        52.1062,
        -9.89246,
        (select id from survey_point where display_id = "19")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ó Coisteala",
        "m′iːˈhɑːl oː kïs′ṭ′ələ",
        "80",
        "small farmer",
        "b",
        "His father, who is from <i>Milltown</i>, had no Irish. His mother is from <i>Cromane</i>.",
        null,
        (select id from townland where name = "Kilkeehagh")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Cheathrú",
        "Carhoo",
        "n̥ x′aˈrhuː",
        52.1382,
        -10.4582,
        (select id from survey_point where display_id = "20")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Donnchadh Ó Conchubhair and his son Tomás",
        "...konəˈxuːr′",
        null,
        null,
        null,
        null,
        null,
        (select id from townland where name = "Carhoo")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Lios na Caolbhuí",
        "Lisnakealwee",
        "l′ɪs nə kɛlˈvɪː",
        52.2764,
        -10.1878,
        (select id from survey_point where display_id = "21")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Ó Muirchearta",
        "pɑːdərig′oː mïr′əhərətə",
        "68",
        "retired policeman and small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Lisnakealwee")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cill Bheathach",
        "Kilbaha",
        "k′il′ ˈv′ahəx",
        52.5688,
        -9.85856,
        (select id from survey_point where display_id = "22")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mrs. B. Costello / Bríd, bean Uí Choisteala",
        "b′r′′iːd′, b′an iː xöʃṭ′ələ",
        "79",
        null,
        "a",
        "Maiden name: n′iː ɣɪːn′",
        "Maiden name looks like Ní Dhoinn, commonly anglicised as Dunne. <a href=https://www.irishgenealogy.ie/files/civil/marriage_returns/marriages_1895/10519/5831638.pdf>This</a> would appear to be her wedding record. Census of 1911 <a href=https://www.census.nationalarchives.ie/reels/nai001782157/>suggests</a> she did not give her Irish to her children.",
        (select id from townland where name = "Kilbaha")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Henry Blake",
        null,
        "80",
        null,
        "b",
        "Blind man",
        null,
        (select id from townland where name = "Kilbaha")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Corrbhaile",
        "Corbally",
        null,
        52.6986,
        -9.64493,
        (select id from survey_point where display_id = "22a")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Ó Briain",
        null,
        "about 80",
        "fisherman",
        null,
        null,
        null,
        (select id from townland where name = "Kilbaha")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dún na gCorr",
        "Doonnagore",
        "duːn ə ˈgoːr",
        53.0018,
        -9.38564,
        (select id from survey_point where display_id = "23")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ó Donnchú",
        "m′iːhɑːl oː do̤nəˈxuː",
        "about 75",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where name = "Doonnagore")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Luach",
        "Luogh",
        "lųːəx",
        52.9848,
        -9.41889,
        (select id from survey_point where display_id = "23")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Carey",
        "ʃɑːn kɑˈrųːᵊn",
        "about 90",
        "small farmer",
        "b",
        null,
        "This is likely the Seán Carún recorded as part of the Doegen project. You can find a short biography and links to audio recordings of his speech at <a href=https://www.doegen.ie/node/2289>doegen.ie</a>.",
        (select id from townland where ainm = "Luach")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Sráid na nIascairí",
        "Fisherstreet",
        null,
        53.0125,
        -9.38581,
        (select id from survey_point where display_id = "23")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Shannon",
        "ʃɑːn k′il′ˈtrɑːn",
        "over 70",
        "fisherman",
        "c",
        null,
        "The <a href=https://doegen.ie/node/2271>James Shannon</a> from the same area recorded by the Doegen project was known as Séamus a Ciolltráin. The transcription here has slender 'l' and broad 'n' but is clearly some variant of the same name.",
        (select id from townland where name = "Fisherstreet")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Doirín",
        "Derreen",
        "der′iːn′",
        53.087,
        -9.30569,
        (select id from survey_point where display_id = "24")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Carley",
        "ʃɑːn mɑˈkaril′ə",
        "about 50",
        "farm labourer",
        null,
        "Our informant in this area was the best speaker in <i>County Clare</i>. He had been brought up by his grandparents who did not know any English at all.",
        "Seán Mac Fhearaile",
        (select id from townland where name = "Fisherstreet")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Cheapach",
        "Cappagh",
        "ə ˈx′apɪ",
        54.6303,
        -8.66548,
        (select id from survey_point where display_id = "86")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Diarmaid Mac Seagháin",
        "d′ʒiərᵊmöd′<sup>ʒ</sup> mɑ̌k ˈʃaːn′",
        "62",
        null,
        null,
        null,
        "This appears to be the son of the speaker Tomás Mac Seagháin whose speech was recorded by the Doegen project. You can find his recordings at <a href=https://www.doegen.ie/node/2405>doegen.ie</a>. Ciarán Ó Duibhín has compiled a <a href=https://www3.smo.uhi.ac.uk/oduibhin/doegen/acseaghain_biog.htm>biography</a> of Tomás. Diarmaid was uncle to the folklorist Seán Ó hEochaidh.",
        (select id from townland where name = "Cappagh")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Mín an Chearrbhaigh",
        "Meenacharvy",
        "m′iːn′ ə ˈx′ɑːrwi",
        54.7182,
        -8.6178,
        (select id from survey_point where display_id = "85")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Cathal Ó Baoghail",
        "kahəl oː bɪːl′",
        "about 60",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Meenacharvy")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cnoc na gCapall",
        "Crocknagapple",
        "kʀo̤k nə gɑpəl",
        54.7217,
        -8.35102,
        (select id from survey_point where display_id = "84")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mary Herron",
        "mɑːr̠ə n′iː jɛrərɑn",
        "about 80",
        "small farmer's wife",
        null,
        null,
        "Not sure which Gaelic name is indicated by transcription. Maiden name transcription shows Ní Dhónaill, commonly anglicised as O'Donnell.",
        (select id from townland where name = "Crocknagapple")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cruach Mhín an Fheannta",
        "Croveenananta",
        "kruɪv′ɪːnə ɴ′aɴːta",
        54.7962,
        -8.08267,
        (select id from survey_point where display_id = "83")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Séamus Mac a' Lúin",
        "pʷɑːdrɪg′ ʃɛ̀məs mɑk ə ʟųːᵊn′",
        "27",
        null,
        "A",
        null,
        "Only two informants are listed in volume I of the LASID, but a further three are listed in volume IV. The labels given here are from volume IV.",
        (select id from townland where name = "Croveenananta")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micí Mac a' Lúin",
        "m′ɪk′ɪː mɑk ə ˈʟųːᵊɪn′",
        "70",
        null,
        "C",
        "father of speaker A",
        "Only two informants are listed in volume I of the LASID, but a further three are listed in volume IV. The labels given here are from volume IV.",
        (select id from townland where name = "Croveenananta")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cruach Leac",
        "Crolack",
        "krɔˈʟaᴋ",
        54.7877,
        -8.04629,
        (select id from survey_point where display_id = "83")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Bríd Ní Bhaoi",
        "b′r′ɪːd̠ n′i ˈwɪː",
        null,
        null,
        "B",
        null,
        "Only two informants are listed in volume I of the LASID, but a further three are listed in volume IV. The labels given here are from volume IV.",
        (select id from townland where name = "Crolack")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dúchruach",
        "Doocrow",
        "dûhrɔ̌ (dûʰrɔː)",
        54.7764,
        -8.09866,
        (select id from survey_point where display_id = "83")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Máire Nic Luain",
        "b′r′ɪːd̠ n′i ˈwɪː",
        "about 50",
        "small farmer's wife",
        "D",
        "she was born and reared in [Binn Mhór] [...] (parish of <i>Glenfinn</i>)",
        "Only two informants are listed in volume I of the LASID, but a further three are listed in volume IV. The labels given here are from volume IV.",
        (select id from townland where name = "Doocrow")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cruach Thiobraide",
        "Croaghubbrid",
        "kruəi ˈtoBəRd′ə",
        54.7882,
        -8.13037,
        (select id from survey_point where display_id = "83")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Séamas Mac Aoidh",
        "ʃeːməs mɑˈkyː  <i>or</i>  ...mɑˈkɪː",
        "about 40",
        "small farmer",
        "E",
        null,
        "Only two informants are listed in volume I of the LASID, but a further three are listed in volume IV. The labels given here are from volume IV.",
        (select id from townland where name = "Croaghubbrid")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cionn Garbh",
        "Kingarroo",
        "k′ɪɴ′garu",
        54.9068,
        -8.05274,
        (select id from survey_point where display_id = "82")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micheál Mac Geehin",
        "m′ihɑl məˈgyːhɪn′",
        "about 50",
        "small farmer and shopkeeper",
        null,
        null,
        null,
        (select id from townland where name = "Kingarroo")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Beifleacht",
        "Beflaght",
        "b′ɛflɑxt",
        54.9332,
        -8.13547,
        (select id from survey_point where display_id = "81")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Séamas Mac Kelvy",
        "ʃèːəməs ə ˈk′aluwi",
        null,
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Beflaght")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Tuaim",
        "Toome",
        "tuːəm′",
        54.8615,
        -8.31671,
        (select id from survey_point where display_id = "80")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Cathal Ó Gallachair",
        "kahəl (or tɑːrʟɑ) ɔ gɑʟəfïr′",
        "about 40",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Toome")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Athphort",
        "Aphort",
        "ɑ̣fɑrt",
        54.9806,
        -8.54248,
        (select id from survey_point where display_id = "79")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Cathal Ó Dónaill",
        "kahəl oː ˈdoːnəl′",
        "well over 60",
        "small farmer",
        null,
        null,
        "sibling of other main informants",
        (select id from townland where name = "Aphort")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Hugh Cathal Ó Dónaill",
        "ɪː oː ˈdoːnəl′",
        "well over 60",
        "small farmer",
        null,
        null,
        "sibling of other main informants",
        (select id from townland where name = "Aphort")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Iseabal Ní Dhónaill",
        "ɪʃəbal n′iː ɣoːnəl′",
        "well over 60",
        "small farmer",
        null,
        null,
        "sibling of other main informants",
        (select id from townland where name = "Aphort")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Máire Ní Dhónaill",
        "mʷɛ̀ːr′ə  n′iː ɣoːnəl′",
        "well over 60",
        "small farmer",
        null,
        null,
        "sibling of other main informants",
        (select id from townland where name = "Aphort")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Rann na Feirste",
        "Rannafast",
        "ɑːrd ə ˈt′ʃaɴtɪː (note: unsure what this refers to)",
        55.0382,
        -8.31253,
        (select id from survey_point where display_id = "78")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Bán Mac Grianna",
        "ʃɑ̣ːn ˈbɑːn mɑk ˈg′r′iːəɴə",
        "about 50",
        "small farmer",
        null,
        null,
        "You can listen to audio of this speaker on <a href=https://www.duchas.ie/en/cbef/tracks?PersonID=315677849>duchas.ie</a>.<br><br>Of the famous Mac Grianna family, brother to Seosamh and Séamus. Their father Feidhlimidh was recorded as part of the Doegen project. Ciarán Ó Duibhín has compiled a short biography of Feidhlimidh <a href=https://www3.smo.uhi.ac.uk/oduibhin/doegen/aggriannaf_biog.htm>here</a>, which has links to his recordings.",
        (select id from townland where name = "Rannafast")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Airdmhín",
        "Ardmeen",
        "er′ən ˈaːrd′in′",
        54.9715,
        -8.26509,
        (select id from survey_point where display_id = "77")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Breathnach",
        "ʃɑːn b′r′ãnʰa",
        "about 50",
        "small farmer",
        null,
        null,
        "John Walsh on 1926 census. The pronunciation of the townland was unexpected to me but matches a transcription on logainm.ie collected in 1973.",
        (select id from townland where name = "Ardmeen")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Muine Bheag",
        "Money Beg",
        "mïn′əˈv′øg",
        55.0308,
        -8.14794,
        (select id from survey_point where display_id = "76")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mánas Ferry",
        "mɑ̨ːnəs ɔ̨ ˈfɑri",
        "63",
        "weaver",
        null,
        null,
        "The official name for the townland has no lenition on Beag, but the informant pronounced it with lenition. I would expect <i>Muine</i> to be feminine, hence lenition is also expected anyway.",
        (select id from townland where name = "Money Beg")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile Thoir",
        "East Town",
        "bɑ̣l′ĕˈher̠ˀ",
        55.2576,
        -8.20913,
        (select id from survey_point where display_id = "75")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Jimmy Meenan",
        "ʃeːməs ɔ̨ ˈv′inan′",
        "over 50",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where ainm = "Baile Thoir")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile an Gheafta",
        "Gay Town",
        "bɑl′ə ˈɴ′ãφtə",
        55.1083,
        -8.13648,
        (select id from survey_point where display_id = "74")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Síle Ferry",
        "ʃiːl′ĕ n′iː ˈari",
        "over 70",
        null,
        null,
        null,
        null,
        (select id from townland where name = "Gay Town")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ceathramhadh na Madadh",
        "Carrownamaddy",
        "k′ɛ̀rʰu nə mɑdu",
        55.1308,
        -7.97258,
        (select id from survey_point where display_id = "73")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Cruchar 'Ac Fadden",
        "ˈkruhər ɑk ˈfɑd′in′",
        "76",
        "labourer",
        null,
        null,
        null,
        (select id from townland where name = "Carrownamaddy")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Droim na Coradh",
        "Drumnacarry",
        "drïᴍ′ː ɴə ˈkɑruφ",
        55.0853,
        -7.89738,
        (select id from survey_point where display_id = "72")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Charley Ó Gallagher",
        "tɑrʟɑ ɔ̨ ˈgɑʟəhər",
        "about 80",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Drumnacarry")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Na Dúnaibh",
        "Downings",
        "ɴə d.λnïf′",
        55.1952,
        -7.85705,
        (select id from survey_point where display_id = "71")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mánus Ó Heraghty",
        "ˈmɑːnəs oː ˈhɛrɑhti",
        "about 50",
        "owner of a public house",
        null,
        null,
        null,
        (select id from townland where name = "Downings")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Tor Leadáin",
        "Tirlaydan",
        "tɔ̨r ʟ′ɛdɑ̣n",
        55.1582,
        -7.59715,
        (select id from survey_point where display_id = "70")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Patrick Marly",
        "pɑːdrik′ niː [?] mɑrl′i",
        "over 80",
        "owner of a public house",
        "B",
        null,
        "The name on <a href=https://www.logainm.ie/en/15922>logainm.ie</a> for this informant's townland uses the word <i>tír</i>, but a low back vowel there would be very irregular. The broad /t/ would perhaps also be surprising. Hence I expect this is <i>tor leadáin</i>, 'clumps of burdock' perhaps. Perhaps some locals took it as <i>tír</i> and others as <i>tor</i>.<br><br>The question mark in the transcription of the informant's name is presumably questioning why it appears to be a feminine name.",
        (select id from townland where name = "Tirlaydan")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Na Mínte",
        "Meentagh",
        null,
        55.1476,
        -7.62117,
        (select id from survey_point where display_id = "70")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mrs. Margaret Canning",
        null,
        "c. 60 years",
        null,
        "A",
        null,
        null,
        (select id from townland where name = "Meentagh")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile Uí Fhuaruisce",
        "Ballyhooriskey",
        "bɑl′ə ˈwo̤rəsg̣i",
        55.2508,
        -7.75043,
        (select id from survey_point where display_id = "69")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Harry Shiel",
        null,
        "about 50",
        null,
        null,
        null,
        null,
        (select id from townland where name = "Ballyhooriskey")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Shiel",
        null,
        "about 50",
        null,
        null,
        null,
        null,
        (select id from townland where name = "Ballyhooriskey")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Mín Dobhráin",
        "Meendoran",
        "m′ïn′əˈdïfʔ",
        55.2314,
        -7.38139,
        (select id from survey_point where display_id = "68")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Charley Mac Loinsigh",
        null,
        "90",
        null,
        "a",
        null,
        "Not 100% certain on matching the transcription of the informant's townland to the correct place. This seemed most likely candidate. The 1926 census has him in the neighbouring townland of Rúscaigh, which he also lists as his origin.",
        (select id from townland where name = "Meendoran")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ardachaidh",
        "Ardagh",
        "ɑrdɑ",
        55.2881,
        -7.3985,
        (select id from survey_point where display_id = "68")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Biddy Doharty",
        null,
        "over 80",
        null,
        "b",
        null,
        null,
        (select id from townland where name = "Ardagh")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Claigeann",
        "Cleggan",
        "klag′ən",
        55.3077,
        -6.25398,
        (select id from survey_point where display_id = "67")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Dónall Mac Curdy",
        "dõːnəl məˈkïṛtṛi",
        "between 50 and 60",
        "farmer",
        null,
        "They live now [...] near <i>Ballycastle</i> on the mainland. Both could converse freely in their native language.",
        "brother to other informant",
        (select id from townland where name = "Cleggan")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Mac Curdy",
        "joːn′ məˈkïṛtṛi",
        "between 50 and 60",
        "farmer",
        null,
        "They live now [...] near <i>Ballycastle</i> on the mainland. Both could converse freely in their native language.",
        "Brother to other informant. Transcription of 'John' indicates Eóin.",
        (select id from townland where name = "Cleggan")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Creagán",
        "Creggan",
        "krögən",
        54.6539,
        -7.02487,
        (select id from survey_point where display_id = "66")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Peadar Ó hEachadh",
        "p′ödər ə ˈhɑːu",
        null,
        "small farmer",
        null,
        "He was more fluent in English than in Irish",
        null,
        (select id from townland where name = "Creggan")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Bábhún",
        "Bawn",
        "bɑːwən′",
        53.8945,
        -6.4557,
        (select id from survey_point where display_id = "65")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Anna O'Hanlon",
        null,
        "78",
        null,
        null,
        "Our informant could not converse freely in the language anymore. She had been brought up by an old aunt (<i>Alice Dobbin</i>) who had no English. Mrs. <i>O'Hanlon's</i> mother did not speak Irish to her daughter.",
        null,
        (select id from townland where name = "Bawn")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ceathrú na Madradh",
        "Carrownamaddra",
        "k′arhu. nə ˈmɑːdərə",
        53.1327,
        -8.97603,
        (select id from survey_point where display_id = "25")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Tomás Ó Con Fhaola",
        "tomɑːs oː koˈnɪːlə <i>or</i> kïn′ɛl′ə",
        "83",
        "small farmer (he has also been an interpreter in the court)",
        null,
        null,
        null,
        (select id from townland where name = "Carrownamaddra")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Gabhail Rua",
        "Gilroe",
        "gɑ̨ul ˈruː",
        52.9857,
        -8.80736,
        (select id from survey_point where display_id = "26")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Páraic Uí Dhonncha",
        "pɑːrik′ iː ɣonəxə",
        "about 80",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where name = "Gilroe")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Caithríní Beaga",
        "Carheeny Beg",
        "kar′hiːn′i b′eg",
        52.9966,
        -8.82715,
        (select id from survey_point where display_id = "26")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Malachy Ó Cotháin",
        "məˈl′axnən oː kohɑːn",
        "about 80",
        "small farmer",
        "b",
        null,
        null,
        (select id from townland where name = "Carheeny Beg")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ó Cotháin",
        "m′iːhɑːl oː kohɑːn",
        "about 80",
        "small farmer",
        "c",
        null,
        null,
        (select id from townland where name = "Carheeny Beg")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Maigh Ghlas",
        "Moyglass",
        "mɪːl ˈɣlɑs",
        53.0698,
         -8.4779,
        (select id from survey_point where display_id = "27")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pat Cooney",
        "pɑːrik′ oː (<i>or</i> iː) ˈxuənə",
        "about 80",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Moyglass")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Sonnach",
        "Sonnagh",
        "sonəx",
        53.1389,
        -8.61508,
        (select id from survey_point where display_id = "28")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Kelly",
        "ʃɑːn oː ˈk′alə",
        "78",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where ainm = "Sonnach")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Manainn Ard",
        "Manninard",
        "ˈmɑnən ˈɑːrd",
        53.1953,
        -8.76633,
        (select id from survey_point where display_id = "29")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Martin Furey",
        "mɑːrt′in′ ɪː ˈųːrə",
        "87",
        "farmer",
        null,
        null,
        null,
        (select id from townland where ainm = "Manainn Ard")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Poll an Chrosáin",
        "Colmanstown",
        "ˈpol ən ˈxro̤sɑn",
        53.3923,
        -8.60542,
        (select id from survey_point where display_id = "30")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Tomás Nólachán",
        "ˈtomɑːs ˈnoːləxɑːn",
        "about 75",
        null,
        null,
        "He lives now in l′ahənəx near <i>Castleblakeney</i>.",
        null,
        (select id from townland where ainm = "Poll an Chrosáin")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Bóthar Beannach",
        "Boherbannagh",
        "boːxər ˈb′anəx",
        53.5245,
        -8.44185,
        (select id from survey_point where display_id = "31")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mary Hogan",
        "mɑːr̠ə n′iː ˈhoːgɑːn",
        "81",
        "wife of small farmer",
        null,
        "born in krɪːv ˈruː, brought up by her grandparents (from whom she got her Irish). Maiden name n′iː ˈgɑːvɑːn′",
        "Maiden name is probably Ní Ghábháin though it lacks lenition. Usually anglicised as Gavin or Caulfield.",
        (select id from townland where name = "Boherbannagh")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ceathrú an Tairbh",
        "Carrowntarriff",
        null,
        53.4488,
        -8.2268,
        (select id from survey_point where display_id = "32")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Mac Gátlaigh (Paitín Phait Sheáin)",
        null,
        "about 90",
        null,
        "a",
        null,
        null,
        (select id from townland where name = "Carrowntarriff")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Séamas Ó Cuinn",
        "...kɪːn′",
        "about 70",
        null,
        "b",
        null,
        null,
        (select id from townland where name = "Carrowntarriff")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Camdhoire",
        "Camderry",
        "kɑmv̠er′ĕ",
        53.5632,
        -8.43325,
        (select id from survey_point where display_id = "33")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Éamonn Mac Thaidhg",
        "ˈèːmən mɑːk ˈhEig′",
        "about 80",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where name = "Camderry")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Dan Daly and his wife",
        null,
        null,
        null,
        "b",
        null,
        null,
        (select id from townland where name = "Camderry")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Caiseal",
        "Cashel (near Glenmaddy)",
        "kaʃəl",
        53.626149,
        -8.617415,
        (select id from survey_point where display_id = "34")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Martin Collins",
        "mɑːrt′in′ oː klɑːn",
        "83",
        "small farmer (bailiff in youth)",
        null,
        null,
        null,
        (select id from townland where name = "Cashel (near Glenmaddy)")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile an Locháin",
        "Ballinloughaun",
        "bal′ə nə ˈlo̤kɪː",
        53.3268,
        -8.82103,
        (select id from survey_point where display_id = "35")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Delaney",
        "ʃɑːn oː do̤vˈl′anə",
        "80",
        null,
        null,
        "This speaker was recorded in the county home of Loughrea along with two other speakers from the same area.",
        "Transcription shows Seán Ó Dubhshláine",
        (select id from townland where name = "Ballinloughaun")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Droim Bán",
        "Drumbaun",
        "dro̤m ˈbɑːn",
        53.3868,
        -8.94797,
        (select id from survey_point where display_id = "36")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micheál Ó Dúgáin",
        "",
        null,
        null,
        "2",
        null,
        null,
        (select id from townland where name = "Drumbaun")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Caisleán na Craoibhín",
        "Castlecreevy",
        "kïʃl′ɑːnə krɪːv′iːn′",
        53.3968,
        -9.00976,
        (select id from survey_point where display_id = "36")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "D. Cawfield",
        "doːnəl mɑkïlˈgɑunə",
        "about 60",
        "small farmer",
        "1",
        null,
        null,
        (select id from townland where name = "Castlecreevy")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Carn Mór",
        "Carnmore",
        "kɑːr ˈmoːr",
        53.3191,
        -8.88581,
        (select id from survey_point where display_id = "37")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Labhrás Ó Donnchadh",
        "lɑurəs oː donəχuː",
        null,
        null,
        "2",
        null,
        null,
        (select id from townland where name = "Carnmore")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cill Torróg",
        "Kiltroge",
        "k′il′təroːg",
        53.3443,
        -8.90657,
        (select id from survey_point where display_id = "37")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Ó Gráinne",
        "pɑːrik′ oː grɑːN′ə",
        null,
        null,
        "2",
        null,
        null,
        (select id from townland where name = "Kiltroge")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Pháirc Gharbh",
        "Parkgarve",
        "n̥ fɑ:rk′ ɣarŭʷ",
        53.3885,
        -8.81863,
        (select id from survey_point where display_id = "37")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "William Flaherty",
        "l′iːəm oː ˈflɑhərtə",
        "about 60",
        "small farmer",
        "a",
        null,
        "Líam Ó Flatharta, perhaps",
        (select id from townland where name = "Parkgarve")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Páraic Ó Síoda",
        "pɑːriḳ′ oː ʃiːdə",
        null,
        "small farmer",
        "b",
        "brother of informant Micheál Ó Síoda. Called pɑt′ʃ and maik′ ə ˈt′iːdi.",
        null,
        (select id from townland where name = "Parkgarve")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micheál Ó Síoda",
        "m′ix′ɑːl oː ʃiːdə",
        null,
        "small farmer",
        "b",
        "brother of informant Páraic Ó Síoda. Called pɑt′ʃ and maik′ ə ˈt′iːdi.",
        null,
        (select id from townland where name = "Parkgarve")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Gort an Chalaidh",
        "Angliham",
        "gort ə ˈxɑlə",
        53.3232,
        -9.05601,
        (select id from survey_point where display_id = "38")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Small",
        "ʃɑːn b′øgləx",
        "over 80",
        "small farmer",
        null,
        null,
        "Seán Beaglach, perhaps",
        (select id from townland where ainm = "Gort an Chalaidh")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Leamhchoill",
        "Laughil",
        "ʟ′ɑũxəl′",
        53.306,
        -9.21998,
        (select id from survey_point where display_id = "39")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Tomás Breathnach",
        "to̤mɑːs b′r′anəx",
        "about 80",
        "he had been a labourer in Galway City",
        null,
        null,
        null,
        (select id from townland where ainm = "Leamhchoill")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Lochán Beag",
        "Laughanbeg",
        "n̥ loxɑːn b′øg",
        53.252,
        -9.40699,
        (select id from survey_point where display_id = "40")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Ó Tuairisc",
        "ʃɑːn oː tuər′iʃḳ′",
        "about 60",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where name = "Laughanbeg")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Teach Mór",
        "Ballinteemore",
        null,
        53.2383,
        -9.41785,
        (select id from survey_point where display_id = "40")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ging",
        null,
        null,
        "small farmer",
        "b",
        "He could not converse freely in English. <i>Ging</i> has been <i>de Bhaldraithe's</i> chief informant (cf. the latter's 'The Irish of Cois Fhairrge', Dublin 1945, p.xii.",
        null,
        (select id from townland where ainm = "An Teach Mór")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile an Fhormna",
        "Baile an Fhormna",
        null,
        53.061622,
        -9.509851,
        (select id from survey_point where display_id = "41")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ó Con Fhaola Éamonn",
        "ˈm′iːɑ.l ə ˈko̤nɪːlə ˈeːmən",
        "about 65",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where ainm = "Baile an Fhormna")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ceathrú an Teampaill",
        "Carrowntemple",
        "k′aru. n̥ t′ʃɑːmpɪl′",
        53.0853,
        -9.59837,
        (select id from survey_point where display_id = "42")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Patrick Conneely Mícheál",
        null,
        "73",
        null,
        "a",
        null,
        null,
        (select id from townland where name = "Carrowntemple")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ceathrú an Lisín",
        "Carrownlisheen",
        "k′aru. n̥ ʟ′ɛʃiːn′",
        53.081,
        -9.58229,
        (select id from survey_point where display_id = "42")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mrs. Kate Flaherty (Roger)",
        null,
        "78",
        null,
        "b",
        null,
        null,
        (select id from townland where name = "Carrownlisheen")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Pádraig Ó Briain",
        null,
        "78",
        null,
        "d",
        null,
        "No townland was listed for this informant, but the 1926 census finds him in Carrownlisheen.",
        (select id from townland where name = "Carrownlisheen")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile an Mhúir",
        "Moher",
        null,
        53.0848,
        -9.58175,
        (select id from survey_point where display_id = "42")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Séamas Ó Cúláin",
        null,
        "58",
        null,
        "c",
        null,
        null,
        (select id from townland where name = "Moher")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cill Éinne",
        "Killeany",
        null,
        53.1078,
        -9.66403,
        (select id from survey_point where display_id = "42")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Uí Dhónaill",
        "ʃɑːn iː ɣuːnəʟ′",
        null,
        null,
        "e",
        null,
        "No townland given for this informant, but the parish of Oileán Árainn is given. From the 1926 census, the townland is likely either Killeany or Oghill. The former seemed marginally more likely to me hence I chose it.",
        (select id from townland where name = "Killeany")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Cheathrú Rua",
        "Carraroe",
        "ən x′arhuː ˈruːə",
        53.2659,
        -9.60299,
        (select id from survey_point where display_id = "43")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Marcas 'a Búrca",
        "mɑrkəs ə ˈbuːrkə",
        "over 70",
        null,
        null,
        "The interrogation took place in the county home of <i>Loughrea</i>.",
        null,
        (select id from townland where name = "Carraroe")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile na Cille",
        "Ballynakill",
        "bɑl′ə nə k′ɪʟ′ə",
        53.2431,
        -9.7107,
        (select id from survey_point where display_id = "43a")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Séamus O Cualáin",
        "ʃeːməs oː kuːᵊlɑːn′",
        "85",
        "small farmer and fisherman",
        null,
        null,
        null,
        (select id from townland where name = "Ballynakill")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ros Muc",
        "Rosmuck",
        "ros ˈmuk",
        53.3393,
        -9.60606,
        (select id from survey_point where display_id = "44")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "M. Maude",
        "m′iːhɑːl oː ˈmɑːv",
        "about 50",
        "labourer in <i>Galway City</i>",
        null,
        null,
        null,
        (select id from townland where name = "Rosmuck")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Gleann Trasna",
        "Glentrasna, near Screeb",
        "g′l′ɑːn t̠r̠asnə",
        53.4026,
        -9.5253,
        (select id from survey_point where display_id = "45")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Ó Con Fhaola",
        "...ə kəˈnɪːlə",
        "90",
        "small farmer",
        null,
        "reared in <i>Glentrasna</i>, born in g′l′iːn′ ˈɣɑ̨ulə, three miles from <i>Oughterard</i> [...] He lives now in <i>Oughterard</i>. He lived in America for some time.",
        null,
        (select id from townland where ainm = "Gleann Trasna")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Coillín",
        "Cuilleen",
        "køl′iːn′",
        53.3352,
        -9.85602,
        (select id from survey_point where display_id = "46")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Páraic Mac an Iomaire",
        "ˈpɑːrɪk′ ˈmɑːk ə ˈɴ′o̤mir′ĕ",
        "over 80",
        "small farmer",
        null,
        "Father of other informant",
        null,
        (select id from townland where ainm = "Coillín")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Ciarán Mac an Iomaire",
        "k′iːᵊrɑːn ˈmɑːk ə ˈɴ′o̤mir′ĕ",
        "about 45",
        "small farmer",
        null,
        "Son of other informant",
        null,
        (select id from townland where ainm = "Coillín")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dumhaigh Shalach",
        "Doohulla",
        "dɔhələ",
        53.4191,
        -10.0349,
        (select id from survey_point where display_id = "47")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "T. Mulkerin",
        "ˈto̤mɑːs oː mʷïʟ′hiərɑːn",
        null,
        null,
        null,
        null,
        null,
        (select id from townland where name = "Doohulla")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Leitir Beag",
        "Letterbeg",
        "ʟ′et′ər b′jög",
        53.5848,
        -10.0263,
        (select id from survey_point where display_id = "48")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Nóra Heanue",
        "ˈnuːrə n′iː ˈeːn′.u",
        null,
        "small farmer's widow",
        null,
        null,
        null,
        (select id from townland where name = "Letterbeg")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "(?) i gCarraig",
        "Carrick East",
        "ɛr′ə ˈgɑ̣rig′",
        53.5209,
        -9.41334,
        (select id from survey_point where display_id = "49")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Máire Breathnach",
        "mɑːr′ĕ v′r′anhəx",
        "well over 80",
        "small farmer's widow",
        null,
        null,
        "I had some difficulty matching up the townland transcription with a place. I believe the informant was born in Carrick in 1871 to James Cavanagh and Mary Connelly. She married a husband of the name Thomas Holloran, but he died sometime before the 1901 census. In 1903 she married Patrick Walsh.",
        (select id from townland where name = "Carrick East")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Seanadh Farracháin",
        "Shanafaraghaun",
        "ʃanəfar′əxɑːn",
        53.5866,
        -9.56916,
        (select id from survey_point where display_id = "50")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Stiofán Joyce",
        "ʃṭ′ïfɑːn ʃoːjə",
        "about 75",
        null,
        null,
        "Our informant who had spent some time in America was equally fluent in both languages. The interrogation took place in the county home of <i>Loughrea</i>.",
        "Joyce is an anglicisation of Seoighe",
        (select id from townland where ainm = "Seanadh Farracháin")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ceapaigh Dhuibh",
        "Cappaghduff",
        "k′apəˈɣöf′",
        53.644613,
        -9.381566,
        (select id from survey_point where display_id = "51")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micheál de Búrca",
        "m′ihɑːl də buːrkə",
        "about 75",
        "shopkeeper and small farmer",
        null,
        "Some words were recorded for me by Seán de Búrca (University College of Galway) who is a native of <i>Tourmakeady</i>. His notations are given in brackets.",
        null,
        (select id from townland where name = "Cappaghduff")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dumhach Mhic Eoghain",
        "Doughmakeon",
        "dəv′iˈk′oːn′",
        53.7459,
        -9.87466,
        (select id from survey_point where display_id = "52")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micheál 'a Búrca",
        "m′ɪhɑːl ə bųːrkə",
        "83",
        null,
        null,
        null,
        null,
        (select id from townland where name = "Doughmakeon")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Bun na nAeú",
        "Bunanioo",
        "bo̤nəˈnəjo",
        53.8836,
        -9.913,
        (select id from survey_point where display_id = "53")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micheál Ó Caiticin",
        "m′ihɑːl oː kat′ik′in′",
        "63",
        "small farmer",
        null,
        null,
        null,
        (select id from townland where name = "Bunanioo")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Sáile",
        "Salia",
        "sɑːl′ə",
        53.9497,
        -9.93946,
        (select id from survey_point where display_id = "54")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mártain 'ac Meanman",
        "...m′anəmən",
        "72",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where ainm = "Sáile")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Bríd Ní Gaointí Seán",
        "b′r′′iːd′ ɴ′iː giːnti [sic!] ʃɑːn",
        "76",
        "small farmer",
        "b",
        null,
        "I'm not sure what 'sic' note in the transcription refers to, either the broad 'n' and 't' in the pronunciation of Gaointí, or the nominative rather than genitive on Seán. The latter seems more likely to me, and perhaps less arrogant for Wagner to point out something outside of grammatical norms than to suggest someone was pronouncing their own surname incorrectly.",
        (select id from townland where ainm = "Sáile")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mrs. Rose Mac Sweeney",
        null,
        "64",
        "small farmer",
        "c",
        null,
        null,
        (select id from townland where ainm = "Sáile")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Owen Patten",
        null,
        "55",
        "boatmaker",
        "d",
        null,
        null,
        (select id from townland where ainm = "Sáile")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dumha Thuama",
        "Dohooma",
        "dəˈhuːmə",
        54.0713,
        -9.94814,
        (select id from survey_point where display_id = "55")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "A. Munnelly",
        "antən′ə oː mo̤rˈiːl′ə",
        "68",
        "small farmer",
        "a",
        null,
        "He gives his townland as bo̤n ə ˈtoli but I wasn't sure where this referred to. Census shows him in Dohooma.",
        (select id from townland where name = "Dohooma")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dumha Locha",
        "Doolough",
        "dųːˈlǫx <i>or</i> dųːˈlɑxə",
        54.1333,
        -9.90992,
        (select id from survey_point where display_id = "55a")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Caitilín Ní Bháile",
        "ˈkat′ʃəl′iːn′ n′iː ˈwɑːl′ə",
        "over 90",
        null,
        "b",
        null,
        null,
        (select id from townland where name = "Doolough")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Na hAicilleacha, Glais",
        "Nakil or Surgeview, Glash",
        "nə ˈhak′əl′əxɪ, glɑ̣ʃ",
        54.101,
        -10.1237,
        (select id from survey_point where display_id = "56")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Páraic Breathnach",
        "pɑːrɪk′ b′r′anhəx",
        "67",
        "fisherman",
        null,
        "He comes from <i>Inishkea South</i>.",
        "I had some difficulty identifying the townland from the transcription, but I'm fairly confident that he is saying Na hAicilleacha, though I haven't seen that precise name written anywhere.",
        (select id from townland where ainm = "Na hAicilleacha, Glais")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Port an Chlóidh",
        "Portacloy",
        null,
        54.3319,
        -9.77007,
        (select id from survey_point where display_id = "57")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Nóra de Búrca and her son Tomás",
        "ɴoːrə də buːrkə; <i>maiden name:</i>: ɴoːrə n′iː höig′",
        "about 75",
        "fisherman's widow",
        null,
        "<i>Nóra</i> was born in <i>Carrowteigue</i>.",
        null,
        (select id from townland where name = "Portacloy")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Gaobhrán",
        "Geevraun",
        "gɪːwərɑːn",
        54.3142,
        -9.57022,
        (select id from survey_point where display_id = "58")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "T. Mac Ale",
        "ˈto̤mɑːs məˈkeːl′ə",
        "60",
        null,
        null,
        null,
        null,
        (select id from townland where ainm = "Gaobhrán")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mícheál Ó Neachtain",
        "ˈm′iːhɑːl oː ˈɴ′axtən′",
        "about 45",
        null,
        null,
        null,
        null,
        (select id from townland where ainm = "Gaobhrán")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ráth Leacain",
        "Rathlacken",
        "ǫun ˈʟ′akəx (unclear what this refers to)",
        54.2951,
        -9.27946,
        (select id from survey_point where display_id = "59")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "P. Mac Goldrick",
        "pɑːrɪk′ mɑˈgoːrl′ik′",
        "about 80",
        "fisherman",
        "a",
        null,
        null,
        (select id from townland where name = "Rathlacken")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cill Ardubh",
        "Killerduff",
        "k′iʟ′ərˈdo̤f",
        54.2929,
        -9.3900,
        (select id from survey_point where display_id = "59")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mártan Ó Dochartaigh",
        "mɑːrtən oː ˈdohərti",
        "about 80",
        null,
        "b",
        null,
        null,
        (select id from townland where name = "Killerduff")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Baile an Chnoic",
        "Ballyknock",
        "bɑl′əˈxrɪk′",
        54.2842,
        -9.40336,
        (select id from survey_point where display_id = "59")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micheál Gever",
        "ˈm′ihɑːl ə ˈg′ïv′ər′",
        "80",
        null,
        "c",
        null,
        null,
        (select id from townland where name = "Ballyknock")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Lios an Uisge",
        "(somewhere in Kilmacteige parish, could not identify)",
        "ʟ′ïs ə ′ɴɪʃg′ə",
        54.069,
        -8.89097,
        (select id from survey_point where display_id = "60")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Micheál 'c an Ultaigh",
        "m′ihɑːl kəˈɴo̤ltɪː",
        "78",
        "small farmer",
        "a",
        null,
        null,
        (select id from townland where ainm = "Lios an Uisge")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Coill Dá Lao",
        "Culdaly",
        "ko̤l n̥ dɑː ʟẹː",
        54.0359,
        -9.00288,
        (select id from survey_point where display_id = "60")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Bríd Ní Cunney",
        "b′ʲiːd′ n′iː kïɴ′ːər′",
        "87",
        "small farmer",
        "b",
        null,
        null,
        (select id from townland where name = "Culdaly")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Áth an Chláir",
        "Aclare",
        "ɑ. ˈxlɑːr′",
        54.0358,
        -8.90059,
        (select id from survey_point where display_id = "60")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Seán Mac Giltey",
        null,
        "about 60",
        "small farmer",
        "c",
        "from near <i>Aclare</i>",
        null,
        (select id from townland where name = "Aclare")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Tulaigh na gClog",
        "Tullanaglug",
        "to̤ʟə nə ˈglǫg",
        54.047,
        -8.78703,
        (select id from survey_point where display_id = "61")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Patrick Ó Floinn",
        "pɑːrɪk′ ǫː flïɴ′",
        "81",
        null,
        "a",
        null,
        null,
        (select id from townland where name = "Tullanaglug")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Choraidh",
        "Curry",
        null,
        53.9964,
        -8.76431,
        (select id from survey_point where display_id = "61")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Bríd Ní Mac an Bheithigh",
        "b′iːd′ ɴ′iː mɑkəˈv′ehi",
        "87",
        null,
        "b",
        null,
        null,
        (select id from townland where name = "Curry")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Sgeithín",
        "Skeheen",
        "sgeˈhiːn′",
        53.9046,
        -8.66971,
        (select id from survey_point where display_id = "62")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Séamas Páraic Ó Duffy",
        "ʃeːməs pɑːrik′ oː do̤fi",
        "83",
        null,
        null,
        null,
        null,
        (select id from townland where name = "Skeheen")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Doirín na gCaor",
        "Combhill or Derreenageer",
        "dörnəˈg′iər",
        54.1652,
        -7.99558,
        (select id from survey_point where display_id = "63")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Hubert Forde",
        "...mɑk ə ˈnaũwe",
        "84",
        "small farmer",
        null,
        "He lives now near <i>Easkey</i>, Co. <i>Sligo</i>. <i>Hubert Forde</i> claims to have picked up his Irish from his grandfather who was a poet (<i>file</i>).",
        "The informant seems to have contributed to the Schools' Collection <a href=https://www.duchas.ie/en/cbes/4605946/4604709/4650754?Route=stories>here</a>.",
        (select id from townland where ainm = "Doirín na gCaor")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Mullach",
        "Mully",
        "mo̤ʟːi <i>or</i> mo̤ʟːɑx",
        54.2008,
        -7.90369,
        (select id from survey_point where display_id = "64")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Bríd Magavern",
        "b′r′′iːd′ʒ mɑˈgɔurɑːn",
        "over 90",
        null,
        "a",
        null,
        null,
        (select id from townland where ainm = "Mullach")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Owen Magavern",
        "oːn sɑurɑːn [corr.?]",
        "over 90",
        null,
        "b",
        null,
        null,
        (select id from townland where ainm = "Mullach")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Bàinleacainn",
        "Banlicken",
        "bɑ̣.n ɫe.k̠ïn",
        55.604,
        -5.3826,
        (select id from survey_point where display_id = "A")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Henderson",
        "i.ən mə kẹ.nrïk′",
        "75",
        "retired farmer",
        null,
        "The chief informant was John Henderson (75), who was also an informant (Imachar 5) for Nils M. Holmer's <i>The Gaelic of Arran</i>, Dublin, 1957, see pp. 3-4. [...] He now lives at Auchincarr, Machrie.",
        "You can listen to recordings of this informant on <a href=https://www.tobarandualchais.co.uk/search?l=en&search%5Bterm%5D=%22Henderson%2C+John+%284368%29%22&search%5Btype%5D=archival_object>tobarandulchais.co.uk</a>. Colm Ó Baoill gives his name as Iain MacEannraig.",
        (select id from townland where name = "Banlicken")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Druid",
        "Druid",
        null,
        55.574130,
        -5.345690,
        (select id from survey_point where display_id = "A")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Donald Craig",
        "ˈdǫːɫ ək ɑ̆ ˈxɑ'rɪg′",
        "61",
        "farmer",
        null,
        "Holmer's Machrie 3",
        "The local language died with Donald in 1977. Colm Ó Baoill gives his name as Dòmhnall Mhac a’ Charraig.",
        (select id from townland where name = "Druid")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Lag Iain",
        "Laggian",
        "ˈʟɑ̣d′̨ ˈi.aɴ′",
        55.496874,
        -5.317943,
        (select id from survey_point where display_id = "A")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John Robertson",
        "ˈi.ən′ mək ˈrǫːḅ",
        "90",
        "carpenter",
        null,
        null,
        "You can listen to recordings of this informant at <a href=https://www.tobarandualchais.co.uk/search?l=en&search%5Bterm%5D=%22Robertson%2C+John%2C+1871-%3F+%285654%29%22&search%5Btype%5D=archival_object>tobarandualchais.co.uk</a>. Thank you to George Broderick for corresponding with me about the placename. I find the transcription of the final consonant in 'Lag' surprising. You can hear him say it about 2 minutes into <a href=https://www.tobarandualchais.co.uk/track/43260?l=en>this recording</a>, where it sounds more like I would expect. Colm Ó Baoill gives the informant's name as Iain MacRòib.",
        (select id from townland where ainm = "Lag Iain")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dùn Crannaig, Càradal",
        "Duncrannaig, Carradale",
        null,
        55.591653,
        -5.463947,
        (select id from survey_point where display_id = "B")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Neil MacDougall",
        "j̃i.əɫ maχ kuːɪʟ′",
        "79",
        "retired fisherman",
        "a",
        "He was Holmer's informant Carradale I for his <i>The Gaelic of Kintyre</i>, Dublin, 1962, see pp. 3-4.",
        "You can listen to recordings of this informant at <a href=https://www.tobarandualchais.co.uk/search?l=gd&search%5Bterm%5D=%22MacDougall%2C+Neil%2C+1878-1970+%284139%29%22&search%5Btype%5D=archival_object>tobarandualchais.co.uk</a>. Colm Ó Baoill gives his name as Niall MacDhùghaill.",
        (select id from townland where name = "Duncrannaig, Carradale")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Tairbeart, Loch Fìne",
        "Tarbert, Loch Fyne",
        "tɛrəbəṣt",
        55.863246,
        -5.415608,
        (select id from survey_point where display_id = "B")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mary MacKinnon",
        "mɪːr′i mɑx k′ïnəɴ",
        "85",
        "farmer's wife",
        "b",
        "When recorded she was a patient in hospital in Campbeltown.",
        "Colm Ó Baoill gives her name as Mary MacFhionghain",
        (select id from townland where name = "Tarbert, Loch Fyne")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Muasdal",
        "Muasdale",
        "mu.ăsdəɫ",
        55.599520,
        -5.684687,
        (select id from survey_point where display_id = "B")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Neil Thomson",
        "ˈnʲɪ.ɑɫ mèk′ ˈhoːmɑʃ",
        "56",
        "fisherman",
        "c",
        "He was Holmer's Largieside 12.",
        "Colm Ó Baoill gives the informant's name as Niall MacThòmais",
        (select id from townland where name = "Muasdale")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cill Eathain",
        "Killean",
        "kïˈʟ′ɛïn (with slight hiatus between ɛ and ï)",
        55.640111,
        -5.664694,
        (select id from survey_point where display_id = "B")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Alexander Macalister",
        "ɑlɪsṭər mə kɑlɪsṭər",
        "81",
        "retired marine engineer",
        "d",
        "now living in Campbeltown",
        "Colm Ó Baoill gives the informant's name as Alasdair MacAlasdair",
        (select id from townland where name = "Killean")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "George Thomson",
        null,
        "53",
        "gamekeeper",
        "e",
        "cousin of (c)",
        "Lexical items collected from someone who is likely this informant are available at <a href=https://dasg.ac.uk/fieldwork/view/TXVhc2RhbGVHVGhvbXNvbm1pc2N8c2dhcmJofGlkcDExNTM4MjIyNHx8Z2FyfHI1Mjh8fHw=>dasg.ac.uk</a>.",
        (select id from townland where name = "Muasdale")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Apainn",
        "Apinn",
        "Nɑxbɪn′",
        56.562222,
        -5.358889,
        (select id from survey_point where display_id = "C")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Duncan Mac Coll",
        "ˈdunːəxə maxḳ ˈko̤ʟːə",
        null,
        null,
        "1",
        "now living in Crarea, near Inveraray",
        "Colm Ó Baoill gives the informant's name as Donnchadh MacColla",
        (select id from townland where name = "Apinn")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Cill an Inbhir",
        "Kilninver",
        "k′iɫ ˈnünɛr",
        56.337750,
        -5.521028,
        (select id from survey_point where display_id = "C")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Patrick Mac Lean",
        "phaːrig′ ,maxḳ ə ˈlɛən, (with slight hiatus between ɛ and ə)",
        null,
        null,
        "2",
        "now living in (,sɫoxḳ ə ˈvulɪn,) [Sloc a' Mhuilinn], near <i>Lochgilphead</i>",
        "Colm Ó Baoill gives the informant's name as Pàdraig MacGilleathain",
        (select id from townland where name = "Kilninver")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Sròn Magachan",
        "Stronmagachan",
        ",strun ˈmɑgəxən,",
        56.280528,
        -5.098889,
        (select id from survey_point where display_id = "C")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Alex Mac Intyre",
        "ɑɫəsḍər ,mɑxḳ ən ˈdhλːr",
        null,
        null,
        "3",
        "he was born in the same area in a place called [Caisteal Dhùn Dà Ràmh]",
        "Colm Ó Baoill gives the informant's name as Alasdair Mac an t-Saoir. You can listen to recordings of this informant at <a href=https://www.tobarandualchais.co.uk/search?l=en&search%5Bterm%5D=%22MacIntyre%2C+Sandy%2C+1884-1972+%284099%29%22&search%5Btype%5D=archival_object>tobarandualchais.co.uk</a>.",
        (select id from townland where name = "Stronmagachan")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Both Seang",
        "Deer Park Cottage, Boshang",
        ",bɔ ˈʃ̌aːŋ,",
        56.250694,
        -5.050806,
        (select id from survey_point where display_id = "C")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Mairead Caimbeul",
        "mɛrəḍ xɛmbəl",
        null,
        null,
        "4",
        "[She] lives in <i>Boshang</i>, Deer Park Cottage, beside Inveraray Castle, <i>Glenshira</i>; she was born in this area.",
        null,
        (select id from townland where ainm = "Both Seang")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Toloram",
        "Torlum",
        "tɔlɑrum",
        57.434667,
        -7.361333,
        (select id from survey_point where display_id = "D")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Kathrine Mac Millan",
        "k′ehṭ′ r′uər′i",
        null,
        null,
        "1",
        null,
        "Colm Ó Baoill gives the informant's name as Cait Ruairidh. She is likely the Kate MacMillan whose recordings are available on <a href=https://www.tobarandualchais.co.uk/search?l=en&search%5Bterm%5D=%22MacMillan%2C+Kate%2C+1892-1988+%282237%29%22&search%5Btype%5D=archival_object>tobarandualchais.co.uk</a>.",
        (select id from townland where ainm = "Toloram")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Dùn Ruadh",
        "Dùn Ruadh",
        ",do̤n ˈʀuːəɣ,",
        57.435972,
        -7.339778,
        (select id from survey_point where display_id = "D")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Donall John Mac Kinnon",
        ",dõːəl ˈiːan′ dõː[əl] ix′ḳ′ ˈk′ɛxɪn′",
        null,
        null,
        "2",
        null,
        "Colm Ó Baoill gives the informant's name as Dòmhnall Iain Dòmhnaill mhic Eachainn",
        (select id from townland where ainm = "Dùn Ruadh")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Donall Buchanan",
        "dõːəl iːan′ v′iḳ′",
        null,
        null,
        "3",
        null,
        "Colm Ó Baoill gives the informant's (local) name as Dòmhnall Iain Bhig",
        (select id from townland where ainm = "Toloram")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "An Àird Chumhaing",
        "Ardchuig",
        ",ə ɴɑřṣḍ ˈxũig′,",
        57.409950,
        -7.269970,
        (select id from survey_point where display_id = "D")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Donald Mac Donald",
        "dõːəl r′uər′i",
        null,
        null,
        "4",
        null,
        "Colm Ó Baoill gives the informant's (local) name as Dòmhnall Ruairidh",
        (select id from townland where ainm = "An Àird Chumhaing")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Lianacleit",
        "Liniclate",
        "ʟ′iːanəg̣hlaḍ′ʒ",
        57.4231958,
        7.3545927,
        (select id from survey_point where display_id = "D")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Iain Wilson",
        "iːan ən ḍhaʟ′ɛr′",
        null,
        null,
        "6",
        null,
        "Colm Ó Baoill gives the informant's name as Iain an Tàilleir",
        (select id from townland where ainm = "Lianacleit")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Angus Wilson",
        ",λ̃nλ̃ːs ɣõːə ˈruəi,",
        null,
        null,
        "6",
        null,
        "Colm Ó Baoill gives the informant's (local) name as Aonghas Dhòmhnaill Ruaidh",
        (select id from townland where ainm = "Lianacleit")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Pàirc Chàrlabhaigh",
        "Park Carloway",
        ",pɑːrþḳ′ ˈxaːʳ̣ḷəvaiʰ",
        58.282639,
        -6.761778,
        (select id from survey_point where display_id = "E")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Donall Mackenzie",
        ",ḍõːəl mɑˈxüɴ′ix′,",
        null,
        null,
        "1",
        null,
        "Colm Ó Baoill gives the informant's name as Dòmhnall MacChoinnich",
        (select id from townland where name = "Park Carloway")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Borghastan",
        "Borrowston",
        "bɔʀɔːstɔnʰ",
        58.281,
        -6.793,
        (select id from survey_point where display_id = "E")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Donall Iain, Iain, and Angus Mac Arthur",
        "[dõːəl ĩːan′, ĩːan′, λ̃nλ̃ːs] mɑˈkɑřšṭɑr′þ",
        null,
        null,
        "2",
        null,
        "Colm Ó Baoill gives the informants' names as Dòmhnall Iain, Iain and Aonghas MacArtair",
        (select id from townland where name = "Borrowston")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Diùirinis",
        "Duirinish",
        "d′ûːrïnɪʃ",
        57.31457,
        -5.67435,
        (select id from survey_point where display_id = "F")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Archibald MacLennan",
        "g′ɪʟ′ ˈesḅɪg̣′ max ḳə ˈʟ′iɴ′èn′",
        "60",
        "mason",
        "a",
        null,
        "Colm Ó Baoill gives the informant's name as Gilleasbaig MacGillFhinnein",
        (select id from townland where name = "Duirinish")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Ploc <i>nó</i>Ploc Loch Aillse",
        "Plockton",
        "pʟɔxk <i>or</i> ˈpʟɔxk ʟɔx ˈɑ̣iʃ",
        57.33801,
        -5.65231,
        (select id from survey_point where display_id = "F")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Catherine MacCrae",
        "kɑ̣χt′irh məx ˈkᵊrɑʰ",
        "76",
        "housewife",
        "b",
        null,
        "Colm Ó Baoill gives the informant's name as Caitir MacRath",
        (select id from townland where name = "Plockton")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Rory MacCrae",
        "ru.əri vix krɑ̣h",
        "65",
        "fisherman",
        "d",
        null,
        "Colm Ó Baoill gives the informant's name as Ruairidh MhicRath",
        (select id from townland where name = "Plockton")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "A' Chomraich",
        "Applecross",
        null,
        57.43304,
        -5.80958,
        (select id from survey_point where display_id = "F")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Duncan Gillanders",
        "ˈduɴuxəɣ mɑxk g′ɪʟ′ ˈɑuɴdrəʃ",
        "74",
        "formerly a Chief Inspector in Glasgow City Police",
        "c",
        null,
        "Colm Ó Baoill gives the informant's name as Donnchadh MacGillAnndrais",
        (select id from townland where name = "Applecross")
    );

insert into
    townland (
        ainm,
        name,
        transcription,
        lat,
        lon,
        survey_point_id
    ) values (
        "Clais an Easaidh <i>nó</i> Clais an Eas",
        "Clashnessie",
        "ḳʟɑ̆ʃ ˈɴ′e.s",
        58.221911,
        -5.316768,
        (select id from survey_point where display_id = "G")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "John McLeod and his sister Barbara",
        "iᴇn mə ˈkloːⁱd′; ḅarhɑ̆brɑ̣.",
        null,
        "crofter and former miner",
        "a",
        "[John] spent about five years as a miner in Canada before returning to the croft. His sister Barbara has lived all her life at Polcork, apart from a few years working in Inverness.",
        "Colm Ó Baoill gives the informants' names as Iain MacLeòid and Barbra. Their place within Clashnessie is given as PolCcork; I could not find it on a map. A comment on <a href=https://www.facebook.com/ambaile/posts/a-morris-van-belonging-to-assynt-stores-lochinver-photographed-in-inverness-arou/859645239039427/>this facebook post</a> refers to a 'Johnny and Babi Polcork' which could be the informants. Maybe Polcork was the name of their croft.",
        (select id from townland where name = "Clashnessie")
    );

insert into
    informant (
        name,
        transcription,
        age,
        occupation,
        label,
        fieldworker_notes,
        notes,
        townland_id
    ) values (
        "Rory Mackenzie",
        "ruɑri. mɑ ˈkïn′ix′",
        null,
        "postmaster",
        "b",
        null,
        "Colm Ó Baoill gives the informant's name as Ruairidh MacCoinnich",
        (select id from townland where name = "Clashnessie")
    );
