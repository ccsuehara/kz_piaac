** Kazakhstan work**

global orig_dta "/Users/csolisu/Documents/STEP/WDR/piaac_data/original data"

global kz_results 
cd "${orig_dta}"

use prgkazp1, clear

svyset [pw=spfwt0], jkrweight(spfwt1-spfwt80) vce(jackknife) mse


do "/Users/csolisu/Documents/proyectos_aparte/gender and piaac/do files/piaac_var_creation_new_countries.do"

gen ages1625 = (age < 26 & age!=.n)
cd "/Users/csolisu/Documents/proyectos_aparte/Kazakhstan/results"


tabout pared nativelang natbilang impar imgen paidwork12 gender_r age_group ///
learnatwork_wle_ca readytolearn_wle_ca icthome_wle_ca ictwork_wle_ca influence_wle_ca numhome_wle_ca ///
 numwork_wle_ca planning_wle_ca readhome_wle_ca readwork_wle_ca ///
 taskdisc_wle_ca writhome_wle_ca writwork_wle_ca ///
 new_category edu1 using "kzh_row.xls", svy replace mi c(row se ci) clab(Row_% SE 95%_CI) percent
tabout pared nativelang natbilang impar imgen paidwork12 gender_r age_group ///
learnatwork_wle_ca readytolearn_wle_ca icthome_wle_ca ictwork_wle_ca influence_wle_ca numhome_wle_ca ///
 numwork_wle_ca planning_wle_ca readhome_wle_ca readwork_wle_ca ///
 taskdisc_wle_ca writhome_wle_ca writwork_wle_ca ///
 new_category edu1 using "kzh_col.xls", svy replace mi c(column se ci) clab(Col_% SE 95%_CI) percent



/*
foreach var in pared nativelang natbilang impar imgen paidwork12 gender_r age_group new_category {
	piaactab `var', over(edu1) countryid(cntryid) round(5) save(`var'kzh)

}

foreach var in extraversion_av conscientiousness_avg openness_av stability_av agreeableness_av grit_av decision_av hostile_av {
tabout `var' edu1 using "`country'.xls", svy append sum c(mean `var' se ci) clab(Mean_% SE 95%_CI) percent
}
*/


foreach var in readytolearn icthome ictwork influence numhome numwork planning ///
 readhome readwork taskdisc writhome writwork {
	tabout `var' edu1 using "kzh_mean.xls", svy append sum c(mean `var' se ci) clab(Mean_% SE 95%_CI) percent

}



 foreach pv in lit num psl {
	piaactab pv`pv' , over(gender_r) countryid(cntryid) round(5) save(`pv'_gender)
	piaactab pv`pv' if ages1625 == 1, over(gender_r) countryid(cntryid) round(5) save(`pv'_gender_young)
	piaactab pv`pv' if ages1625 == 0, over(gender_r) countryid(cntryid) round(5) save(`pv'_gender_old)
	
	piaactab pv`pv' , over(edu1) countryid(cntryid) round(5) save(`pv'_edu1)
	piaactab pv`pv' if ages1625 == 1, over(edu1) countryid(cntryid) round(5) save(`pv'_edu1_young)
	piaactab pv`pv' if ages1625 == 0, over(edu1) countryid(cntryid) round(5) save(`pv'_edu1_old)
	 
}

foreach pv in lit num psl {
	piaacdes , countryid(cntryid) pv(pv`pv') stats(mean) centile(50) round(5) over(gender) save(mean_`pv'_gender) 
	piaacdes if  ages1625 == 1, countryid(cntryid) pv(pv`pv') stats(mean) centile(50) round(5) over(gender) save(mean_`pv'_gender_young) 
	piaacdes if ages1625 == 0, countryid(cntryid) pv(pv`pv') stats(mean) centile(50) round(5) over(gender) save(mean_`pv'_gender_old) 

	piaacdes , countryid(cntryid) pv(pv`pv') stats(mean) centile(50) round(5) over(edu1) save(mean_`pv'_edu1) 
	piaacdes if  ages1625 == 1, countryid(cntryid) pv(pv`pv') stats(mean) centile(50) round(5) over(edu1) save(mean_`pv'_edu1_young) 
	piaacdes if ages1625 == 0, countryid(cntryid) pv(pv`pv') stats(mean) centile(50) round(5) over(edu1) save(mean_`pv'_edu1_old) 

}


foreach skill in lit num psl{
		pv, pv(pv`skill'*) jrr jk(1) weight(spfwt0) rw(spfwt1 - spfwt80):  ///
		reg @pv gender age years_educ [aw = @w]
		outreg2 using regs.xls, dec(5) append

}
