/*1. What state do you have, and how many observations are in your dataset? */

tab stateicp

count
 
/*2. What proportion (i.e., percentage) of the total population lives on a farm? 
[Note: use “w = perwt” to appropriately weight the observations. This will make a slight difference in the 
answer relative to not using the weights.] */

tab farm [w=perwt]
 
/*3. What is the largest city in the state, and what proportion of the state’s population lives in it? 
[Again, use “perwt”.] */

/*You didn't need to use the sort option below, that simply makes the largest city rise to the top*/
tab city [w=perwt], sort
 
/*4. What proportion of household heads live in owner-occupied housing? 
[Note: Condition the command on “… if relate == 1 & ownershp~=0”. This includes only household heads 
(relate==1) and excludes those with missing homeownership data from the calculation. The result is basically 
the homeownership rate.] */

tab ownershp if relate == 1 & ownershp ~= 0 [w=perwt]
 
/*5. What is the most common occupation for men who are at least age 20 and not more than age 60? What 
proportion of the men (age 20-60) hold that job? 
[Note: use the “occ1950” variable to answer this question. Again, weight the observations.] */

/*Again, you don't need the sort*/
tab OCC1950 if age >= 20 & age <= 60 & sex == 1 [w=perwt], sort

/* What share of women age 20-60 are in the “labor force”? How does this differ between women who are
“married with spouse present” and all other women (age 20-60)? */

tab labforce if age >= 20 & age <= 60 & sex == 2 [w = perwt]
tab labforce if age >= 20 & age <= 60 & sex == 2 & marst == 1 [w = perwt]
tab labforce if age >= 20 & age <= 60 & sex == 2 & marst > 1 [w = perwt]
 
/*7. Create a new dummy variable called “LIT” that equals 1 only if the person “reads and writes” and equals 0 if 
the person cannot both read and write. Create a dummy variable called “URBAN” that equals 1 if the person 
resides in an urban area and 0 if not. Be sure to use “tab variablename, nolabel” or check the IPUMS website to 
figure out the right code numbers for creating the variables. */

//tab lit
//tab lit, nolabel

/*Notice that this includes a NA response, coded with a 0 -- we'll want to exclude that for our analysis.
(Note: I didn't actually take points off for this but it's important to remember for your paper.)

lit == 4 is a statement that evalutes to 1 (true) if lit is equal to 4 and 0 otherwise.  This then pluges that result into a new variable LIT.*/

gen LIT = lit == 4

/*now we replace our new variable with a ., the missing value, if lit is NA*/

replace LIT = . if lit == 0

/*Now for URBAN*/

//tab urban
//tab urban, nolabel

/*No NA here.  Yay.  So this is much easier to make*/

gen URBAN = urban == 2
 
/*7A. What is the literacy rate (LIT ==1) for people who are at least age 20 and not more than age 60 and who 
reside in urban areas? What is it for those who reside in rural areas (age 20-60)? 
[Note: Again, use “perwt” in your calculations.] */

/*There are two ways to do this.  One with sum(marize) and one with tab(ulate).  I will show both below.  sum is the cleaner way to do it here*/

/*tab*/
/*urban*/
tab LIT if age >= 20 & age <= 60 & URBAN == 1 [w=perwt]
/*rural*/
tab LIT if age >= 20 & age <= 60 & URBAN == 0 [w=perwt]

/*sum*/
/*urban*/
sum LIT if age >= 20 & age <= 60 & URBAN == 1 [w=perwt]
/*rural*/
sum LIT if age >= 20 & age <= 60 & URBAN == 0 [w=perwt]
 
/*7B. Regress LIT on URBAN for people age 20 to 60 (use w=perwt). What is the coefficient on URBAN? 
[Note: It should equal the difference in 6A.] */
 
regress LIT URBAN if age >= 20 & age <= 60 [w=perwt]
 
/*7C. Regress LIT on URBAN and age (one regression in which LIT is the dependent variable and URBAN 
and age are the independent variables). Interpret the coefficient on age in terms of the predicted change in 
LIT for a 10 year increase in age. Briefly, what do the two coefficients (on URBAN and age) suggest about 
patterns of schooling in the late 19th century? */

regress LIT URBAN age [w=perwt]


regress LIT URBAN age if age >= 20 & age <= 60 [w=perwt]


/*This means that a 10 year increase in age corresponds with a change in probability of a person being literate by the amount on age times 10.*/


/*The interpretation will depend on your results.  If the coefficient on age is negative, that means that the probability of being literate decreased as a person got older.  The interpretation here is that school attendance or quality improved over time, leading to lower illiteracy rates.  (In practice, likely both.)  For some, the age coefficient was positive.  This is an anomalous result.  An acceptable answer is that school quality or attendance was decreasing over the 19th century.  Historically, however, this is probably not the case.  Likely we are observing the impact of immigration.  There was a large influx of immigrants in the 19th century who were poorly educated.  Hence, the younger generations are a mix of native born with strong education and immigrants with little to none, whereas the older generations are all native born.
Assuming your URBAN statistic was positive, this suggests that education in rural areas was relatively poor, with high skill people either being schooled in or migrating to the cities.  A few states had a negative coefficient on URBAN -- Massachusetts, for one.  In this case, you have a situation where the schooling in the countryside is quite good and the literacy percentage in urban areas is brought down by the inclusion of low-education immigrants.*/
