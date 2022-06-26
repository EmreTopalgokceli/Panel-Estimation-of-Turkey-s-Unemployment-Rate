* ###################
* LOOKING AT DATA
* ###################	

* Turkey's 26 statistical regions were analyzed using panel data methods for 2013-2018. 
* Data was obtained from Turkish Statistical Institute.
* (https://biruni.tuik.gov.tr/bolgeselistatistik/anaSayfa.do?dil=tr)

* Dependent variables are as follows:
	* unemp: Unemployment Rate
	* empl: Labor Force Participation Rate
* Independent variables are as follows:
	* gdppc: National Income per Capita, US Dollars
	* illiterate: Illiterate, %
	* high_school: High School Graduates, %
	* uni: University Graduates, %
	* en_inten: Energy Intensity (per capita energy consumption/per capita national income) as a proxy of informal sector
	* new_busi: Number of New Startups
	* pop_inten: Population density
	* hh_size_ave: Household Size, Average
	* gender_ratio: Ratio of Female Population to Male Population
	* inf: Inflation rate
	* hours_worked: Weekly Working Hours, Average
	* planted_farms: Planted Agricultural Lands, Hectares
	* fallow_farms: Fallow Agricultural Lands, Hectares
	* herbal_prod_pc: Herbal Production Value per Capita, Turkish Lira
	* alive_animal_pc: Live Animal Value per Capita, Turkish Lira
	* animal_prod_pc: Animal Production Value per Capita, Turkish Lira

	
* ###################
* DATA PREPROCESSING
* ###################	
		
* Let's introduce numeric variables.
destring unemp empl gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc, replace float percent dpcomma

* Let's take the logarithm of all variables except the year variable.

tostring year, replace

ds, has(type numeric)
foreach var of varlist `r(varlist)'{
replace `var' =ln(`var')
}

destring year, replace


* encoding districtcode variable.
encode districtcode, gen(district_code)


* Let's look at the distribution statistics.
sum


* ###################
* PANEL DATA ANALYSIS
* ###################


* Let's introduce the panel (indexes) columns.
xtset district_code year

* Pooled OLS
xi: reg unemp gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc alive_animal_pc animal_prod_pc
xi: reg empl gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc alive_animal_pc animal_prod_pc

* First Difference
xi: reg D(unemp gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc alive_animal_pc animal_prod_pc), noconstant
xi: reg D(empl gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc alive_animal_pc animal_prod_pc), noconstant

* Fixed Effects - unemployment
xtreg unemp gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc alive_animal_pc animal_prod_pc, fe
estimate store fe

* Random Effects - unemployment
xtreg unemp gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc alive_animal_pc animal_prod_pc, re
estimate store re

*Hausman 
hausman fe re, sigmamore

* Fixed Effects - employment
xtreg empl gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc alive_animal_pc animal_prod_pc, fe
estimate store fa

* Random Effects - unemployment
xtreg empl gdppc illiterate high_school uni en_inten new_busi pop_inten hh_size_ave gender_ratio inf hours_worked planted_farms fallow_farms herbal_prod_pc alive_animal_pc animal_prod_pc, ra
estimate store ra

*Hausman 
hausman fa ra, sigmamore
