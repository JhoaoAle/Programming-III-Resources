% =========================
% LOAN ELIGIBILITY MODEL
% =========================

enum Decision = { NO, YES };

int: age;
int: income;
int: debt;
int: credit_score;
int: employment_years;
int: dependents;
int: has_delinquency; % 0 or 1
int: loan_amount;

% Decision variable (more readable now)
var Decision: approved;

% Derived values
var int: installment = loan_amount div 12;


% Helper conditions
var bool: age_ok = (age >= 21 /\ age <= 65);
var bool: credit_ok = (credit_score >= 650);
var bool: employment_ok = (employment_years >= 1);
var bool: delinquency_ok = (has_delinquency = 0);

var bool: income_ok =
    income * 25 >= (debt + installment) * 10; % approx 2.5x rule

var bool: debt_ratio_ok =
    debt * 10 <= income * 4; % debt ratio ≤ 0.4

% -------------------------
% Main decision rule
% -------------------------

constraint
    approved = if age_ok /\
                  credit_ok /\
                  employment_ok /\
                  delinquency_ok /\
                  income_ok /\
                  debt_ratio_ok
               then YES
               else NO
               endif;

% -------------------------
% Output
% -------------------------

output [
  "APPROVED = ", show(approved), "\n",
  "age_ok = ", show(age_ok), "\n",
  "credit_ok = ", show(credit_ok), "\n",
  "employment_ok = ", show(employment_ok), "\n",
  "delinquency_ok = ", show(delinquency_ok), "\n",
  "income_ok = ", show(income_ok), "\n",
  "debt_ratio_ok = ", show(debt_ratio_ok), "\n"
];