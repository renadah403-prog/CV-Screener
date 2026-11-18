# CV Screener – Explainable ATS

## Project Description
A CV Screening System that extracts skills from candidate resumes and matches them with job requirements using Python and Prolog.

## Technologies Used
- Python
- SWI-Prolog
- PySwip
- PDFPlumber
- Python-docx

## Main Features
- Extract text from PDF and DOCX CV files.
- Detect and normalize candidate skills.
- Match candidate skills with job requirements.
- Identify matched, missing, and optional skills.
- Calculate job match percentages.
- Rank jobs based on matching percentage.

## Project Files
- `parser.py`: CV text extraction and skill detection.
- `jobs.pl`: Job database and known skills.
- `matching.pl`: Prolog matching rules.
- `tests.pl`: Tests for the Prolog database and rules.

## Run the Project
Run the Python program:

```bash
python parser.py
```

Run the Prolog tests:

```bash
swipl -s tests.pl -g run_tests -t halt
```

## Test Results
All 8 Prolog tests passed successfully.
