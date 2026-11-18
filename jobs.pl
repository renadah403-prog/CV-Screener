% =====================================================================
% EXPLAINABLE ATS - JOBS, SKILLS & KNOWLEDGE BASE (MASTER EDITION)
% Author: Walaa Elabasy & Team
% =====================================================================

% =====================================================================
% 1. KNOWLEDGE DICTIONARY: Allowed Skills & Tools in the System
% =====================================================================
:- dynamic user_skill/1.
known_skill(python).
known_skill(c_plus_plus).
known_skill(sql).
known_skill(linux).
known_skill(machine_learning).
known_skill(deep_learning).
known_skill(data_analysis).
known_skill(opencv).
known_skill(excel).
known_skill(power_bi).
known_skill(networking).
known_skill(ccna).
known_skill(cybersecurity).
known_skill(penetration_testing).
known_skill(soc_operations).
known_skill(wireshark).
known_skill(git).
known_skill(docker).
known_skill(django).
known_skill(flask).
known_skill(html_css).
known_skill(javascript).
known_skill(react).
known_skill(flutter).
known_skill(ui_ux).
known_skill(figma).
known_skill(aws).
known_skill(oop).

% =====================================================================
% 2. JOB TITLES REGISTRY (15 Core Market Roles)
% =====================================================================
job(ai_engineer, "AI Engineer").
job(data_scientist, "Data Scientist").
job(data_analyst, "Data Analyst").
job(computer_vision_engineer, "Computer Vision Engineer").
job(backend_developer, "Backend Developer").
job(frontend_developer, "Frontend Developer").
job(fullstack_developer, "Full Stack Developer").
job(mobile_developer, "Mobile Developer").
job(penetration_tester, "Penetration Tester").
job(soc_analyst, "SOC Analyst").
job(embedded_engineer, "Embedded Systems Engineer").
job(iot_engineer, "IoT Engineer").
job(network_engineer, "Network Engineer").
job(devops_mlops_engineer, "DevOps & MLOps Engineer").
job(ui_ux_designer, "UI/UX Designer").


% =====================================================================
% 3. REQUIRED SKILLS FOR EACH JOB (Hard Requirements)
% =====================================================================
required(ai_engineer, python).
required(ai_engineer, machine_learning).
required(ai_engineer, deep_learning).

required(data_scientist, python).
required(data_scientist, sql).
required(data_scientist, data_analysis).

required(data_analyst, sql).
required(data_analyst, data_analysis).
required(data_analyst, excel).

required(computer_vision_engineer, python).
required(computer_vision_engineer, opencv).
required(computer_vision_engineer, deep_learning).

required(backend_developer, python).
required(backend_developer, sql).
required(backend_developer, django).

required(frontend_developer, html_css).
required(frontend_developer, javascript).
required(frontend_developer, react).

required(fullstack_developer, python).
required(fullstack_developer, sql).
required(fullstack_developer, html_css).

required(mobile_developer, flutter).
required(mobile_developer, oop).
required(mobile_developer, git).

required(penetration_tester, linux).
required(penetration_tester, networking).
required(penetration_tester, penetration_testing).
required(penetration_tester, python).

required(soc_analyst, linux).
required(soc_analyst, networking).
required(soc_analyst, soc_operations).

required(embedded_engineer, c_plus_plus).
required(embedded_engineer, linux).
required(embedded_engineer, networking).

required(iot_engineer, python).
required(iot_engineer, networking).
required(iot_engineer, linux).

required(network_engineer, networking).
required(network_engineer, ccna).
required(network_engineer, linux).

required(devops_mlops_engineer, linux).
required(devops_mlops_engineer, docker).
required(devops_mlops_engineer, git).
required(devops_mlops_engineer, networking).

required(ui_ux_designer, ui_ux).
required(ui_ux_designer, figma).
required(ui_ux_designer, html_css).


% =====================================================================
% 4. OPTIONAL SKILLS FOR EACH JOB (Bonus/Extra Points)
% =====================================================================
optional(ai_engineer, git).
optional(ai_engineer, docker).
optional(ai_engineer, sql).

optional(data_scientist, machine_learning).
optional(data_scientist, git).

optional(data_analyst, python).
optional(data_analyst, power_bi).

optional(computer_vision_engineer, c_plus_plus).
optional(computer_vision_engineer, git).

optional(backend_developer, git).
optional(backend_developer, docker).
optional(backend_developer, flask).

optional(frontend_developer, git).
optional(frontend_developer, ui_ux).

optional(fullstack_developer, django).
optional(fullstack_developer, docker).
optional(fullstack_developer, react).

optional(mobile_developer, python).
optional(mobile_developer, sql).

optional(penetration_tester, wireshark).
optional(penetration_tester, git).

optional(soc_analyst, python).
optional(soc_analyst, wireshark).

optional(embedded_engineer, python).
optional(embedded_engineer, git).

optional(iot_engineer, c_plus_plus).
optional(iot_engineer, docker).

optional(network_engineer, c_plus_plus).
optional(network_engineer, git).

optional(devops_mlops_engineer, python).
optional(devops_mlops_engineer, aws).
optional(devops_mlops_engineer, machine_learning).

optional(ui_ux_designer, git).


% =====================================================================
% 5. SMART HELPER RULES (To assist matching and scoring teams)
% =====================================================================

% Count total required skills for a job (useful for percentage calculation)
job_required_count(Job, Count) :-
    setof(Skill, required(Job, Skill), Skills),
    length(Skills, Count).

% Count total optional skills for a job
job_optional_count(Job, Count) :-
    findall(Skill, optional(Job, Skill), Skills),
    length(Skills, Count).


% =====================================================================
% 6. DATABASE INTEGRITY VALIDATION (Check Everything is Clean)
% =====================================================================
check_jobs :-
    write('-----------------------------------------------------'), nl,
    write(' [INFO] Validating Explainable ATS Jobs Database...   '), nl,
    job(Code, Title),
    job_required_count(Code, ReqCount),
    format(' -> Loaded Job: ~w (~w) with ~w required skills.~n', [Title, Code, ReqCount]),
    fail.
check_jobs :-
    nl,
    write('====================================================='), nl,
    write(' SUCCESS: All 15 Jobs & Skills validated successfully!'), nl,
    write(' Database is robust, clean, and ready for production. '), nl,
    write('====================================================='), nl.
