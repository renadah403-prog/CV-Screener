
% =====================================================
% EXPLAINABLE ATS - SKILL MATCHING ENGINE
% File: matching.pl
% Depends on: jobs.pl
% =====================================================

:- ensure_loaded('jobs.pl').


% =====================================================
% 1. MATCHED REQUIRED SKILLS
% Find required skills that the candidate has
% =====================================================

matched_required(Job, CandidateSkills, MatchedSkills) :-
    findall(Skill,
            (required(Job, Skill),
             member(Skill, CandidateSkills)),
            MatchedSkills).


% =====================================================
% 2. MISSING REQUIRED SKILLS
% Find required skills that the candidate does not have
% =====================================================

missing_required(Job, CandidateSkills, MissingSkills) :-
    findall(Skill,
            (required(Job, Skill),
             \+ member(Skill, CandidateSkills)),
            MissingSkills).


% =====================================================
% 3. MATCHED OPTIONAL SKILLS
% Find optional skills that the candidate has
% =====================================================

matched_optional(Job, CandidateSkills, MatchedOptional) :-
    findall(Skill,
            (optional(Job, Skill),
             member(Skill, CandidateSkills)),
            MatchedOptional).

% Get candidate skills from Python Parser
get_candidate_skills(Skills) :-
    findall(Skill, user_skill(Skill), Skills).


% Match all skills for a specific job
match_job(Job, MatchedRequired, MissingRequired, MatchedOptional) :-
    get_candidate_skills(CandidateSkills),
    matched_required(Job, CandidateSkills, MatchedRequired),
    missing_required(Job, CandidateSkills, MissingRequired),
    matched_optional(Job, CandidateSkills, MatchedOptional).