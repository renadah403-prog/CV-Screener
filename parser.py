
import pdfplumber
from docx import Document
from pyswip import Prolog
from pathlib import Path
import os
import re


# ==============================
# 1. Extract Text from CV
# ==============================

def extract_text(file_path):

    if not os.path.exists(file_path):
        raise FileNotFoundError("CV file not found!")

    file_extension = os.path.splitext(file_path)[1].lower()
    text = ""

    if file_extension == ".pdf":

        with pdfplumber.open(file_path) as pdf:
            for page in pdf.pages:
                page_text = page.extract_text()

                if page_text:
                    text += page_text + "\n"

        extracted_text = text.strip()

        if not extracted_text:
            raise ValueError(
                "SCANNED_PDF: No extractable text was found. "
                "The PDF may be scanned or image-based."
            )

        return extracted_text

    elif file_extension == ".docx":

        document = Document(file_path)

        for paragraph in document.paragraphs:
            text += paragraph.text + "\n"

        extracted_text = text.strip()

        if not extracted_text:
            raise ValueError(
                "EMPTY_DOCX: No text was found in this DOCX file."
            )

        return extracted_text

    else:
        raise ValueError("Unsupported file format!")


# ==============================
# 2. Skill Dictionary
# ==============================

SKILL_ALIASES = {
    "python": ["python"],
    "c_plus_plus": ["c++", "c plus plus", "c_plus_plus"],
    "sql": ["sql"],
    "linux": ["linux"],
    "machine_learning": ["machine learning", "machine_learning"],
    "deep_learning": ["deep learning", "deep_learning"],
    "data_analysis": ["data analysis", "data_analysis"],
    "opencv": ["opencv", "open cv"],
    "excel": ["excel", "microsoft excel"],
    "power_bi": ["power bi", "powerbi", "power_bi"],
    "networking": ["networking", "computer networking"],
    "ccna": ["ccna"],
    "cybersecurity": ["cybersecurity", "cyber security"],
    "penetration_testing": ["penetration testing", "pentesting"],
    "soc_operations": ["soc operations"],
    "wireshark": ["wireshark"],
    "git": ["git"],
    "docker": ["docker"],
    "django": ["django"],
    "flask": ["flask"],
    "html_css": ["html/css", "html css", "html and css"],
    "javascript": ["javascript", "java script"],
    "react": ["react"],
    "flutter": ["flutter"],
    "oop": ["oop", "object oriented programming"],
    "ui_ux": ["ui/ux", "ui ux"],
    "figma": ["figma"],
    "aws": ["aws", "amazon web services"]
}


# ==============================
# 3. Extract and Normalize Skills
# ==============================

def extract_skills(text):

    found_skills = []

    for skill, aliases in SKILL_ALIASES.items():

        for alias in aliases:

            pattern = (
                r'(?<![a-zA-Z0-9_])'
                + re.escape(alias)
                + r'(?![a-zA-Z0-9_])'
            )

            if re.search(pattern, text, re.IGNORECASE):
                found_skills.append(skill)
                break

    return found_skills


# ==============================
# 4. Send Skills to Prolog
# ==============================

def send_skills_to_prolog(skills):

    prolog = Prolog()

    jobs_file = Path(__file__).with_name("jobs.pl")
    prolog.consult(str(jobs_file))

    known_skills = {
        str(result["Skill"])
        for result in prolog.query("known_skill(Skill)")
    }

    valid_skills = [
        skill for skill in skills
        if skill in known_skills
    ]

    list(prolog.query("retractall(user_skill(_))"))

    for skill in valid_skills:
        prolog.assertz(f"user_skill({skill})")

    received_skills = [
        str(result["Skill"])
        for result in prolog.query("user_skill(Skill)")
    ]

    return received_skills


# ==============================
# 5. Get Matching Results
# ==============================

def get_matching_results(candidate_skills):

    prolog = Prolog()

    matching_file = Path(__file__).with_name("matching.pl")
    prolog.consult(str(matching_file))

    list(prolog.query("retractall(user_skill(_))"))

    for skill in candidate_skills:
        prolog.assertz(f"user_skill({skill})")

    jobs = list(prolog.query("job(Job, Title)"))

    results = []

    for item in jobs:

        job_code = str(item["Job"])

        job_title = (
            item["Title"].decode("utf-8")
            if isinstance(item["Title"], bytes)
            else str(item["Title"])
        )

        query = (
            f"match_job({job_code}, "
            f"Matched, Missing, Optional)"
        )

        matching = list(prolog.query(query))

        if matching:

            result = matching[0]

            matched = [str(s) for s in result["Matched"]]
            missing = [str(s) for s in result["Missing"]]
            optional = [str(s) for s in result["Optional"]]

            total_required = len(matched) + len(missing)

            percentage = (
                (len(matched) / total_required) * 100
                if total_required > 0
                else 0
            )

            results.append({
                "job": job_title,
                "matched": matched,
                "missing": missing,
                "optional": optional,
                "percentage": round(percentage, 2)
            })

    # Sort jobs from highest to lowest match percentage
    results.sort(
        key=lambda x: x["percentage"],
        reverse=True
    )

    return results


# ==============================
# 6. Main Program
# ==============================

if __name__ == "__main__":

    try:

        cv_path = input(
            "Enter CV file path: "
        ).strip().strip('"')

        cv_text = extract_text(cv_path)

        print("\nExtracted CV Text:")
        print(cv_text)

        skills = extract_skills(cv_text)

        print("\nDetected Skills:")
        print(skills)

        received_skills = send_skills_to_prolog(skills)

        print("\nSkills received by Prolog:")
        print(received_skills)

        matching_results = get_matching_results(
            received_skills
        )

        print("\n========== JOB MATCHING RESULTS ==========")

        for result in matching_results:

            print("\nJob:", result["job"])

            print(
                "Match Percentage:",
                str(result["percentage"]) + "%"
            )

            print(
                "Matched Required:",
                result["matched"]
            )

            print(
                "Missing Required:",
                result["missing"]
            )

            print(
                "Matched Optional:",
                result["optional"]
            )

        print("\n========== MATCHING COMPLETED ==========")

    except (ValueError, FileNotFoundError) as e:

        print("\nError:", e)

    except Exception as e:

        print("\nUnexpected Error:", e)
