@echo off
setlocal

REM --- BEGIN: SCRIPT SETTINGS AND DEFAULTS ---
REM API KEY:
set nrapikeydef=your_API_key_here
REM APPLICATION NAME:
set nrappnamedef=your_app_name_here
REM DEPLOYMENT MARKER USER:
set nruserdef=your_user_here
REM LOCATION OF CURL EXE:
REM NOTE: CURL can be downloaded here: http://www.confusedbycode.com/curl/#downloads
set curlloc=%CD%\curl-7.33.0-win32\bin
REM --- END: SCRIPT SETTINGS AND DEFAULTS ---

REM DO NOT CHANGE THIS UNLESS ADVISED!!!
set nrurl=https://rpm.newrelic.com/deployments.xml

echo.
echo New Relic Deployment Marker Script
echo.
echo NOTE: for optional fields (opt.), press Enter to leave blank.
echo.
set /p nrapikey= "What is the API key? [default: %nrapikeydef%] "
set /p nrappname= "What is the app name? [default: %nrappnamedef%] "
set /p nruser= "Who is the submitting user? [default: %nruserdef%] "
set /p nrrevision= "(opt.) What is the revision #?  [default: none] "
set /p nrdescription= "(opt.) What is the summary description? [default: none] "
set /p nrchangelog= "(opt.) What is the detailed description? [default: none] "

if "%nrapikey%" == "" set nrapikey=%nrapikeydef%
if "%nrappname%" == "" set nrappname=%nrappnamedef%
if "%nruser%" == "" set nruser=%nruserdef%
set curlstring=-H "x-api-key:%nrapikey%" -d "deployment[app_name]=%nrappname%" -d "deployment[user]=%nruser%"
if "%nrrevision%" NEQ "" set curlstring=%curlstring% -d "deployment[revision]=%nrrevision%"
if "%nrdescription%" NEQ "" set curlstring=%curlstring% -d "deployment[description]=%nrdescription%"
if "%nrchangelog%" NEQ "" set curlstring=%curlstring% -d "deployment[changelog]=%nrchangelog%"

set curlstring=%curlstring% %nrurl%

echo.
if exist "%curlloc%\curl.exe" (
	echo Executing: curl %curlstring%
	"%curlloc%\curl.exe" %curlstring%
) else (
	echo ERROR: curl.exe does not exist at %curlloc%
	echo Please set "curlloc" variable in %~n0%~x0 
	echo to the directory containing curl.exe.
)
echo.
echo Done!
endlocal