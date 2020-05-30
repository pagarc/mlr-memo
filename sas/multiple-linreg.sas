/* Import CSV */
FILENAME REFFILE '/folders/myfolders/datasets/AnimeList.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=mal;
	GETNAMES=YES;
RUN;

/* Subset data to anime movies that have ranks and scores*/
DATA movieList;
   SET mal;
   IF type='Mo' AND score > 0 AND rank > 0;
; 

/* Obtain summary statistics */
PROC MEANS DATA=movieList N MIN MAX MEAN MEDIAN STD;
	VAR popularity;
	VAR rank;
	VAR members;
	VAR favorites;
	VAR score;
	TITLE 'Descriptive Statistics';
RUN;

/* Conduct multiple OLS regression */
PROC REG DATA = movieList;
	MODEL score = popularity rank members favorites
		/ TOL VIF; /* check VIF for multicollinearity */
	TITLE 'Multiple OLS Regression';
RUN;

/* Obtain Cohen's f^2 */
DATA effsz;
	TITLE 'Cohen''s f^2 Effect Size';
f = 0.6458 / (1-0.6458);
OUTPUT;
RUN;

PROC PRINT;
VAR f;
RUN;