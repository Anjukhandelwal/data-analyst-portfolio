# 🚒 Project 3: Data Cleaning & Validation – London Fire Brigade Incident Records

**Business question:**  
Can London Fire Brigade (LFB) incident data be trusted for reporting response times by borough, and what needed fixing first?

**Short answer:**  
Yes — with caveats. The dataset is clean on most checks, but **location**, **first‑pump timing**, and **one text column** require careful handling.

**Tools:** Python (Pandas) · SQL · Jupyter Notebook

---

## 🎯 Why This Project Matters
Bad data produces confident but wrong reports.  
I applied a **software‑testing‑style quality assurance workflow**:

- Define checks  
- Measure issues  
- Fix what is safe  
- Flag what is uncertain  
- Re‑run the same checks to prove the result  

This project demonstrates **data reliability assessment**, **cleaning strategy**, and **transparent decision‑logging** — essential skills for analytics roles.

---

## 📁 Dataset Overview
- **Source:** London Datastore – [LFB Incident Records](https://data.london.gov.uk/dataset/london-fire-brigade-incident-records-em8xy)  
- **File used:** *LFB Incident data from 2024 onwards* (Excel → CSV, no changes)  
- **Size:** 358,338 incidents  
- **Columns:** 39  
- **Period:** 1 Jan 2024 → 31 Jul 2026  
- **Licence:** UK Open Government Licence v2.0  
- Raw file stored in `data/raw/` (not uploaded due to size)

---

## 🏷️ Attribution
Contains public sector information licensed under the Open Government Licence v2.0.  
Data published by the London Fire Brigade via the London Datastore.

---

## 🔧 Approach
1. **Profiled** raw data (types, missing values, duplicates, date range).  
2. **Validated** using checks grouped by data‑quality dimension.  
3. **Cleaned** with logged decisions — fix safely, flag uncertainty, drop only exact duplicates.  
4. **Investigated** major gaps before calling them errors.  
5. **Re‑ran** all checks on clean data and compared results.  
6. *(Optional)* Cross‑checked key numbers in SQL (`sql/validation_checks.sql`).  

---

## 🧪 Validation Checks
| Dimension | Example checks |
|---|---|
| **Completeness** | Missing coordinates, borough, first pump arrival time |
| **Uniqueness** | Duplicate rows, repeated incident numbers |
| **Validity** | Hour outside 0–23, impossible coordinates, negative or >60‑min attendance times, future dates |
| **Consistency** | Borough spelling, incident group validity, date vs `CalYear` |
| **Accuracy** | Second pump arriving before the first |

---

## 📊 Results: Before vs After Cleaning
| Check | Raw | After cleaning |
|---|---|---|
| Rows | 358,338 | 358,338 |
| Duplicate rows / repeated incident numbers | 0 | 0 |
| Borough spelling variants | 0 | 0 |
| Dates unreadable / future / disagreeing with `CalYear` | 0 | 0 |
| Stray spaces in `PropertyType` | 300,525 (84%) | 0 |
| Impossible coordinates | 542 | 0 (set to missing) |
| Missing latitude/longitude | 221,313 (61.8%) | 221,855 (61.9%) |
| Missing first pump arrival time | 18,654 (5.2%) | 18,654 (kept) |
| Second pump arriving before first | 2,296 (0.64%) | 2,296 (flagged) |

Full results:  
`reports/validation_summary.csv`  
`reports/cleaning_log.csv`

---

## 🔍 Key Findings
- **Most checks passed.**  
  No duplicates, consistent borough names, valid hours, no negative or >60‑minute attendance times, and all dates matched `CalYear`.

- **`PropertyType` had trailing spaces in 84% of rows.**  
  This would split categories in charts.  
  The issue appears in the publisher’s Metadata sample → trimmed safely.

- **61.8% of incidents lack latitude/longitude — but location is NOT lost.**  
  All rows still have rounded Easting/Northing, postcode district, and borough.  
  Metadata confirms exact coordinates are **redacted for dwellings** → privacy, not data loss.  
  *(Add confirmation once you check what share of blank rows are dwellings.)*

- **Missing first‑pump arrival time is concentrated in Special Service incidents.**  
  ~11.4% missing vs ~1% for Fire/False Alarm.  
  Likely because pumps may not attend non‑fire callouts.  
  Kept as missing.

- **2,296 incidents show second pump arriving before first.**  
  Cause unknown → flagged, not changed.  
  Response‑time analysis should treat these carefully.

---

## 💡 Lesson Learned
My first date‑parsing step misread `YYYY-MM-DD` as day‑first, silently swapping day/month and blanking 61% of dates.  
Re‑running validation checks caught it.  
Fix: inspect real format and parse explicitly.

**Always re‑validate after cleaning.**

---

## ⚠️ Limitations
- Metadata explains missing coordinates but not missing first‑pump times → likely, not proven.  
- Pump‑order anomalies (2,296 rows) not investigated further.  
- Only 2024‑onwards file used; earlier years not checked.

---

## 📂 Repository Structure
