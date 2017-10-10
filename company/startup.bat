@echo on
rem SET MAIN_CLASS=vn.com.neo.wcg.Main   
SET MAIN_CLASS=vn.com.neo.wcg.Main   
SET APP_NAME='SQL Loader 1.0' 
TIME /T 
DATE /T 
SET LIB_PATH=.\
SET LIB_PATH=neo-loader-db-1.0.jar;%LIB_PATH% 
SET LIB_PATH=lib\*;%LIB_PATH% 
echo Using JRE in %JAVA% 
echo ClassPath=%LIB_PATH% 
start "SQL Loader" java -cp %LIB_PATH% %MAIN_CLASS%  
exit