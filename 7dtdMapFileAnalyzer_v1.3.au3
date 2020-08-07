#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\phoenix_5Vq_icon.ico
#AutoIt3Wrapper_Outfile=Builds\7dtdMapFileAnalyzer_v1.3.exe
#AutoIt3Wrapper_Res_Comment=By Phoenix125 http://www.Phoenix125.com
#AutoIt3Wrapper_Res_Description=7 Days To Die Map Alanyzer Utility
#AutoIt3Wrapper_Res_Fileversion=1.3.0.0
#AutoIt3Wrapper_Res_ProductName=7dtdMapFileAnalyzer
#AutoIt3Wrapper_Res_ProductVersion=v1.3
#AutoIt3Wrapper_Res_CompanyName=http://www.Phoenix125.com
#AutoIt3Wrapper_Res_LegalCopyright=https://github.com/phoenix125/7dtdMapFileAnalyzer/blob/master/7dtdMapFileAnalyzer.zip
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Date.au3>
#include <Process.au3>
#include <StringConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>

#include <GuiConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>
#include <ListViewConstants.au3>

Global $aUtilName = "7dtdMapFileAnalyzer"
Global $aUtilVersion = "v1.3" ; (2020-08-06)

Global Const $aIniFile = @ScriptDir & "\" & $aUtilName & ".ini"
Global Const $aIniPOI = @ScriptDir & "\" & $aUtilName & "_POI.ini"
Global Const $aUtilityVer = $aUtilName & " " & $aUtilVersion
Global Const $aLogFile = @ScriptDir & "\" & $aUtilName & ".log"
Global $aServerUpdateLinkVer = "http://www.phoenix125.com/share/7dtdMapFileAnalyzer/7dtdmaplatestver.txt"
Global $aServerUpdateLinkDL = "http://www.phoenix125.com/share/7dtdMapFileAnalyzer/7dtdMapFileAnalyzer.zip"
Global $aUpdateUtiClick = False
Global $aN = 50
Global $aEx[$aN]
Global $aNPOI = $aN
Global $aPOI[$aN]
Global $aRestart = False

Opt("TrayMenuMode", 1)

Local $i = 0
$aEx[$i] = "Traders,trader_"
$i += 1
$aEx[$i] = "Pharmacies,store_pharmacy"
$i += 1
$aEx[$i] = "Gun Stores,store_gun"
$i += 1
$aEx[$i] = "Book Stores,store_book"
$i += 1
$aEx[$i] = "Hardware Stores,store_hardware"
$i += 1
$aEx[$i] = "Grocery Stores,store_grocery"
$i += 1
$aEx[$i] = "Pawn Store,store_pawn"
$i += 1
$aEx[$i] = "Skyscrapers,skyscraper_"
$i += 1
$aEx[$i] = "Hospitals,hospital_"
$i += 1
$aEx[$i] = "Football Stadiums,football_"
$i += 1
$aEx[$i] = "Gas Stations,gas_"
$i += 1
$aEx[$i] = "Refineries,utility_refinery"
$i += 1
$aEx[$i] = "Factories,factory_"
$i += 1
$aEx[$i] = "Garage,garage_"
$i += 1
$aEx[$i] = "Fire Stations,fire_station"
$i += 1
$aEx[$i] = "Caves,cave_"
$i += 1
$aEx[$i] = "Parking Lots,parking_lot"
$i += 1
$aEx[$i] = "Prison,prison_"
$i += 1
$aEx[$i] = "Bomb Shelters,bombshelter_"
$i += 1
$aEx[$i] = "Water Works,utility_waterworks"
$i += 1
$aEx[$i] = "Electric Companies,utility_electric"
$i += 1
$aEx[$i] = "Churches,church_"
$i += 1
$aEx[$i] = "Schools,school_"
$i += 1
$aEx[$i] = "Ranger Stations,ranger_station"
$i += 1
$aEx[$i] = "Cabins,cabin_"
$i += 1
$aEx[$i] = "Houses,house_"
$i += 1
$aEx[$i] = "Hotels,hotel_"
$i += 1
$aEx[$i] = "Funeral Homes,funeral_"
For $x = $i To 49
	$aEx[$i] = ""
Next

FileWriteLine($aLogFile, _NowCalc() & " ============================ " & $aUtilName & " " & $aUtilVersion & " Started ============================")
OnAutoItExitRegister("ShutdownProg")
ReadUini($aIniFile, $aLogFile)

If $aUpdateUtil = "yes" Then
	UtilUpdate($aServerUpdateLinkVer, $aServerUpdateLinkDL, $aUtilVersion, $aUtilName, $aUpdateUtiClick)
EndIf

SplashOff()
_MainGui()
Exit

Func RunScript()
	ReadUini($aIniFile, $aLogFile)
	If $aOutputAppendFileYN = "no" Then FileDelete($aOutputFolder & "\" & $aOutputFileNameCSV & ".csv")
	Local $tResult = _FileInUse($aOutputFolder & "\" & $aOutputFileNameCSV & ".csv")
	If $tResult Then Return
	SplashOff()
	If $aSourceFD = "F" Then
		;		SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Reading map file:" & @CRLF & $aSourceFile & ".", 600, 125, -1, -1, $DLG_MOVEABLE, "")
		;	Local $aCount = MakeMapFileTXT($aSourceFile, $aNPOI, $aPOI, $aSeedname, $aOutputFileNameTXT)
		Local $aCount = MakeMapFile($aSourceFile, $aSeedname, $aMapSize, $aNPOI, $aPOI, $aOutputFolder & "\" & $aOutputFileNameTXT, $aMapWorld)
		SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Writing map analysis files:" & @CRLF & $aOutputFileNameTXT & ".", 600, 125, -1, -1, $DLG_MOVEABLE, "")
		WriteMapCount($aOutputFolder & "\" & $aOutputFileNameCSV, $aOutputFileAppend, $aNPOI, $aPOI, $aCount, $aSeedname, $aMapSize, $aLines, $aMapWorld)
		SplashOff()
	Else
		GetFolderStructure($aSourceDir)
		For $i = 1 To $sCnt
			Local $aCount = MakeMapFile($aMapPreFab[$i], $aMapSeed[$i], $aMapSize[$i], $aNPOI, $aPOI, $aOutputFolder & "\" & $aOutputFileNameTXT, $aMapWorld[$i])
			WriteMapCount($aOutputFolder & "\" & $aOutputFileNameCSV, $aOutputFileAppend, $aNPOI, $aPOI, $aCount, $aMapSeed[$i], $aMapSize[$i], $aLines, $aMapWorld[$i])
		Next
		SplashOff()
	EndIf
	If $aOutputOpenWhenDoneYN = "yes" Then ShellExecute($aOutputFolder & "\" & $aOutputFileNameCSV & ".csv")
	MsgBox($MB_OK, $aUtilityVer, "Process complete. Output files are: " & @CRLF & $aOutputFileNameCSV & ".csv" & @CRLF & $aOutputFileNameTXT & "_" & $aSeedname & ".txt" & @CRLF & @CRLF & "Thank you! Visit http://www.Phoenix125.com for more utilities.", 15)
EndFunc   ;==>RunScript

Func ReadUini($sIniFile = $aIniFile, $sLogFile = $aLogFile)
	FileWriteLine($aLogFile, _NowCalc() & " Reading INI...")
	SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Importing settings from " & $aIniFile & ".", 600, 125, -1, -1, $DLG_MOVEABLE, "")
	Local $iIniError = ""
	Local $iIniFail = 0
	Local $iniCheck = ""
	Local $aChar[3]
	For $i = 1 To 13
		$aChar[0] = Chr(Random(97, 122, 1)) ;a-z
		$aChar[1] = Chr(Random(48, 57, 1)) ;0-9
		$iniCheck &= $aChar[Random(0, 1, 1)]
	Next
	Global $aSourceFD = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Use (F)ile or (D)irectory?", $iniCheck)
	Global $aSourceFile = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Source File", $iniCheck)
	Global $aSourceDir = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Source DIR", $iniCheck)
	Global $aOutputFileNameCSV = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Output XML Filename", $iniCheck)
	Global $aOutputFileNameTXT = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Output TXT Filename", $iniCheck)
	Global $aOutputFolder = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Output DIR", $iniCheck)
	Global $aOutputFileAppend = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "(A)ppend or (O)verwrite File", $iniCheck)
	Global $aSeedname = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Seed Name", $iniCheck)
	Global $aMapSize = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Map Size (Leave blank if using Directory)", $iniCheck)
	Global $aUpdateUtil = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Check for " & $aUtilName & " Updates? (yes/no)", $iniCheck)
	Global $aOutputAppendFileYN = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Append Data to Existing Output CSV File? (yes/no)", $iniCheck)
	Global $aOutputOpenWhenDoneYN = IniRead($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Open Output CSV file when done? (yes/no)", $iniCheck)
	If $iniCheck = $aSourceFD Then
		$aSourceFD = "D"
		$iIniFail += 1
		$iIniError = $iIniError & "Use File or Dir, "
	EndIf
	If $iniCheck = $aSourceFile Then
		$aSourceFile = @ScriptDir & "\prefabs.xml"
		$iIniFail += 1
		$iIniError = $iIniError & "Source File, "
	EndIf
	If $iniCheck = $aSourceDir Then
		$aSourceDir = @AppDataDir & "\7DaysToDie\GeneratedWorlds"
		$iIniFail += 1
		$iIniError = $iIniError & "Source Directory, "
	EndIf
	If $iniCheck = $aOutputFileNameCSV Then
		$aOutputFileNameCSV = "MapAnalysis"
		$iIniFail += 1
		$iIniError = $iIniError & "Output Filename, "
	EndIf
	If $iniCheck = $aOutputFileNameTXT Then
		$aOutputFileNameTXT = "MapAnalysis"
		$iIniFail += 1
		$iIniError = $iIniError & "Output Filename, "
	EndIf
	If $iniCheck = $aOutputFolder Then
		$aOutputFolder = @ScriptDir & "\Output"
		$iIniFail += 1
		$iIniError = $iIniError & "Output Filename, "
	EndIf
	If $iniCheck = $aOutputFileAppend Then
		$aOutputFileAppend = "A"
		$iIniFail += 1
		$iIniError = $iIniError & "Append or Overwrite, "
	EndIf
	If $iniCheck = $aSeedname Then
		$aSeedname = "Seed_Name"
		$iIniFail += 1
		$iIniError = $iIniError & "Seed Name, "
	EndIf
	If $iniCheck = $aMapSize Then
		$aMapSize = "8192"
		$iIniFail += 1
		$iIniError = $iIniError & "Map Size, "
	EndIf
	If $iniCheck = $aUpdateUtil Then
		$aUpdateUtil = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "Check for util updates, "
	EndIf
	If $iniCheck = $aOutputAppendFileYN Then
		$aOutputAppendFileYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "Append data to Output CSV, "
	EndIf
	If $iniCheck = $aOutputOpenWhenDoneYN Then
		$aOutputOpenWhenDoneYN = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "Open Output CSV file when done, "
	EndIf

	For $i = 0 To 49
		$aPOI[$i] = IniRead($aIniPOI, " --------------- POI TYPE AND SEARCH STRINGS --------------- ", "POI_" & $i, $iniCheck)
		If $iniCheck = $aPOI[$i] Then
			$aPOI[$i] = $aEx[$i]
			$iIniFail += 1
			$iIniError = $iIniError & "POI_" & $i & ", "
		EndIf
		If $aPOI[$i] = "" Then
			Global $aNPOI = $i + 1
			ExitLoop
		EndIf
	Next
	If $iIniFail > 0 Then
		iniFileCheck($sIniFile, $iIniFail, $iIniError)
	EndIf

EndFunc   ;==>ReadUini

Func iniFileCheck($sIniFile, $iIniFail, $iIniError)
	If FileExists($sIniFile) Then
		FileDelete($sIniFile)
		If FileExists($aIniPOI) Then
			FileDelete($aIniPOI)
		EndIf
		UpdateIni($sIniFile)
		FileWriteLine($aLogFile, _NowCalc() & " INI MISMATCH: Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini. Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		FileWriteLine($aLogFile, _NowCalc() & " INI MISMATCH: Parameters missing: " & $iIniError)
		SplashOff()
	Else
		UpdateIni($sIniFile)
		FileWriteLine($aLogFile, _NowCalc() & " Default INI File Created . . Please Modify Default Values and Restart Program.")
	EndIf
EndFunc   ;==>iniFileCheck

Func UpdateIni($sIniFile)
	If FileExists($sIniFile) Then
		FileDelete($sIniFile)
	EndIf
	If FileExists($aIniPOI) Then
		FileDelete($aIniPOI)
	EndIf
	FileWriteLine($aLogFile, _NowCalc() & " Writing INI...")
	FileWriteLine($sIniFile, "[ --------------- " & StringUpper($aUtilName) & " INFORMATION --------------- ]")
	FileWriteLine($sIniFile, "Author   :  Phoenix125")
	FileWriteLine($sIniFile, "Version  :  " & $aUtilityVer)
	FileWriteLine($sIniFile, "Website  :  http://www.Phoenix125.com")
	FileWriteLine($sIniFile, "Discord  :  http://discord.gg/EU7pzPs")
	FileWriteLine($sIniFile, "Forum    :  https://phoenix125.createaforum.com/index.php")
	FileWriteLine($sIniFile, @CRLF)

	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Use (F)ile or (D)irectory?", $aSourceFD)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Source File", $aSourceFile)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Source DIR", $aSourceDir)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Output XML Filename", $aOutputFileNameCSV)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Output TXT Filename", $aOutputFileNameTXT)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Output DIR", $aOutputFolder)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "(A)ppend or (O)verwrite File", $aOutputFileAppend)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Seed Name", $aSeedname)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Map Size (Leave blank if using Directory)", $aMapSize)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Check for " & $aUtilName & " Updates? (yes/no)", $aUpdateUtil)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Append Data to Existing Output CSV File? (yes/no)", $aOutputAppendFileYN)
	IniWrite($sIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Open Output CSV file when done? (yes/no)", $aOutputOpenWhenDoneYN)

	FileWriteLine($aIniPOI, "[ ----------------------- BRIEF INSTRUCTIONS ----------------------- ]")
	;	FileWriteLine($sIniFile, "- Source file can contain folders. ex: D:\Users\Server\AppData\Roaming\7DaysToDie\GeneratedWorlds\Geyusa Mountains\prefabs.xml")
	;	FileWriteLine($sIniFile, "- Output filename can also contain folders. Otherwise, output files will be created in script DIR.")
	;	FileWriteLine($sIniFile, "- [Seed Name] and [Map Size] are for logfile entries only and have no effect on outcome.")
	;	FileWriteLine($sIniFile, "- (A)ppend will add data to the existing .csv file.")
	;	FileWriteLine($sIniFile, "- (O)verwrite will delete existing files and write new files.")
	;	FileWriteLine($sIniFile, @CRLF)
	FileWriteLine($aIniPOI, "POI Type and Search Strings Section: Fully customizable up to 50 POI types.")
	FileWriteLine($aIniPOI, " Example: POI_1=[POI Type],[search string 1],[search string 2], etc. COMMA SEPARATED, NO SPACE.")
	FileWriteLine($aIniPOI, " * [search strings] can be partial strings:")
	FileWriteLine($aIniPOI, "   [POI_1=Caves,caves_] can be used instead of [POI_1=Caves,cave_05,cave_04,cave_03,cave_01]")
	FileWriteLine($aIniPOI, @CRLF)
	For $i = 0 To ($aN - 1)
		IniWrite($aIniPOI, " --------------- POI TYPE AND SEARCH STRINGS --------------- ", "POI_" & $i, $aPOI[$i])
	Next

EndFunc   ;==>UpdateIni
#EndRegion ;**** INI Settings - User Variables ***

Func WriteMapCount($tOutputFileNameCSV, $tOutputFileAppend, $tNPOI, $tPOI, $tCount, $tSeed, $tMapSize, $tLines, $tWorldName)
	Local $tFN = $tOutputFileNameCSV & ".csv"
	FileWriteLine($aLogFile, _NowCalc() & " Writing " & $tFN & " ...")
	If $tOutputFileAppend = "O" Then
		If FileExists($tFN) Then
			FileDelete($tFN)
		EndIf
	EndIf
	If Not FileExists($tFN) Then
		$tLine = "WorldGenSeed,SeedName,MapSize,Lines"
		For $i = 0 To ($tNPOI - 1)
			Local $tCSV = StringSplit($tPOI[$i], ",")
			$tLine = $tLine & "," & $tCSV[1]
		Next
		FileWriteLine($tFN, $tLine)
	EndIf
	$tLine = $tWorldName & "," & $tSeed & "," & $tMapSize & "," & $aLineCount
	For $i = 0 To ($tNPOI - 1)
		$tLine = $tLine & "," & $tCount[$i]
	Next
	FileWriteLine($tFN, $tLine)
EndFunc   ;==>WriteMapCount

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
			MsgBox($MB_OK, $aUtilityVer, "ERROR! Output file in use: " & @CRLF & $sFile & @CRLF & @CRLF & "Please close Office and try again.")
			Return True
;~ 			_RestartProgram()
	EndSwitch
	Return False
EndFunc   ;==>_FileInUse

Func _MainGui()
	Global $iW = 750, $iH = 500, $iT = 52, $iB = 52, $iLeftWidth = 100, $iGap = 10, $hMainGUI
	Local $hFooter, $nMsg, $aPos
	Local $iLinks = 5
	Local $sMainGuiTitle = $aUtilName
	Local $sHeader = "7 Days to Die Map File Analyzer"
	Local $sFooter = "http://www.Phoenix125.com | " & $aUtilityVer
	Local $aLink[$iLinks], $aPanel[$iLinks]
	$aLink[0] = $iLinks - 1
	$aPanel[0] = $iLinks - 1
	$hMainGUI = GUICreate($sMainGuiTitle, $iW, $iH, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_TABSTOP))
	GUISetIcon("iphoenix.ico", -58, $hMainGUI)

	GUICtrlCreateLabel($sHeader, 48, 8, $iW - 56, 32, $SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 14, 800, 0, "Arial", 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	GUICtrlCreateIcon("iphoenix.ico", -131, 8, 8, 32, 32)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("", 0, $iT, $iW, 2, $SS_SUNKEN) ;separator
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("", $iLeftWidth, $iT + 2, 2, $iH - $iT - $iB - 2, $SS_SUNKEN) ;separator
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
	GUICtrlCreateLabel("", 0, $iH - $iB, $iW, 2, $SS_SUNKEN) ;separator
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

	$hFooter = GUICtrlCreateLabel($sFooter, 10, $iH - 34, $iW - 20, 17, BitOR($SS_LEFT, $SS_CENTERIMAGE))
	GUICtrlSetTip(-1, "Phoenix125.com", "Click to open...")
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)

	;add links to the left side
	$aLink[1] = _AddNewLink("Main", -145)
	$aLink[2] = _AddNewLink("POI Config", -217)
	$aLink[3] = _AddNewLink("Instructions", -222)
	$aLink[4] = _AddNewLink("About", -278)
	;and the corresponding GUI's
	$aPanel[1] = _AddNewPanel("Source")
	$aPanel[2] = _AddNewPanel("POI Config")
	$aPanel[3] = _AddNewPanel("Instructions")
	$aPanel[4] = _AddNewPanel("About")

	;	_AddControlsToPanel($aPanel[1])
	GUISwitch($aPanel[1])
	Local $aChkBox[3]
	$aDown = 35
	$aCol1 = 8
	$aCol2 = $aCol1 + 52
	$aColMid = $aCol2 + 202
	$aCol3 = $aCol2 + 392
	$aBoxWidth = $aCol3 - $aCol2 - 10
	$aChkBox[1] = GUICtrlCreateRadio("File", $aCol1, $aDown + 3, 50, 17)
	Local $sSourceFile = GUICtrlCreateInput($aSourceFile, $aCol2, $aDown, $aBoxWidth, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sSourceFilClick = GUICtrlCreateButton("Select File", $aCol3, $aDown - 2, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	$aDown = $aDown + 30
	GUICtrlCreateLabel("Seed Name", $aCol2, $aDown + 3, 60, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sSeedname = GUICtrlCreateInput($aSeedname, $aCol2 + 60, $aDown, 125, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("Map Size", $aColMid, $aDown + 3, 45, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sMapSize = GUICtrlCreateInput($aMapSize, $aColMid + 55, $aDown, 125, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)


	$aDown = $aDown + 30
	$aChkBox[2] = GUICtrlCreateRadio("Folder", $aCol1, $aDown + 3, 50, 17)
	Local $sSourceDir = GUICtrlCreateInput($aSourceDir, $aCol2, $aDown, $aBoxWidth, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sSourceDiClick = GUICtrlCreateButton("Select Folder", $aCol3, $aDown - 2, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If $aSourceFD = "F" Then
		GUICtrlSetState($aChkBox[1], $GUI_CHECKED)
		GUICtrlSetState($sSourceDir, $GUI_DISABLE)
		GUICtrlSetState($sSourceFile, $GUI_ENABLE)
		GUICtrlSetState($sSeedname, $GUI_ENABLE)
		GUICtrlSetState($sMapSize, $GUI_ENABLE)
	Else
		GUICtrlSetState($aChkBox[2], $GUI_CHECKED)
		GUICtrlSetState($sSourceDir, $GUI_ENABLE)
		GUICtrlSetState($sSourceFile, $GUI_DISABLE)
		GUICtrlSetState($sSeedname, $GUI_DISABLE)
		GUICtrlSetState($sMapSize, $GUI_DISABLE)
	EndIf


	; --------- OUTPUT ----------

	$aDown = $aDown + 35
	GUICtrlCreateLabel("Output", $aCol1 + 2, $aDown, $iW - $iLeftWidth - 20, 17, $SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 9, 800, 4, "Arial", 5)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	$aDown = $aDown + 30
	GUICtrlCreateLabel("Folder", $aCol1, $aDown + 3, 45, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sOutputFolder = GUICtrlCreateInput($aOutputFolder, $aCol2, $aDown, $aBoxWidth, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sOutputFoldeClick = GUICtrlCreateButton("Select Folder", $aCol3, $aDown - 2, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	$aDown = $aDown + 30
	GUICtrlCreateLabel("CSV File", $aCol1, $aDown + 3, 60, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sOutputFileNameCSV = GUICtrlCreateInput($aOutputFileNameCSV, $aCol2, $aDown, 125, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel(".csv", $aCol2 + 130, $aDown + 3, 20, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("TXT File", $aColMid - 32, $aDown + 3, 45, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sOutputFileNameTXT = GUICtrlCreateInput($aOutputFileNameTXT, $aColMid + 15, $aDown, 165, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("_Seed_Name.txt", $aCol3, $aDown + 3, 80, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	$aDown = $aDown + 30
	Local $sOutputDeleteFileN = GUICtrlCreateRadio("Append Data to Existing Output CSV File", $aCol2, $aDown, 300, 21) ;kim125
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$aDown = $aDown + 25
	Local $sOutputDeleteFileY = GUICtrlCreateRadio("Delete existing Output CSV file and create new", $aCol2, $aDown, 300, 21) ;kim125
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	$aDown = $aDown + 35
	Local $sOutputOpenWhenDoneYN = GUICtrlCreateCheckbox("Open Output CSV file when done", $aCol2, $aDown, 300, 21) ;kim125
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	$aDown = $aDown + 75
	Local $sRunSave1 = GUICtrlCreateButton("Save", $aCol2, $aDown - 2, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sRunScript = GUICtrlCreateButton("START", $aCol3, $aDown - 2, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlSetBkColor(-1, 0xFFFA500)

	; ------------------------- Config -------------------------

	;	_AddControlsToPanel($aPanel[2])
	GUISwitch($aPanel[2])
	Local $hFileOpen = FileOpen($aIniPOI, 0)
	Local $sTextINI = FileRead($hFileOpen)
	FileClose($hFileOpen)

	Local $sRunSave2 = GUICtrlCreateButton("Save", 8, 30, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $sRunReset = GUICtrlCreateButton("Reset All", 93, 30, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$tTextIni = GUICtrlCreateEdit($sTextINI, 5, 60, $iW - $iLeftWidth + 2 - 20 - 5, $iH - $iT - $iB - 60, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL), $WS_EX_STATICEDGE)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

	; ------------------------- Instructions -------------------------

	;	_AddControlsToPanel($aPanel[3])
	GUISwitch($aPanel[3])
	Local $hFileOpen = FileOpen(@ScriptDir & "\readme.txt", 0)
	Local $sTextReadme = FileRead($hFileOpen)
	FileClose($hFileOpen)
	Local $sTextStart = "----- INSTRUCTIONS -----"
	Local $sTextEnd = "----- DOWNLOAD LINKS -----"
	$tTextReadme = _ArrayToString(_StringBetween($sTextReadme, $sTextStart, $sTextEnd))
	GUICtrlCreateEdit($tTextReadme, 10, 37, $iW - $iLeftWidth + 2 - 20 - 5, $iH - $iT - $iB - 40, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL, $ES_READONLY), $WS_EX_STATICEDGE)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

	; ------------------------- About -------------------------

	;	_AddControlsToPanel($aPanel[4])
	GUISwitch($aPanel[4])
	Local $hFileOpen = FileOpen(@ScriptDir & "\readme.txt", 0)
	Local $sTextReadme = FileRead($hFileOpen)
	FileClose($hFileOpen)

	Local $sUpdateCheck = GUICtrlCreateButton("Check for Update", 8, 30, 100, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateEdit($sTextReadme, 5, 60, $iW - $iLeftWidth + 2 - 20 - 5, $iH - $iT - $iB - 60, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL, $ES_READONLY), $WS_EX_STATICEDGE)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

	; ------------------------- SYSTEM TRAY ICON -------------------------

	$cTrayExit = TrayCreateItem("Exit")

	; ------------------------- MAIN MENU -------------------------

	;set default to Panel1
	GUISwitch($aPanel[1])
	If $aOutputAppendFileYN = "yes" Then
		GUICtrlSetState($sOutputDeleteFileN, $GUI_CHECKED)
	Else
		GUICtrlSetState($sOutputDeleteFileY, $GUI_CHECKED)
	EndIf
	If $aOutputOpenWhenDoneYN = "yes" Then
		GUICtrlSetState($sOutputOpenWhenDoneYN, $GUI_CHECKED)
	Else
		GUICtrlSetState($sOutputOpenWhenDoneYN, $GUI_UNCHECKED)
	EndIf

	;show the main GUI
	GUISetState(@SW_SHOW, $hMainGUI)

	While 1
		Sleep(10)
		$nMsg = GUIGetMsg(1)
		Switch $nMsg[1]
			Case $hMainGUI
				Switch $nMsg[0]
					Case $GUI_EVENT_CLOSE
						Exit
					Case $GUI_EVENT_MINIMIZE, $GUI_EVENT_MAXIMIZE, $GUI_EVENT_RESTORE
						$aPos = WinGetPos($hMainGUI)
						$iW = $aPos[2]
						$iH = $aPos[3]
						For $i = 0 To $aPanel[0]
							WinMove($aPanel[$i], "", $iLeftWidth + 2, $iT, $iW - $iLeftWidth + 2, $iH - $iT - $iB - 20)
						Next
					Case $aLink[1], $aLink[2], $aLink[3], $aLink[4]
						For $i = 1 To $aLink[0]
							If $nMsg[0] = $aLink[$i] Then
								GUISetState(@SW_SHOW, $aPanel[$i])
							Else
								GUISetState(@SW_HIDE, $aPanel[$i])
							EndIf
						Next
					Case $hFooter
						ShellExecute("https://github.com/phoenix125/7dtdMapFileAnalyzer")
				EndSwitch
			Case $aPanel[1]
				Switch $nMsg[0]
					Case $aChkBox[1], $aChkBox[2]
						If GUICtrlRead($aChkBox[1]) = $GUI_CHECKED Then
							GUICtrlSetState($sSourceDir, $GUI_DISABLE)
							GUICtrlSetState($sSourceFile, $GUI_ENABLE)
							GUICtrlSetState($sSeedname, $GUI_ENABLE)
							GUICtrlSetState($sMapSize, $GUI_ENABLE)
						EndIf
						If GUICtrlRead($aChkBox[2]) = $GUI_CHECKED Then
							GUICtrlSetState($sSourceDir, $GUI_ENABLE)
							GUICtrlSetState($sSourceFile, $GUI_DISABLE)
							GUICtrlSetState($sSeedname, $GUI_DISABLE)
							GUICtrlSetState($sMapSize, $GUI_DISABLE)
						EndIf
					Case $sSourceFilClick
						Local $tSourceFile = FileOpenDialog("Please select source file", $aSourceFile, "XML File (*.xml)", 3, "prefabs.xml")
						If @error Then
							GUICtrlSetData($sSourceFile, $aSourceFile)
						Else
							GUICtrlSetData($sSourceFile, $tSourceFile)
						EndIf
					Case $sSourceDiClick
						Local $tSourceDIR = FileSelectFolder("Please select source folder. ex) GeneratedWorlds", $aSourceDir)
						If @error Then
							GUICtrlSetData($sSourceDir, $aSourceDir)
						Else
							GUICtrlSetData($sSourceDir, $tSourceDIR)
						EndIf
					Case $sOutputFoldeClick
						Local $tOutputFolder = FileSelectFolder("Please select output folder", $aOutputFolder)
						If @error Then
							GUICtrlSetData($sOutputFolder, $aOutputFolder)
						Else
							GUICtrlSetData($sOutputFolder, $tOutputFolder)
						EndIf
					Case $sRunSave1
						SplashTextOn($aUtilName, " Saving settings . . .", 200, 50, -1, -1, $DLG_MOVEABLE, "")
						If GUICtrlRead($aChkBox[1]) = 1 Then
							$aSourceFD = "F"
						Else
							$aSourceFD = "D"
						EndIf
						$aSourceFile = GUICtrlRead($sSourceFile)
						$aSourceDir = GUICtrlRead($sSourceDir)
						$aOutputFolder = GUICtrlRead($sOutputFolder)
						$aSeedname = GUICtrlRead($sSeedname)
						$aMapSize = GUICtrlRead($sMapSize)
						$aOutputFileNameCSV = GUICtrlRead($sOutputFileNameCSV)
						$aOutputFileNameTXT = GUICtrlRead($sOutputFileNameTXT)
						UpdateIni($aIniFile)
						SplashTextOn($aUtilName, " Settings saved.", 200, 50, -1, -1, $DLG_MOVEABLE, "")
						Sleep(1000)
						SplashOff()
					Case $sOutputDeleteFileN
						$aOutputAppendFileYN = "yes"
						IniWrite($aIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Append Data to Existing Output CSV File? (yes/no)", $aOutputAppendFileYN)
					Case $sOutputDeleteFileY
						$aOutputAppendFileYN = "no"
						IniWrite($aIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Append Data to Existing Output CSV File? (yes/no)", $aOutputAppendFileYN)
					Case $sOutputOpenWhenDoneYN
						If GUICtrlRead($sOutputOpenWhenDoneYN) = 1 Then
							$aOutputOpenWhenDoneYN = "yes"
						Else
							$aOutputOpenWhenDoneYN = "no"
							IniWrite($aIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Open Output CSV file when done? (yes/no)", $aOutputOpenWhenDoneYN)
						EndIf
					Case $sRunScript
						SplashTextOn($aUtilName, " Saving settings . . .", 200, 50, -1, -1, $DLG_MOVEABLE, "")
						If GUICtrlRead($aChkBox[1]) = 1 Then
							$aSourceFD = "F"
						Else
							$aSourceFD = "D"
						EndIf
						$aSourceFile = GUICtrlRead($sSourceFile)
						$aSourceDir = GUICtrlRead($sSourceDir)
						$aOutputFolder = GUICtrlRead($sOutputFolder)
						$aSeedname = GUICtrlRead($sSeedname)
						$aMapSize = GUICtrlRead($sMapSize)
						$aOutputFileNameCSV = GUICtrlRead($sOutputFileNameCSV)
						$aOutputFileNameTXT = GUICtrlRead($sOutputFileNameTXT)
						UpdateIni($aIniFile)
						SplashOff()
						RunScript()
				EndSwitch
			Case $aPanel[2]
				Switch $nMsg[0]
					Case $sRunSave2
						$xTextIni = GUICtrlRead($tTextIni)
						If FileExists($aIniPOI) Then
							FileDelete($aIniPOI)
						EndIf
						FileWrite($aIniPOI, $xTextIni)
						SplashTextOn($aUtilName, " Settings saved.", 200, 50, -1, -1, $DLG_MOVEABLE, "")
						Sleep(1000)
						SplashOff()
					Case $sRunReset
						If FileExists($aIniFile) Then
							FileDelete($aIniFile)
						EndIf
						_RestartProgram()
						ReadUini()
						SplashTextOn($aUtilName, " Settings reset.", 200, 50, -1, -1, $DLG_MOVEABLE, "")
						Sleep(1000)
						SplashOff()
				EndSwitch
			Case $aPanel[4]
				Switch $nMsg[0]
					Case $sUpdateCheck
						UtilUpdate($aServerUpdateLinkVer, $aServerUpdateLinkDL, $aUtilVersion, $aUtilName, True)
				EndSwitch
		EndSwitch
		Switch TrayGetMsg()
			Case $cTrayExit
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>_MainGui

Func _AddNewLink($sTxt, $iIcon = -44)
	Local $hLink = GUICtrlCreateLabel($sTxt, 36, $iT + $iGap, $iLeftWidth - 46, 17)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateIcon("shell32.dll", $iIcon, 10, $iT + $iGap, 16, 16)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$iGap += 22
	Return $hLink
EndFunc   ;==>_AddNewLink

Func _AddNewPanel($sTxt)
	Local $gui = GUICreate("", $iW - $iLeftWidth + 2, $iH - $iT - $iB, $iLeftWidth + 2, $iT, $WS_CHILD + $WS_VISIBLE, -1, $hMainGUI)
	GUICtrlCreateLabel($sTxt, 10, 10, $iW - $iLeftWidth - 20, 17, $SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 9, 800, 4, "Arial", 5)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Return $gui
EndFunc   ;==>_AddNewPanel

Func _AddControlsToPanel($hPanel)
	GUISwitch($hPanel)
EndFunc   ;==>_AddControlsToPanel

#Region --- Restart Program ---
Func _RestartProgram() ; Thanks UP_NORTH
	$aRestart = True
	If @Compiled = 1 Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc   ;==>_RestartProgram
#EndRegion --- Restart Program ---

Func ShutdownProg()
	SplashOff()
	If Not $aRestart Then
		MsgBox($MB_OK, $aUtilityVer, "Thank you! Visit http://www.Phoenix125.com for more utilities.", 15)
	EndIf

	Exit
EndFunc   ;==>ShutdownProg

Func MakeMapFile($tFN, $tSeed, $tMapSize, $tN, $tPOI, $tFO, $tWorldName)
	FileWriteLine($aLogFile, _NowCalc() & " Reading File: " & $tFN)
	SplashTextOn($aUtilName, "Reading file:" & @CRLF & $tFN, 600, 125, -1, -1, $DLG_MOVEABLE, "")
	$tSeedNoSpace = ReplaceSpace($tSeed)
	$tFileOutTxt = $tFO & "_" & $tSeedNoSpace & ".txt"
	If Not FileExists($tFN) Then
		FileWriteLine($aLogFile, _NowCalc() & " ERROR! Could not find map file: " & $tFN)
		SplashOff()
		MsgBox($MB_OK, $aUtilityVer, "ERROR! Could not find map file: " & @CRLF & $tFN)
	EndIf
	If FileExists($tFileOutTxt) Then
		FileDelete($tFileOutTxt)
	EndIf
	Global $aLineCount = _FileCountLines($tFN)
	Local $tReturn[$tN]
	Local $tMapPathOpen = FileOpen($tFN, 0)
	Local $tMapRead = FileRead($tMapPathOpen)
	Global $aLines = _FileCountLines($tMapRead)
	FileWriteLine($aLogFile, "[" & $tWorldName & "] ------------------------------------------------------------")
	For $i = 0 To ($tN - 2)
		Local $tCSV = StringSplit($tPOI[$i], ",")
		For $x = 2 To $tCSV[0]
			StringReplace($tMapRead, $tCSV[$x], $tCSV[$x])
			Local $iReplacements = @extended
			$tReturn[$i] = $tReturn[$i] + $iReplacements
			FileWriteLine($aLogFile, "[" & $tWorldName & "] POI Type - " & $tCSV[1] & " - " & $tCSV[$x] & " (" & $iReplacements & ")")
		Next
		FileWriteLine($aLogFile, "[" & $tWorldName & "] ------------------------------------------------------------ TOTAL " & $tCSV[1] & " (" & $tReturn[$i] & ")")
		FileWriteLine($tFileOutTxt, "[" & $tWorldName & "] TOTAL " & $tCSV[1] & " (" & $tReturn[$i] & ")")
	Next
	FileClose($tFN)
	FileWriteLine($aLogFile, "[" & $tWorldName & "] ------------------------------------------------------------ TOTAL LINES (" & $aLineCount & ")")
	FileWriteLine($tFileOutTxt, "--------------------------------------------------")
	FileWriteLine($tFileOutTxt, "     World Gen Seed: (" & $tWorldName & ")")
	FileWriteLine($tFileOutTxt, " 		  World Name: (" & $tSeed & ")")
	FileWriteLine($tFileOutTxt, "           Map Size: (" & $tMapSize & ")")
	FileWriteLine($tFileOutTxt, "        TOTAL Lines: (" & $aLineCount & ")")
	FileWriteLine($tFileOutTxt, "--------------------------------------------------")
	Return $tReturn
EndFunc   ;==>MakeMapFile

Func GetFolderStructure($sSourceDir)
	$sSourceDir = AddTrailingSlash($sSourceDir)
	Local $sFiles = _FileListToArrayRec($sSourceDir, "*prefabs.xml;map_info.xml;GenerationInfo.txt||", $FLTAR_FILES + $FLTAR_NOSYSTEM + $FLTAR_NOHIDDEN, $FLTAR_RECUR, $FLTAR_FASTSORT, $FLTAR_FULLPATH)
	If @error Then
		SplashOff()
		MsgBox($MB_OK, $aUtilityVer, "ERROR! Could not find files in folder: " & @CRLF & $sSourceDir & @CRLF & "Please check the folder." & @CRLF & @CRLF & "Click OK to restart program.")
		_RestartProgram()
	EndIf

	Global $sCnt = ($sFiles[0] / 3)
	Local $sPrefab[$sCnt + 1]
	Global $aMapSize[$sCnt + 1]
	Global $aMapSeed[$sCnt + 1]
	Global $aMapPreFab[$sCnt + 1]
	Global $aMapWorld[$sCnt + 1]
	For $i = 1 To $sCnt
		SplashTextOn($aUtilName, "Reading file:" & @CRLF & $sFiles[($i * 3) - 1], 600, 125, -1, -1, $DLG_MOVEABLE, "")
		$aMapSize[$i] = GetSize($sFiles[($i * 3) - 1])
		$aMapSeed[$i] = GetSeed($sFiles[($i * 3) - 1], $sSourceDir)
		$aMapWorld[$i] = GetWorld($sFiles[($i * 3) - 2])
		SplashTextOn($aUtilName, "Reading file:" & @CRLF & $sFiles[$i * 3], 600, 125, -1, -1, $DLG_MOVEABLE, "")
		$aMapPreFab[$i] = $sFiles[$i * 3]
	Next
EndFunc   ;==>GetFolderStructure

Func GetSize($tFN)
	If Not FileExists($tFN) Then
		FileWriteLine($aLogFile, _NowCalc() & " ERROR! Could not find file: " & $tFN)
		SplashOff()
		MsgBox($MB_OK, $aUtilityVer, "ERROR! Could not find file: " & @CRLF & $tFN)
	EndIf
	Local $tMapPathOpen = FileOpen($tFN, 0)
	Local $tMapRead = FileRead($tMapPathOpen)
	FileClose($tFN)
	Local $tSize = _ArrayToString(_StringBetween($tMapRead, """HeightMapSize"" value=""", """ />"))
	Local $tStr = StringSplit($tSize, ",")
	Return $tStr[1]
EndFunc   ;==>GetSize

Func GetSeed($tFN, $tSRC)
	Return _ArrayToString(_StringBetween($tFN, $tSRC, "\"))
EndFunc   ;==>GetSeed
Func GetWorld($tFN)
	If Not FileExists($tFN) Then
		FileWriteLine($aLogFile, _NowCalc() & " ERROR! Could not find file: " & $tFN)
		SplashOff()
		MsgBox($MB_OK, $aUtilityVer, "ERROR! Could not find file: " & @CRLF & $tFN)
	EndIf
	Local $tMapPathOpen = FileOpen($tFN, 0)
	Local $tMapRead = FileRead($tMapPathOpen)
	FileClose($tFN)
	Local $tSize = _ArrayToString(_StringBetween($tMapRead, "Original Seed: ", @CRLF))
	If $tSize = "" Or $tSize = "-1" Then $tSize = "{Error]"
	Return $tSize
EndFunc   ;==>GetWorld

Func AddTrailingSlash($aString)
	Local $bString = StringRight($aString, 1)
	If $bString = "\" Then
		$aString = StringTrimRight($sString, 1)
	EndIf
	Return $aString & "\"
EndFunc   ;==>AddTrailingSlash

Func ReplaceSpace($aString)
	Local $bString = StringRegExpReplace($aString, " ", "_")
	Return $bString
EndFunc   ;==>ReplaceSpace

Func UtilUpdate($tLink, $tDL, $tUtil, $tUtilName, $tUpdateUtiClick)
	SplashTextOn($aUtilName, "Checking for " & $tUtilName & " updates.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
	Local $tVer[2]
	$sFilePath = @ScriptDir & "\" & $aUtilName & "_latest_ver.tmp"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	InetGet($tLink, $sFilePath, 1)
	Local $hFileOpen = FileOpen($sFilePath, 0)
	If $hFileOpen = -1 Then
		If $tUpdateUtiClick Then
			SplashOff()
			MsgBox($MB_OKCANCEL, $aUtilityVer, $aUtilName & " update check failed to download latest version: " & $tLink & @CRLF & @CRLF & "Please visit http://www.Phoenix125.com.", 10)
			$tUpdateUtiClick = False
		EndIf
		FileWriteLine($aLogFile, _NowCalc() & " [UTIL] " & $tUtilName & " update check failed to download latest version: " & $tLink)
	Else
		Local $hFileRead = FileRead($hFileOpen)
		$tVer = StringSplit($hFileRead, "^", 2)
		FileClose($hFileOpen)
		If $tVer[0] = $tUtil Then
			FileWriteLine($aLogFile, _NowCalc() & " [UTIL] " & $tUtilName & " up to date. Version: " & $tVer[0] & " , Notes: " & $tVer[1])
			If $tUpdateUtiClick Then
				SplashOff()
				MsgBox($MB_OKCANCEL, $aUtilityVer, $aUtilName & " up to date. " & @CRLF & "Installed version: " & $tUtil & @CRLF & "Latest version: " & $tVer[0] & @CRLF & @CRLF & "Notes: " & @CRLF & $tVer[1], 10)
				$tUpdateUtiClick = False
			EndIf
		Else
			FileWriteLine($aLogFile, _NowCalc() & " [UTIL] New " & $aUtilName & " update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0] & ", Notes: " & $tVer[1])
			SplashOff()
			$tVer[1] = ReplaceReturn($tVer[1])
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "New " & $aUtilName & " update available. " & @CRLF & "Installed version: " & $tUtil & @CRLF & "Latest version: " & $tVer[0] & @CRLF & @CRLF & _
					"Notes: " & @CRLF & $tVer[1] & @CRLF & @CRLF & _
					"Click (YES) to download update, but NOT install, to " & @CRLF & @ScriptDir & @CRLF & _
					"Click (NO) to stop checking for updates." & @CRLF & _
					"Click (CANCEL) to skip this update check.", 15)
			If $tMB = 6 Then
				SplashTextOn($aUtilityVer, " Downloading latest version of " & @CRLF & $tUtilName, 400, 100, -1, -1, $DLG_MOVEABLE, "")
				Local $tZIP = @ScriptDir & "\" & $tUtilName & "_" & $tVer[0] & ".zip"
				If FileExists($tZIP) Then
					FileDelete($tZIP)
				EndIf
				If FileExists($tUtilName & "_" & $tVer[0] & ".exe") Then
					FileDelete($tUtilName & "_" & $tVer[0] & ".exe")
				EndIf
				InetGet($tDL, $tZIP, 1)
				_ExtractZip($tZIP, "", $tUtilName & "_" & $tVer[0] & ".exe", @ScriptDir)
				If FileExists(@ScriptDir & "\readme.txt") Then
					FileDelete(@ScriptDir & "\readme.txt")
				EndIf
				_ExtractZip($tZIP, "", "readme.txt", @ScriptDir)
				;				FileDelete(@ScriptDir & "\" & $tUtilName & "_" & $tVer[1] & ".zip")
				If Not FileExists(@ScriptDir & "\" & $tUtilName & "_" & $tVer[0] & ".exe") Then
					FileWriteLine($aLogFile, _NowCalc() & " [UTIL] ERROR! " & $tUtilName & ".exe download failed.")
					SplashOff()
					$tMB = MsgBox($MB_OKCANCEL, $aUtilityVer, "Download failed . . . " & @CRLF & "Go to """ & $tLink & """ to download latest version." & @CRLF & @CRLF & "Click (OK), (CANCEL), or wait 15 seconds, to resume current version.", 15)
				Else
					SplashOff()
					$tMB = MsgBox($MB_OKCANCEL, $aUtilityVer, "Download complete. . . " & @CRLF & @CRLF & "Click (OK) to exit program OR" & @CRLF & "Click (CANCEL), or wait 15 seconds, to resume current version.", 15)
					If $tMB = 1 Then
						Global $aRemoteRestartUse = "no"
						Exit
					EndIf
				EndIf
			ElseIf $tMB = 7 Then
				$aUpdateUtil = "no"
				IniWrite($aIniFile, " --------------- " & $aUtilName & " CONFIG --------------- ", "Check for " & $aUtilName & " Updates? (yes/no)", "no")
			EndIf
		EndIf
	EndIf
	SplashOff()
EndFunc   ;==>UtilUpdate

Func ReplaceReturn($tMsg0)
	If StringInStr($tMsg0, "|") = "0" Then
		Return $tMsg0
	Else
		Return StringReplace($tMsg0, "|", @CRLF)
	EndIf
EndFunc   ;==>ReplaceReturn

#Region ;**** UnZip Function by trancexx ****
; #FUNCTION# ;===============================================================================
;
; Name...........: _ExtractZip
; Description ...: Extracts file/folder from ZIP compressed file
; Syntax.........: _ExtractZip($sZipFile, $sFolderStructure, $sFile, $sDestinationFolder)
; Parameters ....: $sZipFile - full path to the ZIP file to process
;                  $sFolderStructure - 'path' to the file/folder to extract inside ZIP file
;                  $sFile - file/folder to extract
;                  $sDestinationFolder - folder to extract to. Must exist.
; Return values .: Success - Returns 1
;                          - Sets @error to 0
;                  Failure - Returns 0 sets @error:
;                  |1 - Shell Object creation failure
;                  |2 - Destination folder is unavailable
;                  |3 - Structure within ZIP file is wrong
;                  |4 - Specified file/folder to extract not existing
; Author ........: trancexx
; https://www.autoitscript.com/forum/topic/101529-sunzippings-zipping/#comment-721866
;
;==========================================================================================
Func _ExtractZip($sZipFile, $sFolderStructure, $sFile, $sDestinationFolder)

	Local $i
	Do
		$i += 1
		$sTempZipFolder = @TempDir & "\Temporary Directory " & $i & " for " & StringRegExpReplace($sZipFile, ".*\\", "")
	Until Not FileExists($sTempZipFolder) ; this folder will be created during extraction

	Local $oShell = ObjCreate("Shell.Application")

	If Not IsObj($oShell) Then
		Return SetError(1, 0, 0) ; highly unlikely but could happen
	EndIf

	Local $oDestinationFolder = $oShell.NameSpace($sDestinationFolder)
	If Not IsObj($oDestinationFolder) Then
		Return SetError(2, 0, 0) ; unavailable destionation location
	EndIf

	Local $oOriginFolder = $oShell.NameSpace($sZipFile & "\" & $sFolderStructure) ; FolderStructure is overstatement because of the available depth
	If Not IsObj($oOriginFolder) Then
		Return SetError(3, 0, 0) ; unavailable location
	EndIf

	Local $oOriginFile = $oOriginFolder.ParseName($sFile)
	If Not IsObj($oOriginFile) Then
		Return SetError(4, 0, 0) ; no such file in ZIP file
	EndIf

	; copy content of origin to destination
	$oDestinationFolder.CopyHere($oOriginFile, 4) ; 4 means "do not display a progress dialog box", but apparently doesn't work

	DirRemove($sTempZipFolder, 1) ; clean temp dir

	Return 1 ; All OK!

EndFunc   ;==>_ExtractZip
#EndRegion ;**** UnZip Function by trancexx ****
