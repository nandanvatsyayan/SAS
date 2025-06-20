*

A)	MACRO CONCEPT

	--->	THE MACRO PROCESSOR - WHEN YOU SUBMIT A STANDARD SAS RPOGRAM, SAS COMPLIES AND THEN IMMEDIATELY EXECUTES IT. BUT WHEN YOU WRITE A MACRO
			THERE IS AN ADDITIONAL STEP. BEFORE SAS CAN COMPILE AND EXECUTES YOUR PROGRAM, SAS MUST PASS YOUR MACRO STATEMENT TO THE MACRO PROCESSOR
			WHICH "RESOLVES" YOUR MACROS, GENERATING STANDARD SAS CODE. BECAUSE YOUR ARE WRITTING A PROGRAM THAT WRITES A PROGRAM, THIS IS 
			SOMETIMES CALLED META-PROGRAMMING.

	--->	MACRO AND MACRO VARIABLES - SAS MACRO CODE CONSISTS OF TWO BASIC PARTS: "MACRO" AND "MACRO VARIABLES". THE NAMES OF MACRO VARIABLES ARE
			PREFIXED WITH AN AMPERSAND(&) WHILE THE NAME OF MACROS ARE PREFOXED WITH A PERCENT SIGN(%). A MACRO VARIABLE IS LIKE A STANDARD DATA
			VARIABLE EXCEPT THAT, HAVING ONLY A SINGLE VALUE, IT DOESN'T BELONG TO A DATA SET, AND IT'S VALUE IS ALWAYS CHARACTER. THIS VALUE COULD 
			BE A VARIBALE NAME, NUMERAL, OR ANY TEXT THAT YOU WANT SUBSTITUTED INTO YOUR PROGRAM. A MACRO, ON THE OTHER HAND, IS A LARGER PIECE OF
			PROGRAM THAT MAY CONTAIN COMPLX LOGIC INCLUDING COMPLETE DATA AND PROC STEPS AND MACRO STATEMENTS SUCH AS %DO, AND %IF-%THEN/%ELSE.

	--->	WHEN SAS USERS TALK ABOUT "MACROS" THEY SOMETIMES MEAN MACROS, AND SOMETIMES MEAN MACRO PROCESSING IN GENERAL. MACRO VARIABLE ARE 
			USUALLY CALLED MACRO VARIABLES.

	--->	LOCAL VERSUS GLOBAL -- MACRO VARIABLES CAN HAVE TWO KINDS OF SCOPE EITHER LOCAL OR GLOBAL. GENERALLY, A MACRO VARIBALE IS LOCAL OF IT
			DEFINED INSIDE A MACRO. A MACRO VARIBALE IS GENERALLY GLOAL IF IT IS DEFINED IN "OPEN CODE" WHICH IS EVERYTHING OUTSIDE A MACRO. YOU 
			CAN ALSO USE A GLOBAL MACRO VARIABLE ANYWHERE IN YOUR PROGRAM, BUT YOU CAN USE A LOCAL MACRO VARIBALE ONLY INSIDE IT'S OWN MACRO. 
			IF YOU KEEP THIS IN MIND AS YOU WRITE YOUR PROGRAMS, YOU WILL AVOID TWO COMMON ERRORS: TRYING TO USE A LOCAL VARIBALE OUTSIDE MACRO
			AND ACCIDENTALLY CREATING LOCAL GLOBAL MACRO VARIABLES WITH SAME NAME. 

	--->	TURNING ON THE MCARO PROCESSOR -- BEFORE YOU CAN USE MACROS YOU MUST HAVE THE MACRO SYSTEM OPTION TURNED ON. THIS OPTION IS USALLY
			TURNED ON BY DEFAULT, BUT MAY BE TURNED OF ESPECIALLY ON MAINFRAMES, BEACSUE SAS RUNS SLIGHTLY FASTER WHEN IT DOESN'T HAVE TO 
			BOTHER WITH CHECKING FOR MACROS. IF YOU ARE NOT SURE WHETHER THE "MACRO" OPTION IS ON, YOU CAN FIND OUT BY SUBMITTING THESE
			STATEMENTS:
							PROC OPTIONS OPTION = MACRO:
							RUN:

	--->	AVOIDING MACRO ERRORS -- THERE'S NO QUESTION ABOUT IT. MACROS CAN MAKE HEAD HURT. YOU CAN AVOID MACRO MIGRAINE BY DEVELOPING YOUR
			PROGRAM IN A PIECEWISE FASHION. FIRST, WRITE YOUR PROGRAM IN STANDARD SAS CODE. THEN, WHEN IT'S BUG-FREE, CONVERT IT TO MACRO LOGIC
			ADDING ONE FEATURE AT A TIME. THIS MODULAR APPROCH TO PROGRAMMING IS ALWUAS A GOOD IDEA, BUT IT'S CRITICAL WITH MACROS.


B)	SUBMITTING TEXT WITH MACRO VARIABLES
	
	--->	CREATING A MACRO VARIABLE WITH %LET THE SIMPLEST WAY TO ASSIGN A VALUE TO MACRO VARIBALE IS WITH THE %LET STATEMENT. THE GENEAL FORM OF
			THIS STATEMENT IS 
						%LET macro-variale-name = value:

	--->	WHERE MACR0-VARIABLE-NAME MUST FOLLOW THE RULES FOR SAS VARIABLE NAMES. VALUE IN THE TEXT TO THE SUBSTITUTED FOR THE MACRO VARIABLE NAME,
			AND CAN BE LONGER THAN YOU ARE EVER LIKELY TO NEED-OVER 65,000 CHARACTER LONG. THIS FOLLOWING STATEMENTS EACH CREATE A MACRO VARIBALE
	
						%LET iteration = 10:
						%LET country = New Zealand:

	--->	USING A MACRO VARIABLE -- TO USE A MACEO VARIANLE YOU SIMPLY ADD THE AMPRESAND PREFIX(&) AND STICK THE MACRO VARIABLE NAME WHEREVER YOU
			WANT IT'S VALUE TO BE SUBSTITUTED. KEEP IN MIND THAT THE MACRO PROCESSOR DOESN'T LOOK FOR MACROS INSIDE SINGLE QUOTATION MARKS. TO GET 
			AROUND THIS, SIMPLY USE DOUBLE QUOTATION MARKS. 

						DO i = 1 to &iterations: 
						TITLE "Addresses in &country": 
			After being resolved by the macro processor, these statements would become  
						DO i = 1 to 10: 
						TITLE "Addresses in New Zealand";

%LET Flowertype = Ginger;

DATA FLOWERS;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Tropical Flowers.csv" DSD DLM="," FIRSTOBS=2;
INPUT ID : $4. SaleDate : MMDDYY10. Variety : $10. SaleQuantity SaleAmount;
IF Variety = "&Flowertype";
RUN;

PROC PRINT DATA = FLOWERS;
FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
TITLE "Sale Of &Flowertype";
RUN; *



C)	CONCATENATING MACRO VARIABLE WITH OTHER TEXT

	--->	COMBINING TEXT WITH MACRO VARIABLES WHEN SAS ECNOUNTERS THE AMPERSAND(&) EMBEDDED IN TEXT, IT WILL LOOK FOR MACRO VARIBALE NAMES
			STARTING WITH THE FIRST CHARACTER AFTER THE AMPERSAND UNTIL IT ENCOUNTERS EITHER A SPACE, OR A SEMICOLON, ANOTHER AMPERSAND OR 
			A PERIOD. SO IF YOU WAN TO ADD TEXT BEFORE YOUR MACRO VAIRABLE, SIMPLY CONCATENATE THE TEXT WITH AN AMPERSAND AND THE MACOR VARIABLE
			NAME. IF YOU WANT TO ADD TEXT AFTER THE MACRO VARIABLE, THEN YOU NEED TO INSERT A PERIOD BETWEEN THE END OF THE MACRO VARIABLE NAME AND
			THE TEXT. THE PERIOD SIGNALS THE END OF THE MACRO VARIABLES TOGETHER DOESN'T REQUIRE A PERIOD BETWEEN THE NAMES BECASUE THE AMPERSAND
			FOR THE SECOND MACRO VARIABLE SIGNALS THE END OF THE FIRTS MACRO VAIRBALE. 

	--->	EXAMPLES WITH TWO MACRO VARIBALES, &REGION AND &MYNAME,;
						%LET Region = West;
						%LET MyName = Sam; *

	--->		SAS statement before resolution 									SAS statement after resolution ;
						Office = "NorthAmerica&Region"; 									Office = "NorthAmericaWest"; 
						Office = "&Region.Coast"; 											Office = "WestCoast"; 
						DATA &MyName..Sales; 												DATA Sam.Sales; 
						DATA &MyName&Region.ern_Sales; 										DATA SamWestern_Sales; *


	--->	AUTOMATIC MACRO VARIABLES -- EVERYTIME YOU INVOKE SAS, THE MACRO PROCESSOR AUTOMATICALLY CREATES CERTAIN MACRO VARIABLS. SOME EXAMPLES
			OF AUTOMATIC MACRO VARIABLES ARE

					VARIABLE NAME				EXAMPLE 			DESCRIPTION
					&SYSDATE					28MAY12				THE CHARACTER VALUE OF THE DATE THAT JOB OR SESSIONS BEGAN
					&SYSDAY						Wednesday			THE DAY OF THE WEEK THAT JOB OR SESSION BEGAN
					&SYSNOBS					312					NUMBER OF OBSERVATION IN LAST DATASET CREATED
						;

%LET SumVar = Quantity;
DATA FLOWERSALE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Tropical Flowers.csv" DSD DLM="," FIRSTOBS=2;
INPUT ID : $4. SaleDate : MMDDYY10. Variety : $10. SaleQuantity SaleAmount;
RUN;
ODS RTF FILE = "D:\Practice\SAS\Little SAS Book\FlowerSale_&Sysdate.rtf";
PROC MEANS DATA= FLOWERSALE SUM MIN MAX MAXDEC=0;
VAR Sale&SumVar;
CLASS Variety;
TITLE  "Summary of Sales &SumVar by Variety"; ;
RUN;
ODS RTF CLOSE;    *


D)	CREATING MODULAR CODE WITH MACROS

	--->	ANYTIME YOU FIND YOURSELF WRITTING THE SAME OR SIMILAR SAS STATEMENTS OVER AND OVER YOU SHOULD CONSIDER USING A MACRO. A MACRO LET
			YOU PACKAGE A PIECE OF BUG-FREE CODE AND USE IT REPEATEDLY WITHIN A SINGLE SAS PROGRAM OR IN MANY SAS PROGRAMS. YOU CAN THINK OF A
			MACRO AS A KIND OF SANDWICH. THE %MACRO AND %MEND STATEMENTS ARE LIKE TWO SLICES OF BREAD. BETWEEN THOSE SLICES YOU CAN PUT ANY
			STATEMENTS YOU WANT. THE GENERAL FORM OF A MACRO IS;
						%MACRO macro-name; 
						macro-text 
						%MEND macro-name; *


	--->	INVOKING A MACRO --  AFTER YOU HAVE DEFINED A MACRO, YOU CAN INVOKE IT BY ADDING THE PERCENT SIGN PREFIX TO IT'S NAME LIKE THIS
						%macro-name 
						A semicolon is not required when invoking a macro, though adding one generally does no harm

	--->	;


%MACRO SAMPLE;
PROC SORT DATA = FLOWERSALE;
BY DESCENDING SaleQuality;
RUN;
PROC PRINT DATA=FLOWERSALE(OBS=5);
FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
TITLE 'Five Largest Sales by Quantity';
RUN;
%MEND SAMPLE;

DATA FLOWERSALE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Tropical Flowers.csv" DSD DLM="," FIRSTOBS=2;
INPUT ID : $4. SaleDate : MMDDYY10. Variety : $10. SaleQuantity SaleAmount;
RUN;
%SAMPLE   *

	--->	MACRO AUTOCALL LIBRARIES -- THE MACRO IN THE BOOK ARE DEFINED AND INVOKED INSIDE A SINGLE PROGRAM, BUT YOU CAN ALSO STORE MACROS IN A 
			CENTRAL LOCATION CALLED AUTOCALL LIBRARY. MACROS IN A LIBRARY CAN BE SHARED BY PROGRAMS AND PROGRAMMERS. BASICALLY YOU SAVE YOUR MACRO 
			AS FILE IN A DIRECTORY OR AS A MEMBERS OF A PARTITIONED DATA SET, AND USE THE "MAUTOSOURCE" AND "SASAUTOS=" SYSTEM OPTION TO TELL SAS
			WHERE TO LOOK FOR MACROS. THEN YOU CAN INVOKE A MACRO VEN THROUGH TH ORIGINLA MACRO DOESN'T APPER IN YOUR PROGRAM.


E)	ADDING PARAMENTS TO MACROS

	--->	MACROS CAN SAVE ALOT OF TROUBLE, ALLOWING YOU TO WRITE A SET OF STATEMENTS ONCE AND THEN USE THEM OVER AND OVER. HOWEVER, YOU USUALLY
			DON'T WANT TO REPEAT EXACTLY THE SAME STATEMENTS. YOU MAY WANT TH SAME REPORT, BUT FOR DIFFERENT DATA SET, OR PRODUCT, OR PATIENT.
			PARAMETERS ALLOW YOU TO DO THIS. PARAMETERS ARE MACRO VARIABLES WHOSE VALUE YOU SET WHEN YOU INVOKE A MACROS, LIKE THE MACRO IN THE 
			PREVIOUS SECTION HAVE NO PARAMETERS. TO ADD PARAMETERS TO A MACRO, YOU SIMPLY LIST THE MACRO VAIRABLE NAMES BETWEEN PARENTHESE IN THE
			%MACRO STATEMENT. HERE IS ONE OF THE POSSIBLE FORMS OF THE PARAMETER LIST.;
				
							%MACRO	macro-name (parameter-1= , parameter-2= ,.......... parameter-n=);
								macro-text
							%MEND macro-name;

			FOR EXAMPLE, A MACRO NAMED %QUARTERLYREPORT MIGHT START LIKE THIS,
						
							%MACRO quarterlyreport(quarter=3,salerep=);


%MACRO select(Customer=,sortvar=);
PROC SORT DATA= FLOWERSALES OUT=SALESOUT;
BY &sortvar;
WHERE CustomerID = "&Customer";
RUN;

PROC PRINT DATA= SALESOUT;
FROMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
TITLE1 "Orders for Customer Number &customer";
TITLE2  "Sorted by &sortvar";
RUN;
%MEND select;

DATA FLOWERSALES;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Tropical Flowers.csv" DSD DLM="," FIRSTOBS=2;
INPUT CustomerID : $4. SaleDate : MMDDYY10. Variety : $10. SaleQuantity SaleAmount;
RUN;

%SELECT (CUSTOMER = 356W, sortvar = SaleQuantity);
%SELECT (CUSTOMER = 240W, sortvar= Variety);   *


F)	WRITTING MACROS WITH CONDITIONAL LOGICS
	
	--->	COMBING MACROS AND MACROS VARIABLES GIVES YOU ALOT OF FLEXIBILITY, YOU CAN INCREASE THAT FLEXIBILITY EVEN MORE BY ADDING MACRO
			STATEMENTS SUCH AS %IF. FORTUNATELY,MANY MACROS STATEMENTS HAVE PARALLEL STATEMTS IN STANDARD SAS CODE SO THEY SHOULD FEEL FAMILIAR;

							%IF condition %THEN action; 
							%ELSE %IF condition %THEN action; 
							%ELSE action; 
							%IF condition %THEN %DO; 
							SAS statements 
							%END; *


	--->	%IF STATEMENT CAN CONTAION ACTIONS THAT STANDARD IF STATEMENTS CAN'T CONTAIN, SUCH AS COMPLETE DATA OR PROC STEPS AND EVEN OTHER MACRO
			STATEMENTS. THE %IF-%THEN STATEMENT DON'T APPER IN THE STANDARD SAS CODE GENERATED BY YOUR MACRO. 

	--->	FOR EXAMPLE, YOU COULD COMBINE CONDITIONAL LOGIC WITH THE &SYSDAY AUTOMATIC VARIABLES LIKE THIS.;

							%IF &SYSDAY = Tuesday %THEN %LET country = Belgium; 
							%ELSE %LET country = France; 
			If you run the program on Tuesday, the macro processor resolves the statements to: 
							%LET country = Belgium; 
			If you run the program on any other day, then the macro processor resolves the statements to: 
							%LET country = France;


%MACRO dailyreports; 
   %IF &SYSDAY = Monday %THEN %DO; 
      PROC PRINT DATA = flowersales; 
         FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.; 
         TITLE 'Monday Report: Current Flower Sales'; 
      RUN; 
   %END; 
   %ELSE %IF &SYSDAY = Tuesday %THEN %DO; 
      PROC MEANS DATA = flowersales MEAN MIN MAX; 
         CLASS Variety; 
         VAR SaleQuantity; 
         TITLE 'Tuesday Report: Summary of Flower Sales'; 
      RUN; 
   %END; 
%MEND dailyreports; 
 
DATA flowersales; 
   INFILE "D:\Practice\SAS\Little SAS Book\Data\Tropical Flowers.csv" DSD DLM="," FIRSTOBS=2;
   INPUT CustomerID : $4. SaleDate : MMDDYY10. Variety : $10. SaleQuantity SaleAmount;
RUN; 
%dailyreports 

*When the program is submitted on Tuesday, the macro processor will write this program;

DATA flowersales; 
   INFILE "D:\Practice\SAS\Little SAS Book\Data\Tropical Flowers.csv" DSD DLM="," FIRSTOBS=2;
   INPUT CustomerID : $4. SaleDate : MMDDYY10. Variety : $10. SaleQuantity SaleAmount;
RUN; 

PROC MEANS DATA = flowersales MEAN MIN MAX; 
   CLASS Variety; 
   VAR SaleQuantity; 
   TITLE 'Tuesday Report: Summary of Flower Sales'; 
RUN;  *

G)	WRITTING DATA DRIVEN PROGRAMS WITH CALL SYMPUT

	--->	WHEN YOU SUBMIT A SAS PROGRAM CONTAINING MACROS IT GOES TO THE MACRO PROCESSOR WHICH GENERATES STANDARD SAS CODE FROM THE MACRO 
			REFERENCES. THEN SAS COMPILES AND EXECUTES YOUR PROGRAM. NOT UNTIL EXECUTION THE FINAL STANGE DOES SAS SEE ANY ACTUAL DATA VALUES.
			THIS IS THE TRICKY PART OF WRITTING DATA DRIVEN PROGRAMS: SAS DOESN'T KNOW THE VALUES OF YOUR DATA UNTIL THE EXECUTION PHASE, 
			AND BY THAT TIME IT IS ORDINARILY TOO LAYE. HOWEVER, THERE IS A WAY TO HAVE YOUR DIGITAL CAKE AND EAT IT TOO-"CALL SYMPUT":

	--->	"CALL SYMPUT" TAKES A VALUE FROM A DATA STEP AND ASSIGNS IT TO A MACRO VARIABLE. YOU CAN THEN USE THIS MACRO VARIBALE IN LATER
			STEPS TO ASSIGN A VALUE TO SINGLE MACRO VARIABLE, YOU USE "CALL SYMPUT" WITH THIS GENERAL FORM;

							CALL SYMPUT("macro-variable-name",value); 

*	--->	"CALL SYMPUT" IS OFTEN USED IN IF-THEN STATEMENT;

							IF Age >= 18 THEN CALL SYMPUT ("Status", "Adult");
							ELSE CALL SYMPUT("Status", "Minor");

*	--->	THESE STATEMENTS CREAT A MACRO VARIABLE NAMED "&STATUS" AND ASSIGN TO IT A VALUE OF ADULT OR MINOR DEPENDING ON THE VARIABLE AGE.
			THE FOLLOWING "CALL SYMPUT" USES A VARIABLE AS IT'S VALUE;
 
							IF TotalSales > 1000000 THEN CALL SYMPUT("bestseller", BookTitle); 

*	--->	THIS STATEMENT TELLS SAS TO CREATE A MACRO VARIBALE NAMED "&BESTSELLER" WHICH IS EQUAL TO THE VALUE FO THE VARIBALE OF THE VARIBALE
			BOOKTITLE WHEN TOTAL SALES EXCEED 1,000,000.


	--->	CAUTION YOU CAN'T CREATE A MACRO VARIBALE WITH "CALL SYMPUT" AND USE IT IN THE SAME DATA STEP BECASUE SAS DOESN'T ASSIGN A VALUE TO
			THE VARIBALE UNTIL THE DATA STEP EXECUTES. DATA STEPS EXECUTES WHEN SAS ENCOUNTERS A STEP BOUNDARY SUCH AS A SUBSEQUENT DATA, PROC OR 
			RUN STATEMENT.;



DATA flowersales; 
   INFILE "D:\Practice\SAS\Little SAS Book\Data\Tropical Flowers.csv" DSD DLM="," FIRSTOBS=2;
   INPUT CustomerID : $4. SaleDate : MMDDYY10. Variety : $10. SaleQuantity SaleAmount;
RUN; 

PROC SORT DATA = flowersales; 
BY DESCENDING SaleAmount; 
RUN; 

* Find biggest order and pass the customer id to a macro variable; 

DATA _NULL_; 
SET flowersales; 
IF _N_ = 1 THEN CALL SYMPUT("selectedcustomer",CustomerID); 
ELSE STOP; 
RUN; 

PROC PRINT DATA = flowersales; 
WHERE CustomerID = "&selectedcustomer"; 
FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.; 
TITLE "Customer &selectedcustomer Had the Single Largest Order"; 
RUN; *


H)	DEBUGGING MACRO ERRORS

	--->	AVOIDING MACRO ERRORS -- AVOIDING MACRO ERRORS AS MUCH AS POSSIBLE, DEVELOPE YOUR PROGRAM IN STANDARD SAS CODE FIRST. THEN, WHEN IT IS
			BUG-FREE, ADD THE MACRO LOGIC ONE FEATURE AT A TIME. ADD YOUR "%MACRO" AND %MEND STATEMENTS. WHEN THAT'S WORKING AD YOUR MACRO VARIABLES
			ONE AT A TIME, AND SO ON UNTIL YOUR MACRO IS COMPLETE AND BUG FREE.

	--->	QUOTING PROBLEMS -- THE MACRO PROCESSOR DOESN'T RESOLVE MACROS INSIDE SINGLE QOTATION MARKS. TO GET AROUND THIS, USE DOUBLE QUOTATION
			MARKS WHENEVER YOU REFER TO A MACRO OR MACRO VARIABLE AND YOU WNAT SAS TO RESOLVE IT.

	--->	FOR EXAMPLE, BELOW ARE TWO "TITLE" STATEMENTS CONTAINING A MACRO VARIBALE NAMED &MONTH. IF THE VALUE OF &MONTH IS JANUARY, THEN SAS 
			WILL SUBSTITUTE JANUARY IN THE TITLE WITH THE DOUBLE QUOTATION MARKS, BUT NOT THE TITLW WITH SINGLE QUOTATION MARKS.

	
					ORIGINAL STATEMENT 								STATEMENT AFTER RESOLUTION

					TITLE "REPORT FOR &MONTH"						TITLE "REPORT FOR &MONTH"
					TITLE "REPORT FOR &MONTH"						TITLE ""REPORT FOR &JANUARY"

	--->	SYSTEM OPTIONS FOR DEBUGGING MACROS AFFECT THE KIND OF MESSAGES SAS WRITES IN YOUR LOG.
					
				MIRROR | NOMIRROR				WHEN THIS OPTION IS ON, SAS WILL ISSUE A WARNING IF YOU INVOKE A MACRO THAT SAS CAN'F FIND.
					
				SERROR | NOSERROR				WHEN THIS OPTIONS IS ON, SAS WILL ISSUE A WARNING IF YOU CAN USE A MACRO VARIBALE SAS CAN'T FIND
		
				MLOGIC | NOMLOGIC				SAS PRINTS IN YOUR LOG DETAILS ABOUT THE EXCUTION OF YOUR MACROS.

				MPRINT | NOMPRINT				SAS PRINTS IN YOUR LOG THE STANDARD SAS CODE GENERATED BY MACROS.

				SYMBOLGEN | NOSYMBOLGEN			SAS PRINTS IN YOUR LOG THE VALUE OF MACRO VARIABLES.

	--->	MERROR message -- IF SAS HAS TROUBLE FINDING A MACRO, AND THE MERROR OPTION IS ON, THEN SAS WILL PRINT MESSAGE:
								
								WARNING: Apparent invocation of macro SAMPL not resolved


	--->	SERROR message -- IF SAS HAS TOUBLE RESOLVING A MACRO VARIABLE IN OPEN CODE AND THE SERROR OPTION IS ON, THEN SAS WILL PRINT MESSAGE:


								WARNING: Apparent symbolic reference FLOWER not resolved


	--->	MLOGIC messages -- WHEN THE MLOGIC IS ON, SAS PRINTS MESSAGES IN YOUR LOG DESCRIBING THE ACTIONS OF THE MACRO PROCESSOR.
			HERE IS A MACRO NAMED "%SAMPLE";

								%MACRO sample(flowertype=); 
								PROC PRINT DATA = flowersales; 
								WHERE Variety = "&flowertype"; 
								RUN; 
								%MEND sample; *


	--->	IF YOU RUN %SAMPLE WITH THE "MLOGIC" OPTION, YOUR LOG WILL LOOK LIKE THIS; 
								24  OPTIONS MLOGIC 
								25   %sample(flowertype=Anthurium) 
								MLOGIC(SAMPLE):  Beginning execution. 
								MLOGIC(SAMPLE):  Parameter FLOWERTYPE has value Anthurium 
								MLOGIC(SAMPLE):  Ending execution ; *

	--->	MPRINT messages  --- WHEN TH MPRINT OPTION IS ON, SAS PRINTS MESSAGES IN YOUR LOG SHOWING THE SAS STATEMENTS GENERATED BY MACRO.
			IF YOU RUN %SAMPLE WITH THE MPRINT OPTION, YOUR LOG WILL LOOK LIKE THIS;
								36  OPTIONS MPRINT;
								37  %sample(flowertype=Anthurium)
								MPRINT(SAMPLE):   PROC PRINT DATA = flowersales; 
								MPRINT(SAMPLE):   WHERE Variety = "Anthurium"; 
								MPRINT(SAMPLE):   RUN;*

	--->	SYMBOLGEN messages --- WHEN THE SYMBOLGEN OPTIONS IS ON, SAS PRINTS MESSAGES IN YOUR LOG SHOWING THE VALUE OF EACH MACRO VARIBALE AFTER
			RESOLUTION. IF YOU RUN %SAMPLE WITH "SYMBOLGEN" OPTION YOUR LOG WILL LOOK LIKE THIS;
								30  OPTIONS SYMBOLGEN; 
								31  %sample(flowertype=Anthurium) 
								SYMBOLGEN:  Macro variable FLOWERTYPE resolves to Anthurium
