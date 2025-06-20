*
A)	MODIFYING A DATA SET USING THE SET STATEMENT

		--->	THE "SET" STATEMENT IN THE DATA STEP ALLOWS YOU TO READ A SAS DATA SET SO YOU CAN ADD NEW VARIABLE, CREATE A SUBSET, OR OTHERWISE
				MODIFY THE DATA SET. IF YOU WE SHORT ON DISK SPACE, FOR EXAMPLE, YOU MIGHT NOT WANT TO STORE YOUR COMPUTD VARIABLES IN A PERMANENT
				SAS DATA SET. INSTEAD, YOU MIGHT WANT TO CALCULATE THEM AS NEEDED FOR ANALYSIS. LIKEWISE, TO SAVE PROCESSING TIME, YOU MIGHT WANT
				TO CREATE A SUBSET OF A SAS DATASET WHEN YOU WANT TO LOOK AT A SMALL PORTION OF A LARGE DATA SET. THE "SET" STATEMENT BRINGS A SAS
				DATA SET, ONE OBSERVATION AT A TIME, INTO DATA STEP FOR PROCESSING.

		--->	TO READ A SAS DATA SET, START WITH THE DATA STATEMENT SPECIFYING THE NAM OF NEW DATA SET. THEN FOLLOW WITH THE "SET" STATEMENT 
				SPECIFYING THE NAME OF THE OLD DATA SET YOU WANT TO READ. IF YOU DON'T WANT TO CREATE A NEW DATA SET, YOU CAN SPECIFY THE SAME 
				NAME IN THE "DATA" AND "SET" STATEMENTS. THEN THE RESULTS OF THE DATA STEP WILL OVERWRITE THE OLD DATA SET NAMED IN THE "SET"
				STATEMENT. THE FOLLOWING SHOWS THE GENERAL FOM OF THE "DATA" AND "SET" STATEMENT.

							DATA new-data-set:
								SET data-set:

		--->	ANY ASSIGNMENT, SUBSETTING "IF", OR OTHER DATA STEP STATEMENTS USUALLY FOLLOW THE "SET" STATEMENT. FOR EXAMPLE, THE FOLLWOING
				CREATES A NEW DATA SET, FRIDAY, WHICH IS A REPLICA OF THE "SALES" DATA SET, EXCEPT "FRIDAY" HAS ONLY THE OBSERVATIONS FOR FRIDAY
				AND IT HAS ADDITIONAL VARIABLE, TOTAL:

							DATA FRIDAY:
								SET SALES:
								IF DAY="F":
								TOTAL = POPCORN + PEANUTS:
							RUN;

DATA TRAINRIDE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Amusement Park.csv" DSD DLM="," FIRSTOBS=2;
INPUT TIME : TIME5. CARS  PEOPLE;
RUN;
DATA AVERAGETRAIN;
SET TRAINRIDE;
PEOPLEPERCAR = PEOPLE / CARS;
RUN;
PROC PRINT DATA = AVERAGETRAIN;
TITLE "AVERAGE NUMBER OF PEOPLE PER TRAIN PER CAR";
FORMAT TIME TIME5.;
RUN;			*

B)	STACKING DATA SETS USING SET STATEMENT

		--->	THE "SET" STATEMENT WITH ONE SAS DATA SET ALLOWS YOU TO READ AND MODIFY THE DATA. WITH TWO OR MORE DATA SETS, IN ADDITION TO 
				READING AND MODIFYING THE DATA, THE "SET" STATEMENT CONCATENATES OR STACKS THE DATA SETS ONE ON TOP OF OTHER. THIS IS USEFUL
				WHEN YOU WANT TO COMBINE DATA SETS WITH ALL OR MOST OF THE SAME VARIABLES BUT DIFFERENT OBSERVATIONS. YOU MGITH, FOR EXAMPLE,
				HAVE DATA FROM TWO DIFFERENT LOCATIONS OR DATA TAKEN AT TWO SEPARATE TIMES, BUT YOU NEED THE DATA TOGETHER FOR ANALYSIS.

		--->	IN A DATA STEP SPECIFY THE NAME OF THE NEW SAS DATA SET IN THE DATA STATEMENT, THEN LIST THE NAMES OF THE OLD DATA SETS YOU WANT
				TO COMBINE IN THE "SET" STATEMENT.
						DATA new-data-set:
							SET data-set-1 data-set-n:

		--->	THE NUMBER OF OBSERVATIONS IN THE NEW DATA SET WILL EQUAL THE SUM OF THE NUMBER OF OBSERVATIONS IN THE OLD DATA SETS. THE ORDER
				OF OBSERVATIONS IS DETERMINED BY THE ORDER OF THE LIST OF OLD DATA SETS. IF ONE OF DATA SET HAS A VARIABLE NOT CONTAINED IN THE
				OTHER DATA SETS, THEN THE OBSERVATIONS FROM THE OTHER DATA SETS WILL HAVE MISSING VALUES FOR THE VARIBALE.;

DATA SOUTHENTRANCE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Entrance South.csv" DSD DLM="," FIRSTOBS=2;
INPUT ENTRANCE$ PASS_NUMBER PARTY_SIZE AGE;
RUN;
PROC PRINT DATA=SOUTHENTRANCE;
TITLE"SOUTH ENTRANCE DATA";
RUN;
DATA NORTHENTRANCE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Entrance North.csv" DSD DLM="," FIRSTOBS=2;
INPUT ENTRANCE$ PASS_NUMBER PARTY_SIZE AGE PARKING_LOT;
RUN;
PROC PRINT DATA=NORTHENTRANCE;
TITLE"NORTH ENTRANCE DATA";
RUN;

DATA BOTH;
SET SOUTHENTRANCE NORTHENTRANCE;
IF AGE = . THEN AMOUNTPAID = .;
ELSE IF AGE < 3 THEN AMOUNTPAID= 0;
ELSE IF AGE < 65 THEN AMOUNTPAID=35;
ELSE AMOUNTPAID = 27;
RUN;
PROC PRINT DATA= BOTH;
TITLE "BOTH ENTRANCE";
RUN; *

C) INTERLEAVING DATA SETS USING THE SET STAEMENT

		--->	IF YOU HAVE DATA SETS THAT ARE ALREADY SORTED BY SOME IMPORTANT VARIBALES. THEN SIMPLY STACKING THE DATA SETS MAY UNSORT THE DATA
				SETS. YOU COULD STACK THE TWO DATA SETS AND THEN RE-SORT THEM USING PROC SORT. BUT IF YOUR DATA SETS ARE ALREADY SORTED, IT IS MORE
				EFFICIENT TO PRESERVE THAT ORDER, THEN TO STACK AND RE-SORT. ALL YOU NEED TO DO IS USE A "BY" STATEMENT WITH YOUR "SET" STATEMENT.
							DATA new-data-set: 
							SET data-set-1 data-set-n: 
							BY variable-list;

DATA SOUTHENTRANCE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Entrance South.csv" DSD DLM="," FIRSTOBS=2;
INPUT ENTRANCE$ PASS_NUMBER PARTY_SIZE AGE;
RUN;
PROC PRINT DATA=SOUTHENTRANCE;
TITLE"SOUTH ENTRANCE DATA";
RUN;
DATA NORTHENTRANCE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Entrance North.csv" DSD DLM="," FIRSTOBS=2;
INPUT ENTRANCE$ PASS_NUMBER PARTY_SIZE AGE PARKING_LOT;
PROC SORT DATA = NORTHENTRANCE;
BY PASS_NUMBER;
PROC PRINT DATA = NORTHENTRANCE;
TITLE "NORTH ENTRANCE DATA";
RUN;

DATA INTERLEAVE;
SET NORTHENTRANCE SOUTHENTRANCE;
BY PASS_NUMBER;
RUN;
PROC PRINT DATA=INTERLEAVE;
TITLE"BOTH ENTRANCE DATA";
RUN;  *

D)	COMBING DATA SETS USING A ONE-TO-ONE MATCH MERGE
	
	--->	WHEN YOU WANT TO MATCH OBSERVATIONNS FROM ONE DATA SET WITH OBSERVATION FROM ANOTHER. USE THE "MERGE"  STATEMENT IN THE DATA STEP. IF
			OU KNOW THE TWO DATA SETS ARE IN EXACTLY THE SAME ORDER, YOU DON'T HAVE TO HAVE ANY COMMON VARIABLES BETWEEN THE DATA SETS. TYPICALLY
			HOWEVER, YOU WILL WANT TO HAVE, FOR MATCHING PURPOSES, A COMMON VARIABE OR SEVERAL VARIABLES WHICH TAKEN TOGETHER UNIQUELY IDENTIFY EACH
			OBSERVATION. THIS IS IMPORTANT. HAVING A COMMON VARIBAL TO MERGE BY ENSURE THAT THE OBSERVATIONS ARE PROPERLY MATCHED. FOR EXAMPLE, TO
			MERGE PATIENT DATA WITH BILLING DATA, YOU WOULD US THE PATIENT ID AS A MATCHING VARIABLE. OTHERWISE YOU RISK GETTING MARY SMITH'S VISIT
			THE OBSTETRICIAN MIXED UP WITH MATHEW SMITH'S VISIT TO THE OPTOMTRIST.

	--->	MERGING SAS DATA SETS IS A SIMPLE PROCESS. FIRST, IF THE DATA ARE NOT ALREADY SORTED, USE THE "SORT" PROCEDURE TO SORT ALL DATA SETS
			BY THE COMMON VARIABLE. THEN, IN THE DATA STATEMENT, NAME THE NEW SAS DATA SET TO HOLD THE RESULTS AND FOLLOW WITH A 'MERGE' STATEMENT
			LISTING THE DATA SETS TO BE COMBINED. USE A "BY" STATEMENT TO INDICATE THE COMMON VARIBALE.

						DATA new-data-set:
							MERGE data-set-one data-set-n:
							BY variable-list;

DATA SALE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Choclater 1.csv" DSD DLM="," FIRSTOBS= 2 TRUNCOVER;
INPUT ID : $4. NUMBER;
RUN;
DATA DESCRIPTION;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Choclater 2.csv" DSD DLM=',' FIRSTOBS=2 TRUNCOVER;
INPUT ID : $4. NAME : $15.	DESCRIPTION : $60. ;
RUN;
PROC SORT DATA= SALE;
BY ID;
RUN;
DATA CHOCLATES;
MERGE SALE DESCRIPTION;
BY ID;
RUN;
PROC PRINT DATA = CHOCLATES;
TITLE "TODAY'S CHOCLATE SALE";
RUN;  *


E)	COMBING DATA SETS USING A OBE-TO-MANY MATCH MERGE

	--->	SOMETIMES YOU NEED TO COMBINE TWO DATA SETS BY MATCHING ONE OBSERVATION FROM ONE DATA SET WITH MORE THAN ONE OBSERVATION IN ANOTHER.
			SUPPOSE YOU HAD DATA FOR EVERY STAT IN THE U.S AND WANTED TO COMBINE IT WITH DATA FOR EVERY COUNTY. THIS WOULD BE A ONE-TO-MANY MATCH
			MERGE BECASUE EACH STATE OBSERVATION MATCHES WITH MANY COUNTRY OBSERVATION.

	--->	THE STATEMENTS FOR A ONE-TO-MANY MATCH MERGE ARE IDENTICAL TO THE STATEMENTS FOR A ONE-TO-ONE MATCH MERGE:
						DATA new-data-set: 
							MERGE data-set-1 data-set-2: 
							BY variable-list;

DATA SHOOES;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Shooes.csv" DSD DLM="," FIRSTOBS=2;
INPUT STYLE : $15.	EXCERCISE_TYPE	: $10.	REGULAR_PRICE;
RUN;
PROC SORT DATA=SHOOES;
BY EXCERCISE_TYPE;
RUN;
DATA DISCOUNT;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Shooes Discount.csv" DSD DLM="," FIRSTOBS=2;
INPUT EXCERCISE_TYPE : $10.	DISCOUNT;
RUN;
DATA FINAL;
MERGE SHOOES DISCOUNT;
BY EXCERCISE_TYPE;
NEWPRICE = ROUND (REGULAR_PRICE - (REGULAR_PRICE * DISCOUNT), .01);
RUN;
PROC PRINT DATA= FINAL;
TITLE "PRICE LIST FOR JUNE";
RUN; *


F)	MERGING SUMMARY STATISTICS WITH ORIGINAL DATA
	
	--->	ONCE IN A WHILE YOU NEED TO COMBINE SUMMARY STATISTICS WITH YOUR DATA, SUCH AS WHEN YOU WANT TO COMPARE EACH OBSERVATION TO THE GROUP
			MEAN, OR WHEN YOU WANT TO CALCULATE A PERCENTAGE USING THE GROUP TOTAL. TO DO THIS, SUMMARIZE YOUR DATA USING "PROC MEANS" AND PUT THE
			RESULTS IN A NEW DATA SET. THEN MERGE THE SUMMARIZED DATA BACK WITH THE ORIGINAL DATA USING A ONE-TO-MANY MATCH MERGE.;

DATA ATHLETICS;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Shooes Athletic.csv" DSD DLM=',' FIRSTOBS=2;
INPUT STYLE : $15. EXCERCISE_TYPE : $10.	SALE;
RUN;
PROC SORT DATA=ATHLETICS;
BY EXCERCISE_TYPE;
RUN;
PROC MEANS NOPRINT DATA = ATHLETICS;
VAR SALE;
BY EXCERCISE_TYPE;
OUTPUT OUT= SUMMARYDATA SUM(SALE) = TOTAL;
RUN;
PROC PRINT DATA = SUMMARYDATA;
TITLE "SUMMARY DATASET";
RUN;
DATA SHOOESSUMMARY;
MERGE ATHLETICS SUMMARYDATA;
BY EXCERCISE_TYPE;
PERCENT = SALE / TOTAL * 100;
RUN;
PROC PRINT DATA = SHOOESSUMMARY;
BY EXCERCISE_TYPE;
ID EXCERCISE_TYPE;
VAR STYLE SALE TOTAL PERCENT;
TITLE 'SALES SHARE BY TYPE OF EXCERCISE';
RUN; *


G)	COMBING A GRAND TOTAL WITH ORIGINAL DATA
	
	--->	YOU CAN USE THE "MEANS" PROCEDURE TO CREATE A DATA SET CONTAINING A GRAND TOTAL RATHER THAN "BY"  GROUP TOTALS. BUT YOU CAN'T USE A
			"MERGE" STATEMENT TO COMBINE A GRAND TOTAL WITH ORIGINAL DATA BECAUSE THERE IS NO COMMON VARIABLE TO MERGE BY. LUCKILY, THERE IS ANOTHR
			WAY. YOU CAN USE TWO SET STATEMS LIKE THIS.

					DATA new-data-set:
						IF_N_ = 1 THEN SET summary-data-set:
						SET oiginal-data-set;


DATA SHOES2; 
INFILE "D:\Practice\SAS\Little SAS Book\Data\Shooes Athletic.csv" DSD DLM=',' FIRSTOBS=2;
INPUT STYLE : $15. EXCERCISE_TYPE : $7. SALES; 
RUN; 
 
PROC MEANS NOPRINT DATA = SHOES2; 
VAR SALES; 
OUTPUT OUT = SUMMARYDATA SUM(SALES) = GRANDTOTAL; 
RUN; 

PROC PRINT DATA = SUMMARYDATA; 
TITLE 'Summary Data Set'; 
RUN; 
 
DATA SHOESSUMMARY; 
IF _N_ = 1 THEN SET SUMMARYDATA; 
SET SHOES2; 
PERCENT = SALES / GRANDTOTAL * 100; 
RUN; 

PROC PRINT DATA = SHOESSUMMARY; 
VAR STYLE EXCERCISE_TYPE SALES GRANDTOTAL PERCENT; 
TITLE 'Overall Sales Share'; 
RUN; *

H)	UPDATING MASTER DATSET WITH TRANSACTIONS

	--->	THE "UPDATE" STATEMENT IS USED FAR LESS THAN THE "MERGE" STATEMENT. BUT IT IS JUST RIGHT FOR THOSE TIMES WHEN YOU HAVE MASTER DATASET
			WHICH MUST BE UPDATED WITH BITS OF NEW INFORMATIONS. A BNAK ACCOUNT IS A GOOD EXAMPLE OF THIS TYPE OF TRANSECTION-ORIENTED DATA, SINCE
			SINCE IT IS REGULARY UPDATED WITH CREDIT AND DEBIT

	--->	UPDATE STATEMENT IS SIMILAR TO THE "MERGE" STATEMENT, BECASUE BOTH COMBINES DATA SETS BY MATCHING OBSERVATIONS ON COMMON VARIABLE.
			HOWEVER, THERE ARE CRITICAL DIFFERENCES:

	--->	FIRST, WITH "UPDATE" THE RESULTING MASTER DATA SET ALWAYS HAS JUST ONE OBSERVATION FOR EACH UNIQUE VALUE OF THE COMMON VARIABLE. THAT
			WAY, YOU DON'T GET A NEW OBSERVATION FOR YOUR BANK ACCOUNT EVEY TIME YOU DEPOSIT A PAYCHECK.

	--->	SECOND, MISSING VALUE IN THE TRANSACTION DATA SET DO NOT OVERWRITE EXISTING VALUES IN THE MASTER DATA SET. THAT, WAY YOU ARE NOT 
			OBLIGED TO ENTER YOUR ADDRESS OR TAX ID NUMBER EVERYTIME YOU MAKE A WITHDRAWAL.
							DATA master-data-set: 
							UPDATE master-data-set transaction-data-set: 
							BY variable-list; 


LIBNAME PRACTICE 'D:\Practice\SAS\Little SAS Book\Practice';
DATA PRACTICE.PATIENT;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Patient Master Database.csv" DSD DLM="," FIRSTOBS=2;
INPUT Account LastName : $10.	Address : $17.	BirthDate : MMDDYY10. Sex$	InsCode : $4. LastUpdate : MMDDYY10.;
RUN;

LIBNAME PRACTICE 'D:\Practice\SAS\Little SAS Book\Practice';
DATA TRANSECTION;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Patient Database.csv" DSD DLM="," FIRSTOBS=2;
INPUT Account LastName : $10.	Address : $17.	BirthDate : MMDDYY10. Sex$	InsCode : $4. LastUpdate : MMDDYY10.;
RUN;
PROC SORT DATA = TRANSECTION;
BY Account;
RUN;
DATA PRACTICE.PATIENT;
UPDATE PRACTICE.PATIENT TRANSECTION;
BY Account;
RUN;
PROC PRINT DATA = PRACTICE.PATIENT;
FORMAT BirthDate LastUpdate MMDDYY10.;
TITLE 'ADMISSION DATA';
RUN;		*

I)	WRITTING MULTIPLE DATA SETS USING THE OUTPUT STATEMENT

	--->	NORMALLY WE WANT TO MAKE ONLY ONE DATA SET IN EACH STEP. HOWEVER, THERE MAYBE TIMES WHEN IT IS MORE EFFICIENT OR MORE CONVENIENT TO
			CREATE MULTIPLE DATA SETS IN A SINGLE DATA STEP. YOU CAN DO THIS BY SIMPLY MORE THAN ONE DATA SET NAME IN YOUR DATA STATEMENT. THE 
			THE STATEMENT BELOW TELLS SAS TO CREATE THREE DATA SETS NAME "LIONS", "TIGERS" AND BEARS:
						DATA lions tigers bears:

	--->	IF THAT IS ALL YOU DO, THEN SAS WILL WRITE ALL THE OBSERVATIONS TO ALL THE DATA SETS, AND YOU WILL HAVE THREE IDENTICAL DATA SETS.
			NORMALLY, OFCOURSE, YOU WANT TO CREATE DIFFERENT DATA SETS. YOU CAN DO THAT WITH AN OUPUT STATEMENT.

	--->	EVERY DATA STEP HAS AN IMPLIED "OUTPUT" STATEMENT AT THE END WHICH TELLS SAS TO WRITE THE CURRENT OBSERVATION TO THE OUTPUT DATA SET
			BEFORE RETURNING TO THE BEGINNING OF THE DATA STEP TO PROCESS THE NEXT OBSERVATION. YOU CAN OVERRIDE THIS IMPLICIT "OUPUT" STATEMENT
			WITH YOUR OWN "OUTPUT" STATEMENT. THE BASIC FORM OF THE OUTPUT STATEMENT IS
						OUTPUT data-set-name:

	--->	IF YOU LEAVE OUT THE DATA SET NAME, THEN THE OBSERVATION WILL BE WRITTNE TO ALL DATA SETS NAMED IN THE DATA STATEMENT. "OUTPUT"
			STATEMENTS CAN BE USED ALONE OR IN "IF-THEN" OR "DO-LOOP" PROCESSING.
						IF family = 'Ursidae' THEN OUTPUT bears;

DATA MORNING EVENING;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Local Zoo Maintains.csv" DSD DLM="," FIRSTOBS=2;
INPUT ANIMAL : $10. CLASS : $10. ENCLOUSER : $2. FEEDTIME : $4.;
IF FEEDTIME = "AM" THEN OUTPUT MORNING;
	ELSE IF FEEDTIME = "PM" THEN OUTPUT EVENING;
	ELSE IF FEEDTIME = "BOTH" THEN OUTPUT;
RUN;
PROC PRINT DATA= MORNING;
TITLE "ANIMALS WITH MORNING FEEDING";
RUN;
PROC PRINT DATA = EVENING;
TITLE "ANIMALS WITH EVENING FEEDING";
RUN;		*


J)	MAKING SEVERAL OBSERVATIONS FROM ONE USING THE OUTPUT STATEMENT

	--->	USUALLY SAS WRITES AN OBSERVATION TO A DATA SET AT THE END OF THE DATA STP, BUT YOU CAN OVERRIDE THIS DEFAULT USING THE "OUTPUT"
			STATEMET. IF YOU WANT TO WRITE SEVERAL OBSERVATIONS FOR EACH PASS THROUGH THE DATA STEP, YOU CAN PUT AN OUTPUT STATEMENT IN A DO
			LOOP OR JUST USE SEVERAL OUTPUT STATEMENTS. THE OUPUT STATEMENT GIVES YOU CONTROL OVER WHEN AN OBSERVATION IS WRITTEN TO A SAS DATA SET.
			IF YOUR DATA STEP DOESN'T HAVE AN OUTPUT STATEMENT, THEN IT IS IMPLIED AT THE END OF THE STEP. ONCE YOU PUT AN OUTPUT STATEMENT IN 
			YOUR DATA STEP, IT IS NO LONGER IMPLIED, AND SAS WRITES AN OBSERVATION ONLY WHEN ITENCOUNTERS AN OUTPUT STATEMENT.;

DATA GENERATE;
DO X = 1 TO 6;
	Y= X ** 2;
	OUTPUT;
END;
PROC PRINT DATA=GENERATE;
TITLE"GENERATED DATA";
RUN;


DATA MOVIE;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Movie Ticket Sale.csv" DSD DLM=',' FIRSTOBS=2;
INPUT MONTH $ LOCATION $ TICKETS @;
OUTPUT;
INPUT LOCATION $ TICKETS @;
OUTPUT;
INPUT LOCATION $ TICKETS;
OUTPUT;
RUN;
PROC PRINT DATA=MOVIE;
TITLE "TICKET SALE";
RUN;   *


K)	USING SAS DATASET OPTIONS

	--->	SAS DATA SET OPTIONS AFFECTS ONLY HOW SAS READS OR WRITES AN INDIVIDUAL DATA SET. YOU CAN USE DATA SET OPTIONS IN DATA STEPS
			(IN DATA, MERGE OR UPDATE STATEMENT) OR IN "PROC STEPS" (IN CONJUCTION WITH A "DATA=" OPTIONS). TO USE A DATA SET OPTION, YOU 
			SIMPLY PUT IT BETWEEN PARENTHESES DIRECTLY FOLLOWING THE DATA SET NAME. THESE ARE THE MOST FREQUENTLY USED DATA SET OPTIONS:

					KEEP = variable-list				TELLS SAS WHICH VARIABLE TO KEEP

					DROP = variable-list				TELLS SAS WHICH VARIBALE TO DROP

					RENAME = (oldvar = newvar)			TELLS SAS TO RENAME CERTAIN VARIABLES

					FIRSTOBS = n						TELLS SAS TO START READING AT OBSERVATION n

					OBS=n								TELLS SAS TO STOP READING AT OBSERVATION n
		
					LABEL = 'data-set-label'			SPECIFIES A DESCRIPTIVE LABEL FOR A SAS DATA SET

					IN = new-var-name					CREATES A TEMPERORY VARIABLE FOR TRACKING WHETHER
														THAT DATA SET CONTRIBUTED TO CURRENT OBSERVATION

					WHERE = condition					SELECTS AN OBSERVATION THAT MEETS A SPECIFIC CONDITION


	--->	SELECTING AND RENAMING VARIABLES -- HERE ARE EXAMPLES OF "KEEP=", "DROP=" AND "RENAME=" DATA SET OPTIONS
						
						DATA selectdvars:
							SET animals (KEEP= Class Species Status):

						PROC PRINT DATA = animals (DROP = Habitat):
						
						DATA animals (RENAME= (Class = Type Habitat= Home)):
							SET animals:
						PROC PRINT DATA = animals (RENAME= (Class = Type Habitat= Home)):

	--->	SELECTING OBSERVATION BY OBSERVATION NUMBER -- YOU CAN USE "FIRSTOBS" AND "OBS=" DATA SET OPTIONS TOGETHER TO TELL SAS WHICH OBSERVATIONS
			TO READ FROM DATA SET.

						DATA animals: 
							SET animals (FIRSTOBS = 101 OBS = 120): 
							PROC PRINT DATA = animals (FIRSTOBS = 101 OBS = 120):

	--->	LABELING SAS DATA SETS --  LABEL= ADDS A TEXT STRING TO THE DESCRIPTOR PROTION OF YOUR DATA SET.
						DATA rare (LABEL = 'Endangered Species Data'):
							SET animals:
							IF Status = 'Endangered':


K)	TRACKING AND SELECTING OBSERVATIONS WITH THE "IN=" OPTION

	--->	WHEN YOU COMBINE TWO DATA SETS, YOU CAN USE "IN=" OPTIONS TO TRACK WHICH OF THE ORIINAL DATA SETS CONTRIBUTED TO EACH OBSERVATION IN 
			THE NEW DATA SET. YOU CAN THINK OF THE "IN=" OPTION AS A SORT OF TAG. 

	--->	THE "IN=" DATA SET OPTION CAN BE USED ANY TIME YOU READ A SAS DATA SET IN A DATA STEP-WITH "SET", "MERGE" OR "UPDATE" BUT IS MOST OFTEN
			USED WITH "MERGE". TO USE THE "IN=" OPTION, YOU SIMPLY PUT THE OPTION IN PARENTHESE DIRECTLY FOLLOWING THE DATA SET YOU WANT TO TRACK,
			AND SPECIFY A NAME FOR THE "IN=" VARIABLE. THE NAME OF "IN=" VARIBALES MUST FOLLOW STANDARD SAS NAMING CONVENTIONS

	--->	THE DATA SETP BELOW CREATES A DATA SET NAMED "BOTH" BY MERGING TWO DATA SETS NAMED "STATE" AND "COUNTY". THEN THE "IN=" OPTIONS CREATE
			TWO VARIABLES NAMED "InState" and "InCounty":

						DATA both: 
							MERGE state (IN = InState) county (IN = InCounty): 
							BY StateName:

	--->	YOU CAN USE THIS VARIBALE LIKE ANY OTHER VARIABLE IN THE CURRENTLY DATA STEP, BUT IT IS MOST OFTEN USED IN SUBSETTING "IF" OR "IF-THEN"
			STATEMENTS SUCH AS THESE:

						Subsetting IF: 	IF InState = 1: 
										IF InCounty = 0: 
										IF InState = 1 AND InCounty = 1: 
										IF-THEN: IF InCounty = 1 THEN Origin = 1: 
										IF InState = 1 THEN State = 'Yes';

DATA CUSTOMERS;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Customer Data.csv" DSD DLM="," FIRSTOBS=2;
INPUT ID NAME : $15.	ADDRESS : $25. ;
DATA ORDERS;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Order Data.csv" DSD DLM="," FIRSTOBS=2;
INPUT ID PRICE;
PROC SORT DATA = ORDERS;
BY ID;
RUN;
DATA NOORDERS;
MERGE CUSTOMERS ORDERS (IN=RECENT);
BY ID;
IF RECENT = 0;
RUN;
PROC PRINT DATA = NOORDERS;
TITLE "CUSTOMERS WITH";
RUN;  *



L)	SELECTING OBSERVATION WITH THE WHERE= OPTION

	--->	THE WHERE= DATA SET OPTIONS IS THE MOST FLEXIBLE OF ALL WAYS TO SUBSET DATA. YOU CAN USE IT IN DATA STEP OR PROC STEP, WHEN YOU READ 
			EXISTING DATA SETS AND WHEN YOU WRITE A NEW DATA SETS. THE BASIC FORM OF A "WHERE=" DATA SET OPTION IS "WHERE=" (CONDITION).

						DATA gone: 
							SET animals (WHERE = (Status = 'Extinct')): 
						DATA uncommon (WHERE = (Status IN ('Endangered', 'Threatened'))): 
							SET animals:

	--->	THE FOLLOWING PROCEDURES WILL USE ONLY OBSERVATION THAT SATISFY THE "WHERE=" CONDITION;

PROC IMPORT "D:\Practice\SAS\Little SAS Book\Data\Local Zoo Maintains.csv"  
OUT= Animal (WHERE = (Class= 'Mammalia')) REPLACE;
PROC PRINT DATA = animals (WHERE = (Habitat='Riparian')); 
PROC EXPORT DATA = animals (WHERE = (Status='Threatened')) 
OUTFILE = 'D:\Practice\SAS\Little SAS Book\Wildlife.xls'; 


DATA MOUNTAINS (WHERE = (Height > 6000))
		AMERICAN (WHERE =(Continent CONTAINS ('America')));
INFILE "D:\Practice\SAS\Little SAS Book\Data\Mountains.csv" DSD DLM=',' FIRSTOBS=2;
INPUT MOUNTAIN : $12. CONTINENT : $15.	HEIGHT;
RUN;
PROC PRINT DATA = MOUNTAINS;
TITLE "MEMBERS OF THE SEVEN SUMMIT ABOVE 6000 METERS";
RUN;
PROC PRINT DATA = AMERICAN;
TITLE 'MEMBERS OF THE SEVEN SUMMIT IN THE AMERICA';
RUN;		*


M)	CHANGING OBSERVATION TO VARIABLES USING PROC TRANSPOSE

	--->	THE "TRANSPOSE" PROCEDURE TRANSPOSES SAS DATA SETS, TURNING OBSERVATION INTO VARIABLES OR VARIABLES INTO OBSERVATION. IN MOST CASES,
			TO CONVERT OBSERVATION INTO VARIABLES, YOU CAN USE FOLLOWING STATEMENTS:

					PROC TRANSPOSE DATA = old-data-set OUT = new-data-set: 
						BY variable-list:
						ID variable-list: 
						VAR variable-list: 

	--->	BY STATEMENT - YOU CAN USE THE "BY" STATEMENT IF YOU HAVE ANY GROUPING VARIABLES THAT YOU WANT TO KEEP AS VARIABLES. THESE VARIABLES
			ARE INCLUDED IN THE TRANSPOSED DATA SET, BUT THEY ARE NOT THEMSELVES TRANSPOSED. THE TRANSPOSED DATA SET WILL HAVE ONE OBSERVATION
			FOR EACH "BY" LEVEL PER VARIABLE TRANSPOSED. FOR EXAMPLE, IN THE FINGURE ABOVE, THE VARIABLE X IS THE "BY" VARIABLES. THE DATA SET MUST 
			BE SORTED BY THESE VARIABLES BEFORE TRANSPOSING.

	--->	ID STATEMENT - THE ID STATEMNT NAMES THE VARIABLE WHOSE FORMATTED VALUES WILL BECOME THE NEW VARIABLE NAMES. IF MORE THAN ONE VARIABLE
			IS LISTED, THEN THE VALUES OF ALL VARIABLES IN THE ID STATEMENT WILL BE CONCATENATED TO FORM THE NEW VARIABLE NAMES. THE "ID" VALUES
			MUST OCCUR ONLY ONCE IN THE DATA SET. OR IF A "BY" STATEMENT IS PRESENT, THEN THE VALUES MUST BE UNIQUE WITHIN "BY" GROUPS. IF TH FIRST
			"ID" VARIABLE IS NUMERIC, THEN THE NEW VARIABLE NAMES HAVE AN UNDERSCORE FOR A PERFIX(_1 OR _2 FOR EXAMPLE). IF YOU DO NOT USE AN "ID"
			STATEMENT, THEN THE NEW VARIABLE WILL BE NAMED COL1, COL2 AND SO ON. IN THE FIGURE ABOVE, THE VARIABLE "Y" IS THE "ID" VARIABLE. NOTICE
			HOW IT'S VALUES ARE THE NAMES OF THE NEW VARIBALES IN THE TRANSPOSED DATA SET.

	--->	VAR STATEMENT - THE VAR STATEMENT NAMES THE VARIABLES WHOSE VALUES YOU WANT TO TRANSPOSE. IN THE FIGURE ABOVE, THE VARIABLE Z IS THE 
			"VAR" VARIABLE. SAS CREATES A NEW VARIABLE, _NAME_, WHICH HAS A VALUES THE NAMES OF THE VARIABLES IN THE "VAR" STATEMENT. IF THERE IS
			THAN ONE "VAR" VARIABLE, THEN _NAME_ WILL HAVE MORE THAN ONE VALUE.;

DATA BASEBALL;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Minor League Baseball Teams.csv" DSD DLM="," FIRSTOBS=2;
INPUT TEAM $ PLAYER TYPE $ ENTRY;
RUN;
PROC SORT DATA = BASEBALL;
BY TEAM PLAYER;
PROC PRINT DATA = BASEBALL;
TITLE 'Baseball Data After Sorting and Before Transposing';
RUN;
PROC TRANSPOSE DATA = BASEBALL OUT = FLIPPED;
BY TEAM PLAYER;
ID TYPE;
VAR ENTRY;
PROC PRINT DATA = FLIPPED;
TITLE 'Baseball Data After Transposing';
RUN;		*


N)	USING SAS AUTOMATIC VARIABLES

	--->	IN ADDITION TO THE VARIABLES WE CARETE IN SAS DATA SET, SAS CREATES A FEW MORE CALLED AUTOMATIC VARIABLES. WE CAN ORDINARILY SEE THESE 
			VARIABLES BEACSUE THEY ARE TEMPORARY AND ARE NOT SAVED WITH YOUR DATA. BUT THEY ARE AVILABLE IN THE DATA STEP, AND YOU CAN USE THEM JUST
			LIKE YOU USE ANY VARIABLE THAT YOU CREATE YOURSELF.

	--->	_N_ and _ERROR_  -- THE _N_ and _ERROR_ VARIABLE ARE ALWYS VAILABLE TO YOU IN THE DATA STEP. _N_ INDICATES THE NUMBER OF TIMES SAS
			HAS LOOPED THROUGH THE DATA STEP. THIS IS NOT NECESSARILY EQUAL TO THE OBSERVATION NUMBER, SINCE A SIMPLE SUBETTING "IF" STATEMENT CAN
			CHANGE THE RELATIONSHIP BETWEEN OBSERVATION NUMBER AND THE NUMBER OF ITERATIONS OF THE DATA STEP. THE _ERROR_ VARIABLE HAS A VALUE OF
			1 IF THERE IS A DATA ERROR FOR THAT OBSERVATION AND 0 IF THRE ISN'T. THINGS THAT CAN CAUS DATA ERROR INCLUDES INVALID DATA, CONVERSION
			ERRORS, AND ILLEGAL ARGUMENTS IN FUNCTIONS.

	--->	FIRST.variable and LAST.variable  -	OTHER AUTOMATIC VARIABLES ARE AVAILABLE ONLY IN SPECIAL CIRCUMSTANCES. THE "FIRST.variables" AND
			LAST.variables AUTOMATIC VARIABLES ARE AVAILABLE WHEN YOU ARE USING A "BY" STATEMENT IN A DATA STEP. THE FIRST.variable WILL HAVE A
			VALUE OF 1 WHEN SAS IS PROCESSING AN OBSERVATION WITH FIRST OCCURRENCE OF A NEW VALUE FOR THAT VARIABLE AND A VALUE OF 0 FOR THE OTHER
			OBSERVATIONS. THE LAST.varibale WILL HAVE A VALUE OF 1 FOR AN OBSERVATION WITH THE LAST OCCURRENCE OF A VALUE  FOR THAT VARIABLE AND
			THE VALUE 0 FOR THE OTHER OBSERVATIONS.;

DATA WALKERS;
INFILE "D:\Practice\SAS\Little SAS Book\Data\Library Money Donation.csv" DSD DLM="," FIRSTOBS=2;
INPUT Entry	AgeGroup$	Time;
RUN;
PROC SORT DATA = WALKERS;
BY Time;
DATA ORDERED;
SET WALKERS;
PLACE = _N_;
PROC PRINT DATA = ORDERED;
TITLE 'RESULT OF WALK';
RUN;
PROC SORT DATA = ORDERED;
BY AgeGroup Time;
DATA WINNERS;
SET ORDERED;
BY AgeGroup;
IF FIRST.AgeGroup = 1;
PROC PRINT DATA = WINNERS;
TITLE "WINNER IN EACH AGE";
RUN;
