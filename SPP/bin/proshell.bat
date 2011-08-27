@REM ----------------------------------------------------------------------------
@REM Copyright 2001-2004 The Apache Software Foundation.
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM ----------------------------------------------------------------------------
@REM

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\repo

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\uk\org\taverna\scufl2\scufl2-api\0.1-SNAPSHOT\scufl2-api-0.1-SNAPSHOT.jar;"%REPO%"\uk\org\taverna\scufl2\scufl2-ucfpackage\0.1-SNAPSHOT\scufl2-ucfpackage-0.1-SNAPSHOT.jar;"%REPO%"\uk\org\taverna\scufl2\scufl2-rdfxml\0.1-SNAPSHOT\scufl2-rdfxml-0.1-SNAPSHOT.jar;"%REPO%"\uk\org\taverna\scufl2\scufl2-t2flow\0.1-SNAPSHOT\scufl2-t2flow-0.1-SNAPSHOT.jar;"%REPO%"\uk\co\magus\fourstore\4store-client\1.0\4store-client-1.0.jar;"%REPO%"\org\apache\xmlbeans\xmlbeans\2.4.0\xmlbeans-2.4.0.jar;"%REPO%"\stax\stax-api\1.0.1\stax-api-1.0.1.jar;"%REPO%"\commons-io\commons-io\2.0.1\commons-io-2.0.1.jar;"%REPO%"\net\sf\json-lib\json-lib\1.0\json-lib-1.0-jdk15.jar;"%REPO%"\commons-beanutils\commons-beanutils\1.7.0\commons-beanutils-1.7.0.jar;"%REPO%"\commons-lang\commons-lang\2.2\commons-lang-2.2.jar;"%REPO%"\commons-logging\commons-logging\1.1\commons-logging-1.1.jar;"%REPO%"\net\sf\ezmorph\ezmorph\1.0.1\ezmorph-1.0.1.jar;"%REPO%"\org\biocatalogue\biocatalogue_api_classes\1.0\biocatalogue_api_classes-1.0.jar;"%REPO%"\gnu\getopt\getopt\1.0\getopt-1.0.jar;"%REPO%"\uk\ac\manchester\cs\spanoude\semantic-provenance\0.0.1-SNAPSHOT\semantic-provenance-0.0.1-SNAPSHOT.jar
set EXTRA_JVM_ARGUMENTS=
goto endInit

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% %EXTRA_JVM_ARGUMENTS% -classpath %CLASSPATH_PREFIX%;%CLASSPATH% -Dapp.name="proshell" -Dapp.repo="%REPO%" -Dbasedir="%BASEDIR%" uk.ac.manchester.cs.spanoude.semanticprovenance.Provenance %CMD_LINE_ARGS%
if ERRORLEVEL 1 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=1

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal

:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
