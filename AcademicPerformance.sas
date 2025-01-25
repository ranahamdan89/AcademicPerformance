Code:
proc import out=project datafile="/home/u63336679/sasuser.v94/ProjectDataSet.xlsx"
	dbms=xlsx replace; sheet = "ProjectDataSet";
run;

data project1;
    set project;
    
    if Marital_status in ("1", "2") then Marital_status = Marital_status;
    else if Marital_status in ("3", "4", "5", "6") then Marital_status = "3";
    
    if Nationality ="1" then Nationality = Nationality; else Nationality = 0;
    
    if Application_mode in ("1", "3", "7", "8", "9") then Application_mode = "1";
    else if Application_mode in ("4", "6", "12", "13", "14", "16", "18") then Application_mode = "2";
    else if Application_mode in ("2", "5", "10", "11", "15", "17") then Application_mode = "3";
    
    if Course in ("1", "4", "7", "8") then Course = "1";
    else if Course in ("2", "5", "15") then Course = "2";
    else if Course in ("6", "12", "13") then Course = "3";
    else if Course in ("9", "3", "10", "11", "14", "17") then Course = "4";
    else if Course in ("16") then Course = "5";
    
    if Previous_qualification in ("1", "7", "8", "9", "10", "11", "12", "13") then Previous_qualification = "1";
    else Previous_qualification = "2";
    
    if Mother_qualification in ("27", "28", "18", "21", "20", "12", "10", "8", "7", "14", "1", "11", "15", "17", "11") then Mother_qualification = "1";
    else if Mother_qualification in ("13", "22", "23", "16", "29", "31", "32", "2", "30", "33", "34", "3", "4", "5", "6") then Mother_qualification = "2";
    else Mother_qualification = "3";
    
        if Father_qualification in ("27", "28", "18", "21", "20", "12", "10", "8", "7", "14", "1", "11", "15", "17", "11") then Father_qualification = "1";
    else if Father_qualification in ("13", "22", "23", "16", "29", "31", "32", "2", "30", "33", "34", "3", "4", "5", "6") then Father_qualification = "2";
    else Father_qualification = "3";
    
    if Mother_occupation in ("2", "3", "5", "9", "11", "14", "15", "16", "17", "18", "19", "20", "21", "22", "27", "28", "29") then Mother_occupation = "1";
    else if Mother_occupation in ("4", "7", "8", "6", "23", "24", "25", "26", "36", "37", "38", "39", "40") then Mother_occupation = "2";
    else Mother_occupation = "3";
    
    if Father_occupation in ("2", "3", "5", "9", "11", "14", "15", "16", "17", "18", "19", "20", "21", "22", "27", "28", "29") then Father_occupation = "1";
    else if Father_occupation in ("4", "7", "8", "6", "23", "24", "25", "26", "36", "37", "38", "39", "40") then Father_occupation = "2";
    else Father_occupation = "3";

    if Target = "Dropout" then Education_Status = 1;
    else Education_Status = 0;
 
run;

proc freq data=project1;
	table Marital_status Nationality Application_mode Course Previous_qualification mother_qualification Father_qualification Mother_occupation Father_occupation Education_Status;
Run;

/*frequency calculated*/
proc freq data=student1;
table Marital_status application_mode application_order course daytime_evening_attendance previous_qualification
          Nationality Mother_qualification father_qualification mother_occupation father_occupation Displaced
          Educational_special_needs debtor Tuition_uptodate gender scholarship_holder international Education_Status;
run;

/*Rana*/
proc import out=Student datafile="/home/u62193061/sasuser.v94/STUDENT1.xlsx"
dbms=xlsx replace; 
run;
/*Correlation */

proc corr data=Student;
	var Age_at_enrollment Curri_units_1st_sem_credited Curri_units_1st_sem_enrolled Curri_units_1st_sem_evaluations Curri_units_1st_sem_approved Curri_units_1st_sem_grade Curri_units_1st_sem_woeval Curri_units_2nd_sem_credited Curri_units_2nd_sem_enrolled Curri_units_2nd_sem_evaluations Curri_units_2nd_sem_approved Curri_units_2nd_sem_grade Curri_units_2nd_sem_woeval Unemployment_rate Inflation_rate GDP;
run;



/*  summary statistics of the macroeconomics data*/

proc means data=Student n mean median min max std maxdec=3;
	var GDP Inflation_rate Unemployment_rate;
Run;

/* academic data at the end of the first semester*/
proc means data=Student n mean median min max std maxdec=3;
	var Curri_units_1st_sem_credited Curri_units_1st_sem_enrolled Curri_units_1st_sem_evaluations Curri_units_1st_sem_approved Curri_units_1st_sem_grade Curri_units_1st_sem_woeval ;
run;

/* academic data at the end of the second semester*/
proc means data=Student n mean median min max std maxdec=3;
	var Curri_units_2nd_sem_credited Curri_units_2nd_sem_enrolled Curri_units_2nd_sem_evaluations Curri_units_2nd_sem_approved Curri_units_2nd_sem_grade Curri_units_2nd_sem_woeval ;
run;

proc sgplot data=Student;
	vbox Age_at_enrollment/category=Education_Status;
run;

proc means data=Student n mean median min max std cv maxdec=3;
	var Age_at_enrollment;
	class Education_Status;
run;

proc sgplot data=Student;
	vbox Unemployment_rate/category=Education_Status;
run;

proc sgplot data=Student;
	vbox Inflation_rate/category=Education_Status;
	title "Inflation Rate vs Education Status";
run;

proc sgplot data=Student;
	vbox GDP/category=Education_Status;
run;


proc means data=Student n mean median min max std maxdec=3;
	var GDP Inflation_rate Unemployment_rate Age_at_enrollment;
run;

proc sgplot data=Student;
	vbar Gender /stat=pct categoryorder=respasc;;
run;

proc sgplot data=Student;
	vbar Education_Status;
run;
proc freq data=Student;
	table Education_Status;
run;

/* PCA*/
proc import out=student datafile="/home/u63739299/sasuser.v94/STUDENT1.csv"
dbms=csv replace; 
run;

data student2;
	set student;
	drop Marital_status application_mode application_order course daytime_evening_attendance previous_qualification
          Nationality Mother_qualification father_qualification mother_occupation father_occupation Displaced
          Educational_special_needs debtor Tuition_uptodate gender scholarship_holder international Education_Status;
run;

proc princomp data=student2;
run;


/* CART Model with GINI and partitioning 80% and 20% */
proc hpsplit data=student1 nodes=detail;
    partition fraction(validate=0.2 seed=12345);
    class Marital_status application_mode application_order course daytime_evening_attendance previous_qualification
          Nationality Mother_qualification father_qualification mother_occupation father_occupation Displaced
          Educational_special_needs debtor Tuition_uptodate gender scholarship_holder international Education_Status;

    model Education_Status(event="1") = Marital_status application_mode application_order course
                 daytime_evening_attendance previous_qualification Nationality Mother_qualification father_qualification 
                 mother_occupation father_occupation Displaced Educational_special_needs debtor Tuition_uptodate 
                 gender scholarship_holder international age_at_enrollment Curri_units_1st_sem_credited
                 Curri_units_1st_sem_enrolled Curri_units_1st_sem_evaluations Curri_units_1st_sem_approved
                 Curri_units_1st_sem_grade Curri_units_1st_sem_woeval Curri_units_2nd_sem_credited 
                 Curri_units_2nd_sem_enrolled Curri_units_2nd_sem_evaluations Curri_units_2nd_sem_approved 
                 Curri_units_2nd_sem_grade Curri_units_2nd_sem_woeval Unemployment_rate Inflation_rate GDP;
    grow gini;
    prune cc;
run;

/*CART model with variable importance 80% and 20%*/
proc hpsplit data=student1 nodes=detail;
    partition fraction(validate=0.2 seed=12345);
    class application_order course daytime_evening_attendance father_occupation Tuition_uptodate Education_Status;

    model Education_Status(event="1") =  application_order course daytime_evening_attendance father_occupation 
                 Tuition_uptodate age_at_enrollment Curri_units_1st_sem_credited
                 	Curri_units_2nd_sem_approved Curri_units_1st_sem_enrolled 
                 	Curri_units_2nd_sem_grade Curri_units_2nd_sem_enrolled Curri_units_1st_sem_approved
                 	Curri_units_2nd_sem_credited Curri_units_2nd_sem_evaluations;
    grow gini;
    prune cc;
run;

/* Neural Network model and partition 80% and 20% */
proc surveyselect data=student1 method=srs samprate=.2 outall out=student1part3 seed=12345;
run;

proc hpneural data=student1part3;
	partition rolevar=selected(train=1);
	target Education_Status/level=nom;
	input Marital_status application_mode application_order course daytime_evening_attendance previous_qualification Nationality Mother_qualification father_qualification mother_occupation father_occupation Displaced Educational_special_needs debtor Tuition_uptodate gender scholarship_holder international/level=nom;
	input age_at_enrollment Curri_units_1st_sem_credited Curri_units_1st_sem_enrolled Curri_units_1st_sem_evaluations Curri_units_1st_sem_approved Curri_units_1st_sem_grade Curri_units_1st_sem_woeval Curri_units_2nd_sem_credited 
          Curri_units_2nd_sem_enrolled Curri_units_2nd_sem_evaluations Curri_units_2nd_sem_approved Curri_units_2nd_sem_grade Curri_units_2nd_sem_woeval Unemployment_rate Inflation_rate GDP/level=int;
	hidden 34;
	train maxiter=1000 numtries=5;
	id Education_Status selected;
	score out=student1out3;
run;

/*sensitivity and specificity*/
proc freq data=student1out3;
	table Education_Status  * i_Education_Status/nocum nocol nopercent;
	where selected =1 ;
run;

proc freq data=student1out3;
	table Education_Status * i_Education_Status/nocum nocol nopercent;
	where selected =0 ;
run;

/*Logistic Regression*/
/* Import file into SAS*/
proc import out=student datafile="/home/u63739299/sasuser.v94/STUDENT1.csv"
dbms=csv replace; 
run;

/* Creating Dummy Variables */
data student3;
    set student;

    /* Marital_status */
    if Marital_status = 1 then single= 1 ;else single=0;
    if Marital_status = 2 then married= 1 ;else married=0;

    /* Application_mode */
    if Application_mode = 1 then A_M1=1; else A_M1=0;
    if Application_mode = 2 then A_M2=1; else A_M2=0;
    

    /* Course */
    if Course = 1 then C_S1=1;else C_S1=0;
    if Course = 2 then C_S2=1;else C_S2=0;
    if Course = 3 then C_S3=1;else C_S3=0;
    if Course = 4 then C_S4=1;else C_S4=0;  

    /* Previous_qualification */
    if Previous_qualification = 1 then P_Q=1; else P_Q=0;
       
    /* Mother_qualification */
    if Mother_qualification = 1 then M_Q1=1; else M_Q1=0;
    if Mother_qualification = 2 then M_Q2=1; else M_Q2=0;

    /* Father_qualification */
    if Father_qualification = 1 then F_Q1=1; else F_Q1=0;
    if Father_qualification = 2 then F_Q2=1; else F_Q2=0;  

    /* Mother_occupation */
    if Mother_occupation = 1 then M_O1=1; else M_O1=0;
    if Mother_occupation = 2 then M_O2=1; else M_O2=0;  

    /* Father_occupation */
    if Father_occupation = 1 then F_O1=1; else F_O1=0;
    if Father_occupation = 2 then F_O2=1; else F_O2=0;
run;

/* Data Partition */
proc surveyselect data=student3 method=srs samprate=.8 outall out=student3part seed=12345;
run;
data student3train student3valid;
	set student3part;
	if selected=1 then output student3train; else output student3valid;
run;
/* Logistic Model using all Variables */
proc logistic data=student3train outmodel=student3model;
	model Education_Status(event="1")=  single married A_M1 A_M2 C_S1 C_S2 C_S3 C_S4 application_order
                 daytime_evening_attendance P_Q Nationality M_Q1 M_Q2 F_Q1 F_Q2
                 M_O1 M_O2 F_O1 F_O2 Displaced Educational_special_needs debtor Tuition_uptodate 
                 gender scholarship_holder international age_at_enrollment Curri_units_1st_sem_credited
                 Curri_units_1st_sem_enrolled Curri_units_1st_sem_evaluations Curri_units_1st_sem_approved
                 Curri_units_1st_sem_grade Curri_units_1st_sem_woeval Curri_units_2nd_sem_credited 
                 Curri_units_2nd_sem_enrolled Curri_units_2nd_sem_evaluations Curri_units_2nd_sem_approved 
                 Curri_units_2nd_sem_grade Curri_units_2nd_sem_woeval Unemployment_rate Inflation_rate GDP;
run;
proc logistic inmodel=student3model;
	score data=student3train fitstat out=student3trainout;
	score data=student3valid fitstat out=student3validout;
run;
proc freq data=student3trainout;
	table f_Education_Status*i_Education_Status/nocol nopercent nocum;
run;
proc freq data=student3validout;
	table f_Education_Status*i_Education_Status/nocol nopercent nocum;
run;
/* Logistic Model using stepwise selection */
proc logistic data=student3train outmodel=student3model;
	model Education_Status(event="1")=  single married A_M1 A_M2 C_S1 C_S2 C_S3 C_S4 application_order
                 daytime_evening_attendance P_Q Nationality M_Q1 M_Q2 F_Q1 F_Q2
                 M_O1 M_O2 F_O1 F_O2 Displaced Educational_special_needs debtor Tuition_uptodate 
                 gender scholarship_holder international age_at_enrollment Curri_units_1st_sem_credited
                 Curri_units_1st_sem_enrolled Curri_units_1st_sem_evaluations Curri_units_1st_sem_approved
                 Curri_units_1st_sem_grade Curri_units_1st_sem_woeval Curri_units_2nd_sem_credited 
                 Curri_units_2nd_sem_enrolled Curri_units_2nd_sem_evaluations Curri_units_2nd_sem_approved 
                 Curri_units_2nd_sem_grade Curri_units_2nd_sem_woeval Unemployment_rate Inflation_rate GDP/selection=stepwise;
run;
proc logistic inmodel=student3model;
	score data=student3train fitstat out=student3trainout;
	score data=student3valid fitstat out=student3validout;
run;
proc freq data=student3trainout;
	table f_Education_Status*i_Education_Status/nocol nopercent nocum;
run;
proc freq data=student3validout;
	table f_Education_Status*i_Education_Status/nocol nopercent nocum;
run;
/* Logistic Model using forward selection */
proc logistic data=student3train outmodel=student3model;
	model Education_Status(event="1")=  single married A_M1 A_M2 C_S1 C_S2 C_S3 C_S4 application_order
                 daytime_evening_attendance P_Q Nationality M_Q1 M_Q2 F_Q1 F_Q2
                 M_O1 M_O2 F_O1 F_O2 Displaced Educational_special_needs debtor Tuition_uptodate 
                 gender scholarship_holder international age_at_enrollment Curri_units_1st_sem_credited
                 Curri_units_1st_sem_enrolled Curri_units_1st_sem_evaluations Curri_units_1st_sem_approved
                 Curri_units_1st_sem_grade Curri_units_1st_sem_woeval Curri_units_2nd_sem_credited 
                 Curri_units_2nd_sem_enrolled Curri_units_2nd_sem_evaluations Curri_units_2nd_sem_approved 
                 Curri_units_2nd_sem_grade Curri_units_2nd_sem_woeval Unemployment_rate Inflation_rate GDP/selection=forward;
run;
proc logistic inmodel=student3model;
	score data=student3train fitstat out=student3trainout;
	score data=student3valid fitstat out=student3validout;
run;
proc freq data=student3trainout;
	table f_Education_Status*i_Education_Status/nocol nopercent nocum;
run;


proc freq data=student3validout;
	table f_Education_Status*i_Education_Status/nocol nopercent nocum;
run;
/* Logistic Model using backward selection */
proc logistic data=student3train outmodel=student3model;
	model Education_Status(event="1")=  single married A_M1 A_M2 C_S1 C_S2 C_S3 C_S4 application_order
                 daytime_evening_attendance P_Q Nationality M_Q1 M_Q2 F_Q1 F_Q2
                 M_O1 M_O2 F_O1 F_O2 Displaced Educational_special_needs debtor Tuition_uptodate 
                 gender scholarship_holder international age_at_enrollment Curri_units_1st_sem_credited
                 Curri_units_1st_sem_enrolled Curri_units_1st_sem_evaluations Curri_units_1st_sem_approved
                 Curri_units_1st_sem_grade Curri_units_1st_sem_woeval Curri_units_2nd_sem_credited 
                 Curri_units_2nd_sem_enrolled Curri_units_2nd_sem_evaluations Curri_units_2nd_sem_approved 
                 Curri_units_2nd_sem_grade Curri_units_2nd_sem_woeval Unemployment_rate Inflation_rate GDP/selection=backward;
run;
proc logistic inmodel=student3model;
	score data=student3train fitstat out=student3trainout;
	score data=student3valid fitstat out=student3validout;
run;
proc freq data=student3trainout;
	table f_Education_Status*i_Education_Status/nocol nopercent nocum;
run;
proc freq data=student3validout;
	table f_Education_Status*i_Education_Status/nocol nopercent nocum;
run;

