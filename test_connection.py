
from pyswip import Prolog
import os

prolog = Prolog()

# Get the current project folder
project_folder = os.path.dirname(os.path.abspath(__file__))

# Load jobs.pl
jobs_file = os.path.join(project_folder, "jobs.pl")

prolog.consult(jobs_file)

# Get all available jobs
jobs = list(prolog.query("job(Job, _)."))

print("Available Jobs:")

for job in jobs:
    print(job["Job"])

# CV skills
cv_skills = [
    "python",
    "sql",
    "machine_learning",
    "deep_learning"
]

# Send skills to Prolog temporarily
for skill in cv_skills:
    query = f"assertz(user_skill({skill}))"
    prolog.assertz(f"user_skill({skill})")

# Display received skills
print("\nSkills received by Prolog:")

for result in prolog.query("user_skill(Skill)"):
    print(result["Skill"])