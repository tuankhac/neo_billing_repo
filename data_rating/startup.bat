@echo on
rem SET MAIN_CLASS=net.schedule.AutoCall
SET MAIN_CLASS=net.schedule.AutoCall
SET APP_NAME='CDR DATA 1.0'
TIME /T
DATE /T
SET LIB_PATH=.\
SET LIB_PATH=neo_data_rating.jar;%LIB_PATH%
SET LIB_PATH=lib\*;%LIB_PATH%
echo Using JRE in %JAVA%
echo ClassPath=%LIB_PATH%
start "CDR Data" java -cp %LIB_PATH% %MAIN_CLASS%
exit