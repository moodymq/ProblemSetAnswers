//#delimit ;
set more off
//log using "C:\Users\Mike\Documents\ECON 266 PS1\PS1_Answers", replace

forvalues i = 1/39 {
  use "C:\Users\Mike\Documents\class names2.dta", clear
  keep if _n == `i'
  scalar lastN = last
  local lastNa = lastN
  scalar icp = stateicp
  local sicp = icp
  
  use "E:\IPUMS\ipums1900.dta", clear
  keep if stateicp == `sicp'
  log using "C:\Users\Mike\Documents\ECON 3150 PS1 02\\`lastNa'_PS1_Answers", replace
  
  do "E:\Acer C Drive 2015\Users\Mike\Documents\ECON 3150 PS1 master.do"

  log close
  
  translate "C:\Users\Mike\Documents\ECON 3150 PS1 02\\`lastNa'_PS1_Answers.smcl" "C:\Users\Mike\Documents\ECON 3150 PS1 02\Text Files\\`lastNa'_PS1_Answers.log"
}

//log close
