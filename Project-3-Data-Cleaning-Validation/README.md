# Project 3: Data Cleaning & Validation – London Fire Brigade Incident Records

**Business question:** Can London Fire Brigade (LFB) incident data be trusted for reporting response times by borough, and what needed fixing first?

**Short answer:** Yes, with caveats. The data is clean on most checks, but location, first-pump timing and one text column need careful handling (details below).

**Tools:** Python (Pandas), SQL, Jupyter Notebook

## Why this project
Bad data produces confident but wrong reports. I used the quality-assurance approach from my software testing career: define checks, measure the problems, fix what is safe, flag what is uncertain, then re-run the same checks to prove the result.

## Dataset
- **Source:** London Datastore, [LFB incident records](https://data.london.gov.uk/dataset/london-fire-brigade-incident-records-em8xy), file "LFB Incident data from 2024 onwards" (Excel, converted to CSV without changes)
- **Size and period:** 358,338 incidents, 39 columns, 1 January 2024 to 31 July 2026
- **Licence:** UK Open Government Licence v2.0 (as shown for the dataset)
- The raw data is kept untouched in `data/raw/` (not uploaded to GitHub because of file size)

## Attribution
Contains public sector information licensed under the Open Government Licence v2.0. Data published by the London Fire Brigade via the London Datastore.

## Approach
1. **Profiled** the raw data: types, missing values, unique values, duplicates, date range.
2. **Validated** with checks grouped by data-quality dimension (table below).
3. **Cleaned** with a logged decision for every step. Rule: fix what can be fixed safely, flag what might be real, and drop only exact duplicates.
4. **Investigated** the biggest gaps before calling them errors.
5. **Re-ran** the same checks on the clean data and compared before vs after.

## Validation checks
| Dimension | Example checks |
|---|---|
| Completeness | Missing coordinates, borough, first pump arrival time |
| Uniqueness | Duplicated rows, repeated incident numbers |
| Validity | Hour outside 0–23, impossible coordinates, negative or very long attendance times, future dates |
| Consistency | Borough name spelling, unexpected incident groups, date year vs the `CalYear` column |
| Accuracy | Second pump arriving before the first |

## Results: before vs after
| Check | Raw | After cleaning |
|---|---|---|
| Rows | 358,338 | 358,338 |
| Duplicate rows / repeated incident numbers | 0 | 0 |
| Borough spelling variants | 0 | 0 |
| Dates unreadable, in the future, or disagreeing with `CalYear` | 0 | 0 |
| Cells with stray spaces (all in `PropertyType`) | 300,525 (about 84% of rows) | 0 |
| Impossible coordinates (outside the UK) | 542 | 0 (set to missing) |
| Missing latitude and longitude | 221,313 (61.8%) | 221,855 (61.9%) |
| Missing first pump arrival time | 18,654 (5.2%) | 18,654 (kept) |
| Second pump arriving before the first | 2,296 (0.64%) | 2,296 (flagged, not changed) |

Full results: `reports/validation_summary.csv` and `reports/cleaning_log.csv`.

## Key findings
- **Most checks passed.** No duplicates, consistent borough names and incident groups, valid hours, no negative or over-60-minute attendance times, and every date agreed with the `CalYear` column.
- **`PropertyType` had stray spaces in about 84% of rows.** Left alone, the same property type would be counted as separate categories in any grouping or chart. The trailing space also appears in the sample record in the publisher's own Metadata, so it comes from the source. Trimmed.
- **61.8% of incidents have no latitude/longitude, but location is not lost.** Every one of those rows still has rounded Easting/Northing, postcode district and borough. The dataset's own Metadata says latitude, longitude, exact Easting/Northing, full postcode and UPRN are **redacted for dwellings**, so this is a deliberate privacy choice rather than lost data. Borough-level analysis is unaffected. A further 542 rows had impossible coordinates, which I set to missing.
- **Missing first-pump time is concentrated in Special Service incidents** (11.4% missing, against about 1% for Fire and False Alarm). This is consistent with non-fire callouts where a pump may not attend at all (the Metadata does not explain these gaps, so this is not confirmed). I kept these as missing instead of filling them in.
- **2,296 incidents (0.64%) show the second pump arriving before the first.** The cause is unknown, so I flagged them rather than changed them. Response-time analysis should treat these with care.

## Lesson learned
My first date-cleaning step misread the `YYYY-MM-DD` dates (it assumed day-first), which silently swapped days and months and blanked 61% of dates. Re-running the validation checks after cleaning caught it. The fix was to inspect the real format and parse it explicitly. Always re-validate after cleaning.

## Limitations
- The Metadata explains the missing coordinates (redacted for dwellings) but says nothing about missing first-pump times, so that explanation is likely, not proven.
- I did not check that every blank latitude belongs to a dwelling record; the Metadata says dwellings are redacted, but other blanks may exist.
- I did not investigate the 2,296 pump-order cases further, so I can't say whether they are recording errors or definition quirks.
- Only the 2024-onwards file was used; earlier years were not checked.

## Repository contents
```
data/raw/                  original file (not uploaded: too large)
data/clean/                cleaned output (not uploaded: too large)
notebooks/cleaning.ipynb   Python profiling, checks, cleaning, before/after
sql/validation_checks.sql  the same key checks in SQL, including a data quality scorecard
reports/                   validation summary and cleaning log
```

## How to run
1. Download "LFB Incident data from 2024 onwards" from the London Datastore page above and save it in `data/raw/`.
2. If it is an Excel file, convert it to `data/raw/lfb_incident_records.csv` (for example with `pandas.read_excel(...).to_csv(...)`).
3. Open `notebooks/cleaning.ipynb` and run all cells (needs Python 3, pandas, numpy, openpyxl).
4. For SQL, import the raw CSV into a table called `lfb_incidents` and run `sql/validation_checks.sql`.
