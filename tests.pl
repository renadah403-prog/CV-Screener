
% ==========================================
% Explainable ATS - Database Tests
% ==========================================

:- begin_tests(ats_jobs).

% Load the jobs database
:- consult('jobs.pl').


% Test 1: Check that the database contains 15 jobs
test(job_count) :-
    findall(Job, job(Job, _), Jobs),
    length(Jobs, 15).


% Test 2: Check that the database contains 27 known skills
test(known_skill_count) :-
    findall(Skill, known_skill(Skill), Skills),
    length(Skills, 28).


% Test 3: Every job must have required skills
test(all_jobs_have_required_skills) :-
    forall(
        job(Job, _),
        required(Job, _)
    ).


% Test 4: Every required skill must exist in known_skill
test(required_skills_are_known) :-
    forall(
        required(_, Skill),
        known_skill(Skill)
    ).


% Test 5: Every optional skill must exist in known_skill
test(optional_skills_are_known) :-
    forall(
        optional(_, Skill),
        known_skill(Skill)
    ).


% Test 6: Every job must have a positive required skill count
test(required_skill_counts_are_positive) :-
    forall(
        job(Job, _),
        (
            job_required_count(Job, Count),
            Count > 0
        )
    ).


% Test 7: Check AI Engineer required skills
test(ai_engineer_required_skills) :-
    once(required(ai_engineer, python)),
    once(required(ai_engineer, machine_learning)),
    once(required(ai_engineer, deep_learning)).


% Test 8: Check Data Analyst optional skills
test(data_analyst_optional_skills) :-
    once(optional(data_analyst, python)),
    once(optional(data_analyst, power_bi)).


:- end_tests(ats_jobs).
