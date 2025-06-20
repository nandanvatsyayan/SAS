*
J)	SUMMARIZING YOUR DATA USING PROC MEANS

	--->	STATISTICS SUCH AS THE MEAN VALUE, STANDARD DEVIATION AND MINIMUM MAX VALUES GIV YOU FEEL FOR YOUR DATA. THESE TYPES OF INFORMATION
			CAN ALSO ALEART YOU TO ERRORS IN YOUR DATA (A SCORE OF 980 IN A BASKETBALL GAME, FOR EXAMPLE, IS SUSPECT). THE MEANS PROCEDURE PROVIDES
			SIMPLE STATISTICS FOR NUMERIC VARIALE. 

	--->	THE "MEAN" PROCEDURE STARTS WITH THE KEYWORDS "PROC MEANS", FOLLOWED BY OPTIONS.

				PROC MEANS options:

	--->	SOME OPTIONS CONTROL HOW YOUR DATA ARE SUMMRIZED.

				MAXDEC= n 	(SPECIFIES THE NUMBER OF DECIMAL PLACES TO BE DISPLAYED
				MISSING		(TREATS MISSING VALUES ARE VALID SUMMARY GROUP

	--->	OTHER OPTIONS REQUEST SPECIFIC SUMMARY

				MAX			MAXIMUM VALUE
				MIN			MINIMUM VALUE
				MEAN		MEAN
				MEDIAN		MEDIAN
				MODE		MODE
				N			NUMBER OF NON-MISSING VALUE
				NMISS		NUMBER OF MISSING VALUE
				RANGE		RANGE
				STDDEV		STANDARD DEVIATION
				SUM			SUM

	--->	IF YOU USE THE "PROC MEANS" STATEMENT WITH NO OTHER STATEMENTS, THEN YOU WILL GET STATISTICS FOR ALL NUMERIC VARIABLE IN THE DATASET
			HERE ARE SOME OF OPTIONAL STATEMENTS FOR CONTROLLING WHICH VARIABLES ARE USED.

				BY Variable-list			THE "BY" STATEMENTS PERFORMS SEPARATE ANALYSS FOR EACH LEVEL OF THE VARIABLE IN THE LIST. THE DATA
											MUST FIRST BE SORTED BY THESE VARIABLES. ( YOU CAN USE PROC SORT TO DO THIS).

				CLASS Variable-list			THE "CLASS" STATEMENTS ALSO PERFORMS SEPARATE ANALYSES FOR EACH LEVEL OF VARIBALE IN THE LIST, BUT
											IT'S OUTPUT IS MORE COMPACT THAN WITH THE "BY" STATEMENT AND DATA DO NOT HAVE TO BE SORTED FIRST.

				VAR Variable-list			THE "VAR" STATEMENT SPECIFIES WHICH NUMERIC VARIABLES TO USE IN THE ANALYSIS. IF IT IS ABSENT, THEN
											SAS USES ALL NUMERIC VARIABLES.


	--->;

DATA SALE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Wholesale Nursery.csv" DSD DLM="," FIRSTOBS=2 TRUNCOVER;
INPUT CUSTOMER_ID $ @9 SALE_DATE MMDDYY9. PETUNIAS SNAPDRAONS MARIGOLDS;
MONTH = MONTH(SALE_DATE);
RUN;
PROC SORT DATA= SALE;
BY MONTH;
RUN;
PROC MEANS DATA=SALE MAXDEC=0;
BY MONTH;
VAR PETUNIAS SNAPDRAONS MARIGOLDS;
RUN;

DATA EMISSION; * DOESN'T WORK;
INFILE "D:\Practice\SAS\Little SAS Book\Data\emission_annual.xlsx" DSD DLM=" " FIRSTOBS=2 TRUNCOVER;
INPUT Year State$ ProducerType$ EnergySource$ CO2 SO2 Nox;
RUN;

DATA ANUAL; *DOESN'T WORK;
INFILE "D:\Practice\SAS\Little SAS Book\Data\emission_annual.xlsx" DLM=" " DSD  TRUNCOVER ;
INPUT Year State$ ProducerType$ EnergySource$ CO2 SO2 NOx;
RUN;

DATA TEST; *SOMEWHAT WORKS DEPENSING ON WHAT IS USED IN DLM  VALUE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\emission_annual.csv" DSD DLM=" " FIRSTOBS=2 TRUNCOVER;
INPUT Year : BEST32. State :$3. ProducerType :$20. EnergySource :$20. CO2 : BEST32. SO2 :BEST32. Nox : BEST32.;
RUN;

DATA TEST3;
INFILE "D:\Practice\SAS\Little SAS Book\Data\heart.csv" DSD DLM="," FIRSTOBS=2 TRUNCOVER;
INPUT Status$ DeathCause$	AgeCHDdiag	Sex$	AgeAtStart	Height	Weight	Diastolic	Systolic	MRW	Smoking	AgeAtDeath	Cholesterol	Chol_Status$	BP_Status$	Weight_Status$	Smoking_Status$ ;
RUN;


PROC IMPORT DATAFILE= "D:\Practice\SAS\Little SAS Book\Data\emission_annual.xlsx" OUT= TEST2 DBMS=" " REPLACE;
RUN;
PROC PRINT DATA=TEST2;
RUN;


PROC IMPORT DATAFILE= "D:\SAS Datasets\us-stormdata-2014.csv" OUT= US_STORM_DATA;
DELIMITER=" ";
GETNAMES=YES;
RUN;


PROC IMPORT DATAFILE="D:\Practice\SAS\Little SAS Book\Data\heart.csv" OUT=HEART DBMS=" " REPLACE;
RUN;


DATA FINALTEST; * WOKS PERFECTLY FINE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\emission_annual.csv" DLM=',' DSD FIRSTOBS=2;
INPUT Year : 4. State : $2. ProducerType : $30. EnergySource : $30. CO2 : COMMA12. SO2 : COMMA12. Nox : COMMA12.;
RUN;


*
K)	WRITTING SUMMARY STATISTICS TO A DATA SET

	--->	Sometimes you want to save summary statistics to a SAS data set for further 
analysis, or to merge with other data. For example, you might want to 
plot the hourly temperature in your office to show how it heats up every 
afternoon causing you to fall asleep, but the instrument you have records data 
for every minute. The MEANS procedure can condense the data by computing 
the mean temperature for each hour and then save the results in a SAS data set 
so it can be plotted. 
There are two methods in PROC MEANS for saving summary statistics in a SAS data set. You can 
use the OUTPUT destination, which is covered in section 5.3, or you can use the OUTPUT 
statement. The OUTPUT statement has the following form: 
OUTPUT OUT = data-set output-statistic-list 
Here, data-set is the name of the SAS data set which will contain the results (this can be either 
temporary or permanent), and output-statistic-list defines which statistics you want and the 
associated variable names. You can have more than one OUTPUT statement and multiple output 
statistic lists. The following is one of the possible forms for output-statistic-list: 
statistic(variable-list) = name-list 
Here, statistic can be any of the statistics available in PROC MEANS (SUM, N, MEAN, for 
example), variable-list defines which of the variables in the VAR statement you want to output, 
and name-list defines the new variable names for the statistics. The new variable names must be 
in the same order as their corresponding variables in variable-list. For example, the following 
PROC MEANS statements produce a new data set called ZOOSUM, which contains one 
observation with the variables LionWeight, the mean of the lions� weights, and BearWeight, 
the mean of the bears� weights: 
PROC MEANS DATA = zoo NOPRINT 
VAR Lions Tigers Bears 
OUTPUT OUT = zoosum MEAN(Lions Bears) = LionWeight BearWeight 
RUN 
The NOPRINT option in the PROC MEANS statement tells SAS there is no need to produce any 
printed results since we are saving the results in a SAS data set.5 
The SAS data set created in the OUTPUT statement will contain all the variables defined in the 
output-statistic-list any variables listed in a BY or CLASS statement plus two new variables, 
_TYPE_ and _FREQ_. If there is no BY or CLASS statement, then the data set will have just one 
observation. If there is a BY statement, then the data set will have one observation for each level of 
the BY group. CLASS statements produce one observation for each level of interaction of the class 
variables. The value of the _TYPE_ variable depends on the level of interaction. The observation 
where _TYPE_ has a value of zero is the grand total.6  ;



DATA sales; 
   INFILE 'c:\MyRawData\Flowers.dat'; 
   INPUT CustID $ @9 SaleDate MMDDYY10. Petunia SnapDragon Marigold; 
PROC SORT DATA = sales; 
   BY CustID; 
* Calculate means by CustomerID, output sum and mean to new data set; 
PROC MEANS NOPRINT DATA = sales; 
   BY CustID; 
   VAR Petunia SnapDragon Marigold; 
   OUTPUT OUT = totals   
      MEAN(Petunia SnapDragon Marigold) = MeanP MeanSD MeanM 
      SUM(Petunia SnapDragon Marigold) = Petunia SnapDragon Marigold; 
PROC PRINT DATA = totals; 
   TITLE 'Sum of Flower Data over Customer ID'; 
   FORMAT MeanP MeanSD MeanM 3.; 
RUN; 







*
L)	COUNTING YOUR DATA WTTH PROC FREQ

	--->	A FREQUENCY TABLE IS A SiMPLE LIST OF COUNTS ANSWERING THE QUESTION "HOW MANY?"

	--->	THE MOST OBVIOUS REASON FOR USING FREQUENCE "PROC FREQ" IS TO CREATE TABLE SHOWING THE DISTRIBUTION OF CATEGORICAL DATA VALUES, BUT
			PROC FREQUENCE CAN ALSO REVEL IRREGULARITIES IN YOUR DATA. YOU COULD GET DIZZY PROOFREADING A LARGE DATA SET, BUT DATA ENTERY ERRORS
			ARE OFTEN GLARINGLY OBVIOUS IN A FREQUENCY TABLE. THE BASIC FORM OF "PROC FREQ" IS

					PROC FREQ:
						TABLE variables- combination:

	--->	TO PRODUCE A ONE-WAY FREQUENCY TABLE, JUST LIST THE VARIABLE NAME. THIS STATEMENT PRODUCES A FREQUENCY TABLE LISTING THE OBSERVATION 
			FOR EACH VALUE OF YEAR EDUCATION;


DATA FINALTEST2; * WOKS PERFECTLY FINE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\emission_annual.csv" DLM=',' DSD FIRSTOBS=2;
INPUT Year : 4. State : $2. ProducerType : $30. EnergySource : $30. CO2 : COMMA12. SO2 : COMMA12. Nox : COMMA12.;
RUN;
PROC FREQ DATA=FINALTEST2;
TABLES CO2;
RUN;				*

	--->	TO PRODUCE A CROSS-TABULATION, LIST THE VARIABLE SERARATED BY AN ASTERIK.
					
					TABLES Sex * YearEducation

	--->	OPTIONS FOR CONTROLLING THE OUTPUT OF "PROC FREQ"

					LIST							PRINTS CROSS-TABULATION IN LIST FORMAT RATHER THAN GRID
					MISSPRINT						INCULUDES MISSING VALUE IN FREQUENCIES BUT NOT IN PERCENTAGES
					MISSING							INCLUDES MISSING VALUE IN FREQUESCIES AND PERCENTAGES
					NOCOL							SUPPRESSES PRINTING OF COLUMN PERCENTAGES IN CROSS TABULATION
					NOPERCENT						SUPPRESSES PRINTING OF PERCENTAGES
					NOROW							SUPPRESSES PRINTING OF ROW PERCENTAGES IN CORSS TABULATION
					OUT= data-set					WRITES A DATASET CONTAING FREQUECY



M)	PROCUDING TABULER REPORT WITH PROC TABLATE 
	
	--->	EVERY SUMMARY STATISTICS THE TABULATE PROCEDURE COMPUTES CAN ALSO BE PRODUCED BY OTHER PROCEDURES SUCH AS PRINT, MEANS AND FREQ BUT
			"PROC TABULATE" IS POPOLAR BECASUE IT'S REPORTS ARE PRETTY.

	--->	THE GENERAL FORM OF PROC TABULATE IS 

					PROC TABULATE:
						CLASS classification-variable-list:
						TABLE page-dimension, row-dimantion, column-dimantion

	--->	THE "CLASS" STATEMENT TELLS SAS WHICH VARIABLES CONTAINS CATEGORICAL DATA TO BE USED FOR DIVIDING OBSERVATIONS INTO GROUPS,
			WHILE THE TABEL STATEMENT TELLS SAS HOW TO ORGANISE YOUR TABLE AND WHAT NUMBERS TO COMPUTE. 

	--->	EACH TABLE STATEMENT DEFINES ONLY ONE TABLE, BUT YOU MAY HAVE MULTIPLE TABLE STATEMENTS. IF A VARIABLE IS LISTED IN A CLASS STATEMENT
			THEN, BY DEFAULT "PROC TABULATE" PRODUCES SIMPLE COUNTS OF THE NUMBER OF OBSERVATION IN EACH CATEGORY OF THAT VARIABLE. "PROC TABULTE"
			OFFERS MANY OTHER STATISTICS.

	--->	DIMENSIONS --- EACH TABLE STATEMENT CAN SPECIFY UPTO THREE DIMENSIONS. THOSE DIMENSIONS SEPARATED BY COMMAS, TELL SAS WHICH VARIABLES TO
			USE FOR THE PAGES, ROWS AND COLUMNS IN THE REPORT. IF YOU SPECIFY ONLY ONE DIMENSION THEN THAT BECOMES, BY DEFAULT, THE COLUMN DIMENSION
			IF YOU SPECIFY TWO DIMENSIONS, THEN YOU GET RAW AND COLUMNS, BUT NO PAGE DIMENSION. IF YOU SPECIFY THREE DIMENSIONS THEN YOU GET PAGES
			ROWS AND COLUMNS.

	--->	MISSING DATA ---- BY DEFAULT OBSERVATIONS AND EXCLUDED FROM "TABLE" IF THEY HAVE MISING VALUE FOR VARIABLE LISTED IN A "CLASS" STATEMENT.
							  IF YOU WANT TO KEEP THOSE THESE OBSERVATIONS THEN SIMPLLY ADD THE "MISSING" OPTIONS IN YOUR PROC STATEMET.

	--->	;


DATA BOAT;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Pleasure Boats.csv" DSD DLM="," FIRSTOBS=2 TRUNCOVER;
INPUT Boat_name : $20.	Home_port : $15.	Locomotion : $10.	Type : $5.	Excursion_price : 3.2	Boat_length : 3. ;
RUN;

PROC TABULET DATA=BOAT;
CLASS Home_port Locomotion Type;
TABLE Home_port, Locomotion, Type;
RUN;     *



N)	ADDING STATISTICS TO PROC TABULATE OUTPUT

	--->	BY DEFAULT, PROC TABULATE PODUCES SIMPLE COUNTS FOR VARIBALES LISTED IN "CLASS" STATEMENT, BUT YOU CAN REQUEST MANY OTHER STATISTICS
			IN A "TABLE" STATEMENT. YOU CAN ALSO CONCATENATE OR CROSS VARIABLES WITHIN DIMENSIONS. IN FACT, YOU CAN WRITE "TABLE" STATEMENTS SO
			COMLICATED THAT EVEN YOU WON'T KNOW WHAT THE REPORT IS GOING TO LOOK LIKE UNTILL YOU RUN IT.

	--->	WHILE THE "CLASS" STATEMENT LISTS CATEGORICAL VARIABLES, THE "VAR" STATEMENT TELLS SAS WHICH VARIBALE CONTAINS CONTINUOUS DATA.

				PROC TABULATE:
						VAR analysis-variable-list:
						CLASS classification-variable-list:
						TABLE page-dimension, row-dimantion, column-dimantion:

	--->	YOU MAY HAVE BOTH A "CLASS" STATEMENT AND A "VAR" STATEMENT, OR JUST ONE, BUT ALL VARIABLES LISTED IN A "TABLE" STATEMENT MUST ALSO
			APPER IN EITHER "CLASS" OR A "VAR" STATEMNT.

	--->	KEYWORDS --- IN THE ADDITION TO VARIABLE NAMES, EACH DIMENSION CAN CONTAIN KEYWORDS. THESE AREA A FEW OF THE VALUES "TABULATE" CAN COMPUTE.

	--->	


					ALL						ADDS A ROW, COLUMN, OR PAGE SHOWING TOTAL
					MAX						HIGHEST VALUE
					MIN						LOWEST VALUE
					MEAN					ARTHEMETIC MEAN
					MEDIAN					MEDIAN
					MODE					MODE
					N						NUMBER OF NON-MISSING VALUE 
					NMISS					NUMBER OF MISSING VALUE
					PCTN					PERCENTAGE OF OBSERVATION OF THAT GROUP
					PCTSUM					PERCENTAGE OF TOATL REPRESENTED BY THAT GROUP
					STDDEV					STANDARD DEVIATION
					SUM						SUM

	--->	CONCATNATING, CROSSING, AND GROUPING WITHIN A DIMENSION, VARIABLES AND KEYWORDS CAN BE CONCATENATED, CROSSED, OR GROUPED. TO CONCATENATE
			VARIABLES OR KEYWORDS, SIMPLY LIST THEM SEPARATED BY SPACE TO CROSS VARIABLES OR KEYWORDS, SEPARATE THEN WITH AN ASTERISK (*) AND TO
			GROUP THE, ENCLOSE THE VARIABLE OR KEUWORDS IN PARENTHESES. THE KEYWORD ALL IS GENERALLY CONCATENATED. TO REQUEST OTHER STATISTICS,
			HOWEVER, CROSS THAT KEYWORD WITH THAT VARIABLE NAME.

	
					CONCATENATING							TABLE	LOCOMOTION TYPE ALL,
					CORSSING								TABLE MEAN * PRICE
					CROSSING GROUPING AND CONCATENATING		TABLE PCTN * (LOCOMOTION TYPE)

	--->	;


DATA BOAT2;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Pleasure Boats.csv" DSD DLM="," FIRSTOBS=2 TRUNCOVER;
INPUT Boat_name : $20.	Home_port : $15.	Locomotion : $10.	Type : $5.	Excursion_price : 3.2	Boat_length : 3. ;
RUN;
PROC TABULATE DATA =BOAT2;
	CLASS Locomotion Type;
	VAR Excursion_price;
	TABLE Locomotion ALL, MEAN*Excursion_price*(Type ALL);
	TITLE 'Mean Excursion Price By Locomotion And Type';
RUN;		*



0)	ENHANCING THE APPERANCE OF PROC TABULATE OUTPUT

	--->	WHEN YOU USE PROC TABULATE, SAS WRAPS YOUR DATA IN TIDY LITTLE BOXES, BUT THERE MAYBE TIMES WHEN THEY JUST DON'T LOOK RIGHT.
			USING THREE SIMPLE OPTIONS, YOU CAN ENHANCE THE APPEARNCE OF YOUR OUTPUT.

	--->	FORMAT option ---	TO CHANGE THE FORMAT OF ALL THE DATA CELLS IN YOUR TABLE, USE THE FOAMYE - OPTION IN YOUR PROC STATEMENT. FOR
			EXAMPLE, IF YOU NEEDED THE NUMBERS IN YOUR TABLE TO HAVE COMMAS AND NO DECIMAL PLACES, YOU COULD USE THE PROC STATEMENT.

					PROC TABULAE FORMAT	= COMMA10.0:

	--->	BOX= and MISSTEXT option --- WHILE THE FORMAT= option MUST BE USED IN YOUR PROC STATEMENT, THE BOX= and MISSTEX= option GO IN TABLE
			STATEMENT. THE BOX- OPTION ALLOWS YOU TO WRITE BRIEF PHRASE IN THE NORMALLY EMPTY BOX THAT APPERS IN THE UPPER LEFT CORNER OF EVERY
			TABULATE REPORT. USING THIS EMPTY SPACE CAN GIVE REPORTS A NICELY POLISHED LOOK. THE MISSTEXT option, ON THE OTHER HAND SPECIFIES A
			VALUE CAN SEEMS DOWNRIGHT MYSTERIOUS TO SOMEONE, PERHAPS YOUR CEO, WHO IS NOT FAMILIAR WITH SAS OUPUT, YOU CAN GIVE THEM SOMETHING
			MORE MEANINGFUL WITH MISSTEXT= option.

					TABLE Region, MEAN*Sale / BOX="Mean Sale By Region" MISSTEXT="No Sale":

	--->	TELLS SAS TO PRINT THE TITLE "MEAN SALES BY REGION" IN THE UPPER LEFT CORNER OF THE TABLE, AND TO PRINT THE WORDS "NO SALES" IN
			ANY CLESS OF THE TABLE THAT HAVE NO DATA. THE BOX= AND MISSTEXT OPTIONS MUST BE SEPARATED BY THE DIMENSIONS OF THE TABLE STATEMENT BY
			A SLASH. ;



DATA BOAT3;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Pleasure Boats.csv" DSD DLM="," FIRSTOBS=2 TRUNCOVER;
INPUT Boat_name : $20.	Home_port : $15.	Locomotion : $10.	Type : $5.	Excursion_price : 3.2	Boat_length : 3. ;
RUN;
PROC TABULATE DATA =BOAT3 FORMAT = DOLLAR9.2;
	CLASS Locomotion Type;
	VAR Excursion_price;
	TABLE Locomotion ALL, MEAN*Excursion_price*(Type ALL) / BOX="Full Day Excursion" MISSTEXT="None";
	TITLE 'Mean Excursion Price By Locomotion And Type';
RUN;	*


P)	CHANGING HEADERS IN PROC TABULATE OUTPUT

	--->	THE TABULATE PROCEDURE PRODUCE REPORTS WITH A LOT OF HEADERS. SOMETIMES THERE ARE SO MANY HEADERS THAT YOUR REPORT LOOKS CLUTTERED.
			AT OTHER TIMES YOU MAY SIMPLY FEEL THAT DIFFERNT HEADER WOULD BE MORE MEANINGFULL. BEFORE YOU CAN CHANGE A HEADER THOUGH, YOU NEED
			TO UNDERSTAND WHAT TYPE OF HEADER IT IS.

	--->	TABULATE REPORTS HAS TWO BASIC TYPE OF HEADERS, HEADERS THAT ARE THE VALUES OF VARIABLES LISTED IN A CALSS STATEMENT, AND THE 
			HEADERS THAT ARE THE NAMES OF VARIABLES AND KEYWORDS. YOU USE DIFFERENT METHODS TO CHANGE DIFFERENT TYPE OF HEADERS. CLASS VARIABLE
			VALUES TO CHANGE HEADERS WHICH ARE THE VALUES OF VARIABLES LISTED IN A CLASS STATEMENT, USE THE FORMAT PROCEDURE TO CREATE A USER-
			DEFINE FOMAT. THEN ASSIGN THE FORMAT TO VARIABLE IN A FORMT STATEMENT. VARIBALE NAMES AND KEYWORDS TO CHANGE HEADERS WHICH ARE THE 
			NAME OF VARIABLE OR KEYWORDS, PUT AN EQUAL SIGN AFTER THE VARIABLE OR KEYWORD FOLLOWED BT THE NEW HEADER ENCLOSED IN QUOTATION MARKS.
			YOU CAN ELIMINATE A HEADER ENTIRELY BY SETTING IT EQUAL TO BLANK( TWO QUOTATION MARKS WITH NOTHING IN BETWEEN), AND SAS WILL REMOVE
			THE BOX FOR THAT HEADER. THIS TABLE STATEMENT.

					TABLE Region=" ", MEAN=" "*Sale="Mean Sale By Region"

	--->	TELLS SAS TO REMOVE THE HEADER FOR REGION AND MEAN, AND TO CHANGE THE HEADER FOR VARIABLE, SALES TO "MEAN BY REAGION"

	--->	IN SOME CASES SAS LEAVES THE EMPTY BOX WHEN A ROW HEADER IS SET TO BLANK. THIS HAPPENS FOR STATISTICS AND ANALYSIS VARIABLES (BUT
			NOT FOR CLASS VARIABLES). TO FORCE SAS TO REMOVE THE EMPTY BOX ADD THE "ROW-FLOAT" OPTION TO END OF YOUR TABLE STATEMENT LIKE THIS.

					TABLE Region=" ", MEAN=" "*Sale="Mean Sale By Region" / ROW=FLOAT;



DATA BOAT4;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Pleasure Boats.csv" DSD DLM="," FIRSTOBS=2 TRUNCOVER;
INPUT Boat_name : $20.	Home_port : $15.	Locomotion : $10.	Type : $5.	Excursion_price : 3.2	Boat_length : 3. ;
RUN;
PROC FORMAT ;
VALUE $TYP 'cat' = 'Catamaran'
			'sch'= 'Schooner'
			'yac'='Yacht';
PROC TABULATE DATA =BOAT4 FORMAT = DOLLAR9.2;
	CLASS Locomotion Type;
	VAR Excursion_price;
	FORMAT Type $TYP.;
	TABLE Locomotion="" ALL, MEAN=""*Excursion_price='Mean Price By Type Of Boat'*(Type ALL) / BOX="Full Day Excursion" MISSTEXT="None";
	TITLE 'Mean Excursion Price By Locomotion And Type';
RUN;	*


Q) SPECIFYING MULTIPLE FORMATS FOR THE DATA CELLS IN PROC TABULATE OUTPUT

	--->	USING THE "FORMAT=" OPTION IN A PROC TABULATE STATEMENT, YOU CAN EASILY SPECIFY A FORMAT FOR THE DATA CELLS BUT YOU CAN ALSO SPECIFY
			ONE FORMAT, AND IT MUST APPLY TO ALL THE DATA CELLS. IF YOU WANT TO USE MORE THAN ONE FORMAT IN YOUR TABLE, YOU CAN DO THAT BY PUTTING
			THE "FORMAT=" OPTION IN YOUR "TABLE" STATEMENT.

	--->	TO APPLY A FORMAT TO AN INDIVIDUAL VARIABLE, CORSS IT WITH THE VARIABLE NAME LIKE THIS.
				
					variable-name*FORMAT=formatw.d

	--->	THENYOU INSERT THIS RATHER CONVOLUTED CONSTRUCTION IN YOUR TABLE STAEMENT.

					TABLE Region, MEAN*(Sale*FORMAT=comma8.0 PROFIT*FORMATE=dollar8.2);

DATA BOAT5;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Pleasure Boats.csv" DSD DLM="," FIRSTOBS=2 TRUNCOVER;
INPUT Boat_name : $20.	Home_port : $15.	Locomotion : $10.	Type : $5.	Excursion_price : 3.2	Boat_length : 3. ;
RUN;
PROC FORMAT ;
VALUE $TYP 'cat' = 'Catamaran'
			'sch'= 'Schooner'
			'yac'='Yacht';
PROC TABULATE DATA =BOAT5 FORMAT = DOLLAR9.2;
	CLASS Locomotion Type;
	VAR Excursion_price Boat_length;
	FORMAT Type $TYP.;
	TABLE Locomotion="" ALL, MEAN=""*(Excursion_price='Mean Price By Type Of Boat'* FORMAT=DOLLAR7.2 Boat_length*FORMAT=2.0)*(Type ALL) / BOX="Full Day Excursion" MISSTEXT="None";
	TITLE 'Price And Type By Lenghth Of The Boat';
RUN;	



