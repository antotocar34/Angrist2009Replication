capture log close
local directory "/home/carneca/Documents/College/4/Michaelmas/qua/A/Angrist2009Replication/replication"
/* log using "`directory'\Table1.log", replace */

****************************************************************
* PROGRAM: table1
* PROGRAMMER: Antoine Carnec
* PURPOSE: Makes Table 1 of Angrist, Lang and Oreopoulos (2008) 
*****************************************************************


cd "`directory'"
set more off
set linesize 200

use "/home/carneca/Documents/College/4/Michaelmas/qua/A/Angrist2009Replication/replication/STAR_public_use"

// Create variable for treatment and other variable groups

local treatment_status sfp sfpany sfsp ssp control

gen treat_stat = .
replace treat_stat = 0 if control == 1
replace treat_stat = 1 if sfp == 1
replace treat_stat = 2 if sfpany == 1
replace treat_stat = 3 if sfsp == 1
replace treat_stat = 4 if ssp ==  1

local background_vars female gpa0 age english

local admin_vars numcourses_nov1 noshow compsurv    

local survey_vars hcom chooseUTM work1 mom1 mom2 dad1 dad2 lastmin graddeg  finish4  

local combined_vars background_vars admin_vars survey_vars

// First we will make the a vector with means as elements
// will correspond to the first column of table 1.
// J(1, 8, .) creates a 8x1 vector of null values.
matrix mean_values_control=J(8, 1, .)

// declare a variable i to be 0.
local i=0
foreach var in `background_vars'{
    /* gen var`i' = `var' */
    sum `var' if treat_stat == 0
        //r(mean) is the saved mean from runinng the summary command
        // mat X[a,b] = exp -> replaces [a,b] in X for exp
        // [`i' + 1] because of indexing.
        mat mean_values_control[`i'+1,1]=r(mean)

    // increment i by 1
    local ++i
}

mat li mean_values_control
