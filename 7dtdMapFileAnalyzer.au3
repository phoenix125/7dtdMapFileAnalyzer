
#include <Date.au3>
#include <Process.au3>
#include <StringConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>

$aUtilName = "7dtdMapFileAnalyzer"
$aUtilVersion = "v1.0" ; (2019-02-26)

Global Const $aIniFile = @ScriptDir & "\" & $aUtilName & ".ini"
Global Const $aUtilityVer = $aUtilName & " " & $aUtilVersion
Global Const $aLogFile = @ScriptDir & "\" & $aUtilName & ".log"
Global $aN = 50
Global $aEx[$aN]
Global $aNPOI = $aN
Global $aPOI[$aN]

Local $i = 0
$aEx[$i] = "Traders,settlement_trader_05,settlement_trader_04,settlement_trader_03,settlement_trader_02,settlement_trader_01"
$i += 1
$aEx[$i] = "Pharmacies,store_pharmacy_sm_"
$i += 1
$aEx[$i] = "Gun Stores,store_gun_lg_01,store_gun_sm_01"
$i += 1
$aEx[$i] = "Book Stores,store_book_sm_01,store_book_lg_01"
$i += 1
$aEx[$i] = "Hardware Stores,store_hardware_sm_01,store_hardware_lg_01"
$i += 1
$aEx[$i] = "Grocery Stores,store_grocery_sm_01,store_grocery_lg_01"
$i += 1
$aEx[$i] = "Pawn Store,store_pawn_01"
$i += 1
$aEx[$i] = "Skyscrapers,skyscraper_04,skyscraper_03,skyscraper_02,skyscraper_01"
$i += 1
$aEx[$i] = "Hospitals,hospital_01"
$i += 1
$aEx[$i] = "Football Stadiums,football_stadium"
$i += 1
$aEx[$i] = "Gas Stations,gas_station"
$i += 1
$aEx[$i] = "Refineries,utility_refinery_01"
$i += 1
$aEx[$i] = "Factories,factory_lg_02,factory_lg_01"
$i += 1
$aEx[$i] = "Garage,garage_"
$i += 1
$aEx[$i] = "Fire Stations,fire_station_02,fire_station_01"
$i += 1
$aEx[$i] = "Caves,cave_05,cave_04,cave_03,cave_01"
$i += 1
$aEx[$i] = "Parking Lots,parking_lot_03,parking_lot_02,parking_lot_01,parking_garage_01"
$i += 1
$aEx[$i] = "Prison,prison_01"
$i += 1
$aEx[$i] = "Bomb Shelters,bombshelter_md_01,bombshelter_lg_01"
$i += 1
$aEx[$i] = "Water Works,utility_waterworks_01"
$i += 1
$aEx[$i] = "Electric Companies,utility_electric_co_01"
$i += 1
$aEx[$i] = "Churches,church_"
$i += 1
$aEx[$i] = "Schools,school_k6_01,school_daycare_01,school_01"
$i += 1
$aEx[$i] = "Ranger Stations,ranger_station1"
$i += 1
$aEx[$i] = "Cabins,cabin_"
$i += 1
$aEx[$i] = "Houses,house_"
$i += 1
$aEx[$i] = "Hotels,hotel_roadside_02,hotel_roadside_01,hotel_ostrich,hotel_new_01"
$i += 1
$aEx[$i] = "Funeral Homes,funeral_home_01"
For $x = $i to 49
	$aEx[$i] = ""
Next

FileWriteLine($aLogFile, _NowCalc() & " ============================ " & $aUtilName & " " & $aUtilVersion & " Started ============================")
SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Importing settings from " & $aIniFile & ".", 600, 125, -1, -1, $DLG_MOVEABLE, "")
ReadUini($aIniFile, $aLogFile)
SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Reading map file:" & @CRLF & $aSourceFile & ".", 600, 125, -1, -1, $DLG_MOVEABLE, "")
Local $aCount = ReadMapFile($aSourceFile, $aNPOI, $aPOI, $aSeedname, $aOutputFileName)
SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Writing map analysis files:" & @CRLF & $aOutputFileName & ".", 600, 125, -1, -1, $DLG_MOVEABLE, "")
_FileInUse($aOutputFileName & ".csv")
WriteMapCount($aOutputFileName, $aOutputFileAppend, $aNPOI, $aPOI, $aCount, $aSeedname, $aMapSize, $aLines)
SplashOff()
MsgBox($MB_OK, $aUtilityVer, "Process complete. Output files are: " & @CRLF & $aOutputFileName & ".csv" & @CRLF & $aOutputFileName & "_" & $aSeedname & ".txt" & @CRLF & @CRLF & "Thank you! Visit http://www.Phoenix125.com for more utilities.",15)
Exit


Func ReadUini($sIniFile, $sLogFile)
	FileWriteLine($aLogFile, _NowCalc() & " Reading INI...")
	Local $iIniError = ""
	Local $iIniFail = 0
	Local $iniCheck = ""
	Local $aChar[3]
	For $i = 1 To 13
		$aChar[0] = Chr(Random(97, 122, 1)) ;a-z
		$aChar[1] = Chr(Random(48, 57, 1)) ;0-9
		$iniCheck &= $aChar[Random(0, 1, 1)]
	Next
	Global $aSourceFile = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Source File", $iniCheck)
	Global $aOutputFileName = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Output Filename", $iniCheck)
	Global $aOutputFileAppend = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "(A)ppend or (O)verwrite File", $iniCheck)
	Global $aSeedname = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Seed Name", $iniCheck)
	Global $aMapSize = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Map Size", $iniCheck)
	If $iniCheck = $aSourceFile Then
		$aSourceFile = "prefabs.xml"
		$iIniFail += 1
		$iIniError = $iIniError & "Source File, "
	EndIf
	If $iniCheck = $aOutputFileName Then
		$aOutputFileName = "7dtdMapFileAnalyzer_map_info.csv"
		$iIniFail += 1
		$iIniError = $iIniError & "Output Filename, "
	EndIf
	If $iniCheck = $aOutputFileAppend Then
		$aOutputFileAppend = "O"
		$iIniFail += 1
		$iIniError = $iIniError & "Append or Overwrite, "
	EndIf
	If $iniCheck = $aSeedname Then
		$aSeedname = "123xyz"
		$iIniFail += 1
		$iIniError = $iIniError & "Seed Name, "
	EndIf
	If $iniCheck = $aMapSize Then
		$aMapSize = "8K"
		$iIniFail += 1
		$iIniError = $iIniError & "Map Size, "
	EndIf
For $i = 0 To 49
	$aPOI[$i] = IniRead($sIniFile, " --------------- POI TYPE AND SEARCH STRINGS --------------- ", "POI_" & $i, $iniCheck)
	If $iniCheck = $aPOI[$i] Then
		$aPOI[$i] = $aEx[$i]
		$iIniFail += 1
		$iIniError = $iIniError & "POI_"& $i& ", "
	EndIf
	If $aPOI[$i] = "" Then
		Global $aNPOI = $i + 1
		ExitLoop
	EndIf
Next
	If $iIniFail > 0 Then
		iniFileCheck($sIniFile, $iIniFail, $iIniError)
	EndIf

EndFunc

Func iniFileCheck($sIniFile, $iIniFail, $iIniError)
	If FileExists($sIniFile) Then
		Local $aMyDate, $aMyTime
		_DateTimeSplit(_NowCalc(), $aMyDate, $aMyTime)
		Local $iniDate = StringFormat("%04i.%02i.%02i.%02i%02i", $aMyDate[1], $aMyDate[2], $aMyDate[3], $aMyTime[1], $aMyTime[2])
		FileMove($sIniFile, $sIniFile & "_" & $iniDate & ".bak", 1)
		UpdateIni($sIniFile)
		FileWriteLine($aLogFile, _NowCalc() & " INI MISMATCH: Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini. Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		FileWriteLine($aLogFile, _NowCalc() & " INI MISMATCH: Parameters missing: " & $iIniError)
		SplashOff()
		MsgBox(4096, "INI MISMATCH", "INI FILE WAS UPDATED." & @CRLF & "Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini:" & @CRLF & @CRLF & $iIniError & @CRLF & @CRLF & "Backup created and all existing settings transfered to new INI." & @CRLF & @CRLF & "Please modify INI and restart.")
		Exit
	Else
		UpdateIni($sIniFile)
		SplashOff()
		MsgBox($MB_OK, $aUtilityVer, "Default INI File Created." & @CRLF & "Please Modify Default Values and Restart Program.")
		FileWriteLine($aLogFile, _NowCalc() & " Default INI File Created . . Please Modify Default Values and Restart Program.")
		Exit
	EndIf
EndFunc   ;==>iniFileCheck

Func UpdateIni($sIniFile)
	FileWriteLine($aLogFile, _NowCalc() & " Writing INI...")
	FileWriteLine($sIniFile, "[ --------------- " & StringUpper($aUtilName) & " INFORMATION --------------- ]")
	FileWriteLine($sIniFile, "Author   :  Phoenix125")
	FileWriteLine($sIniFile, "Version  :  " & $aUtilityVer)
	FileWriteLine($sIniFile, "Website  :  http://www.Phoenix125.com")
	FileWriteLine($sIniFile, "Discord  :  http://discord.gg/EU7pzPs")
	FileWriteLine($sIniFile, "Forum    :  https://phoenix125.createaforum.com/index.php")
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Source File", $aSourceFile)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Output Filename", $aOutputFileName)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "(A)ppend or (O)verwrite File", $aOutputFileAppend)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Seed Name", $aSeedname)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Map Size", $aMapSize)
	FileWriteLine($sIniFile, @CRLF)
	FileWriteLine($sIniFile, "[ ----------------------- BRIEF INSTRUCTIONS ----------------------- ]")
	FileWriteLine($sIniFile, "- Source file can contain folders. ex: D:\Users\Server\AppData\Roaming\7DaysToDie\GeneratedWorlds\Geyusa Mountains\prefabs.xml")
	FileWriteLine($sIniFile, "- Output filename can also contain folders. Otherwise, output files will be created in script DIR.")
	FileWriteLine($sIniFile, "- [Seed Name] and [Map Size] are for logfile entries only and have no effect on outcome.")
	FileWriteLine($sIniFile, "- (A)ppend will add data to the existing .csv file.")
	FileWriteLine($sIniFile, "- (O)verwrite will delete existing files and write new files.")
	FileWriteLine($sIniFile, @CRLF)
	FileWriteLine($sIniFile, "POI Type and Search Strings Section: Fully customizable up to 50 POI types.")
	FileWriteLine($sIniFile, "- Example: POI_1=[POI Type],[search string 1],[search string 2], etc. COMMA SEPARATED, NO SPACE.")
	FileWriteLine($sIniFile, "- [search strings] can be partial strings. Ex. [POI1=Caves,caves_] can be used instead of [POI1=Caves,cave_05,cave_04,cave_03,cave_01]")
	FileWriteLine($sIniFile, @CRLF)

For $i = 0 To ($aN - 1)
	IniWrite($sIniFile, " --------------- POI TYPE AND SEARCH STRINGS --------------- ", "POI_" & $i, $aPOI[$i])
Next

EndFunc   ;==>UpdateIni
#EndRegion ;**** INI Settings - User Variables ***

Func ReadMapFile($tFN,$tN,$tPOI,$tSeed,$tFO)
	FileWriteLine($aLogFile, _NowCalc() & " Reading Map File: " & $tFN & " ...")
	$tFileOutTxt = $tFO & "_" & $tSeed & ".txt"
	If Not FileExists($tFN) Then
		FileWriteLine($aLogFile, _NowCalc() & " ERROR! Could not find map file: " & $tFN)
		SplashOff()
		MsgBox($MB_OK, $aUtilityVer, "ERROR! Could not find map file: " & @CRLF & $tFN)
		Exit
	EndIf
	If FileExists($tFileOutTxt) Then
		FileDelete($tFileOutTxt)
	EndIf
	Global $aLineCount = _FileCountLines($tFN)
	Local $tReturn[$tN]
	Local $tMapPathOpen = FileOpen($tFN, 0)
	Local $tMapRead = FileRead($tMapPathOpen)
	Global $aLines = _FileCountLines($tMapRead)
	FileWriteLine($aLogFile, "[" & $aSeedname & "] ------------------------------------------------------------")
	For $i = 0 to ($tN - 2)
		Local $tCSV = StringSplit($tPOI[$i], ",")
		For $x = 2 to $tCSV[0]
			StringReplace($tMapRead, $tCSV[$x], $tCSV[$x])
			Local $iReplacements = @extended
			$tReturn[$i] = $tReturn[$i] + $iReplacements
			FileWriteLine($aLogFile, "[" & $aSeedname & "] POI Type - " & $tCSV[1] & " - " & $tCSV[$x] & " (" & $iReplacements & ")")
		Next
		FileWriteLine($aLogFile, "[" & $aSeedname & "] ------------------------------------------------------------ TOTAL " & $tCSV[1] & " (" & $tReturn[$i] & ")")
		FileWriteLine($tFileOutTxt, "[" & $aSeedname & "] TOTAL " & $tCSV[1] & " (" & $tReturn[$i] & ")")
	Next
	FileClose($tFN)
	FileWriteLine($aLogFile, "[" & $aSeedname & "] ------------------------------------------------------------ TOTAL LINES (" & $aLineCount & ")")
	FileWriteLine($tFileOutTxt, "--------------------------------------")
	FileWriteLine($tFileOutTxt, "[" & $aSeedname & "] TOTAL Lines (" & $aLineCount & ")")
	FileWriteLine($tFileOutTxt, "--------------------------------------")
	Return $tReturn
EndFunc

Func WriteMapCount($tOutputFileName, $tOutputFileAppend, $tNPOI, $tPOI, $tCount, $tSeed, $tMapSize, $tLines)
	Local $tFN = $tOutputFileName & ".csv"
	FileWriteLine($aLogFile, _NowCalc() & " Writing " & $tFN & " ...")
	If FileExists($tFN) Then
		Local $tFileExist = True
		If $tOutputFileAppend = "O" Then
				FileDelete($tFN)
		EndIf
		Else
		Local $tFileExist = False
	EndIf
	If Not $tFileExist Then
		$tLine = "SeedName,MapSize,Lines"
		For $i = 0 to ($tNPOI - 1)
			Local $tCSV = StringSplit($tPOI[$i], ",")
			$tLine = $tLine & "," & $tCSV[1]
		Next
		FileWriteLine($tFN, $tLine)
	EndIf
	$tLine = $tSeed & "," & $tMapSize & "," & $aLineCount
	For $i = 0 to ($tNPOI - 1)
		$tLine = $tLine & "," & $tCount[$i]
	Next
	FileWriteLine($tFN, $tLine)
EndFunc

Func _FileInUse($sFile)
    Local $hFile = _WinAPI_CreateFile($sFile, 2, 2, 0)
    If $hFile Then
        _WinAPI_CloseHandle($hFile)
        Return 0
    EndIf
    Local $Error = _WinAPI_GetLastError()
    Switch $Error
		Case 32 ; ERROR_SHARING_VIOLATION
			SplashOff()
			MsgBox($MB_OK, $aUtilityVer, "ERROR! Output file in use: " & @CRLF & $sFile & @CRLF & @CRLF & "Please close Office and rerun this application")
			Exit
    EndSwitch
EndFunc   ;==>_FileIsUses