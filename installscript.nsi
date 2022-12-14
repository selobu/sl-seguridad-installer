# LICENSE GNU GPL V3
# Auto-generated by EclipseNSIS Script Wizard
# 06/05/2012 16:43:35
# last updated
# 2022/10/09 # YYYY/MM/DD

# SetCompress off
SetCompressor /SOLID LZMA

# General Symbol Definitions
!define APPNAME "SL Seguridad"
!define COMPANY "SL Servicios Latam SAS"
!define URL "https://gestionhseq.com"
!define DESCRIPCION "Asistente SG-SST pc ${URL}"
!define EXENAME "slseguridad"

!define WIN64DRIVERURL "http://www.ch-werner.de/sqliteodbc/sqliteodbc_w64.exe"
!define WIN32DRIVERURL "http://www.ch-werner.de/sqliteodbc/sqliteodbc.exe"
!define WIN64FIREBIRDRURL "https://github.com/FirebirdSQL/firebird/releases/download/v4.0.2/Firebird-4.0.2.2816-0-x64.exe"
!define WIN32FIREBIRDRURL "https://github.com/FirebirdSQL/firebird/releases/download/v4.0.2/Firebird-4.0.2.2816-0-Win32.exe"
!define CURRPATH ".\dist\slseguridad\"
!define SRCPATH ".\"
!define T3ERDPARTYPATH ".\3d party software\"
!define REGKEY "SOFTWARE\$(^Name)"
!define /file VERSIONFILE versionGO.txt
!define VERSION "${VERSIONFILE}"

# required by the installer even if it's redundant
Name "${APPNAME}"
VIProductVersion "${VERSION}"

# Check if the app is running
!define WNDCLASS "WindowClassOfYourApplication"
!define WNDTITLE $(^Name)

# MultiUser Symbol Definitions
!define MULTIUSER_EXECUTIONLEVEL Standard
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUE "Path"
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR $(^Name)
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${REGKEY}"

# MUI Symbol Definitions
!define MUI_ICON "${SRCPATH}\ossa.ico"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER $(^Name)

# https://nsis.sourceforge.io/Run_an_application_shortcut_after_an_install
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Ejecutar ${APPNAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"

!define MUI_UNICON "${SRCPATH}\ossa.ico"

# Included files
!include MultiUser.nsh
!include Sections.nsh
!include MUI2.nsh

# logica ${IF} ${CASE} # read https://nsis.sourceforge.io/Docs/Chapter2.html#tut-functions
!include LogicLib.nsh

# Variables
Var StartMenuGroup

# Installer pages
    !insertmacro MUI_PAGE_WELCOME
    !insertmacro MUI_PAGE_LICENSE "license.txt"
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
    !insertmacro MUI_PAGE_COMPONENTS
    !insertmacro MUI_PAGE_INSTFILES 
    !insertmacro MUI_PAGE_FINISH
    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English
!insertmacro MUI_LANGUAGE SpanishInternational

# display a window to be as an user admin
# RequestExecutionLevel admin

# Installer name
OutFile "${APPNAME} V${VERSION} setup.exe"
InstallDir $(^Name)
CRCCheck on
XPStyle on
ShowInstDetails nevershow

VIAddVersionKey /LANG=${LANG_ENGLISH} ProductName "${APPNAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyWebsite "${URL}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileDescription "${DESCRIPCION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} LegalCopyright "${COMPANY}"
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

SectionGroup /e "Controladores BI - odbc" SecODBC # /e  expanded
    Section /o "SQLODBC Driver win_64" SecODBC64 # /o optional
        # make the installation available to the current user
        SetShellVarContext current
        
        NSISdl::download "${WIN64DRIVERURL}" "$pluginsdir\sqliteodbc_w64.exe"
        Pop $0
        ${If} $0 == "success"
            ExecShell "" '"$pluginsdir\sqliteodbc_w64.exe"' ;Open installer
        ${Else}
            MessageBox mb_iconstop "Error: $0" ;Show cancel/error message
        ${EndIf}
    SectionEnd
    
    Section /o "SQLODBC Driver win_32" SecODBC32
        # make the installation available to the current user
        SetShellVarContext current
        
        NSISdl::download "${WIN32DRIVERURL}" "$pluginsdir\sqliteodbc_w32.exe"
        Pop $0
        ${If} $0 == "success"
            ExecShell "" '"$pluginsdir\sqliteodbc_w32.exe"' ;Open installer
        ${Else}
            MessageBox mb_iconstop "Error: $0" ;Show cancel/error message
        ${EndIf}
    SectionEnd
SectionGroupEnd

Section "${APPNAME}" SecMain
    # make the installation available to the current user
    SetShellVarContext current
    
	SetOutPath $INSTDIR
    SetOverwrite on
    File /r ${SRCPATH}\versionGO.txt
	File /r ${SRCPATH}\version.txt
	File /r ${CURRPATH}\*.*
	
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r ${SRCPATH}\license.html
    
    # bases datos para creacion
    SetOutPath $INSTDIR\bases
    SetOverwrite on
    File /r ${SRCPATH}\bases\*.*
     
    SetOutPath $INSTDIR\plugins
    SetOverwrite on
    file /r ${SRCPATH}\plugins\*.egg
	    
    # templates
    SetOutPath $INSTDIR\templates
    SetOverwrite on
    File /r ${SRCPATH}\templates\*.*
	
	# resources
    SetOutPath $INSTDIR\resources
    SetOverwrite on
    File /r ${SRCPATH}\resources\*.*
    
	# diccionario de espa??ol
    SetOutPath $INSTDIR\locale
    SetOverwrite on
	File /r ${SRCPATH}\locale\*.mo
    
    # icons    
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r ${SRCPATH}\ossa.ico
    File /r ${SRCPATH}\versionGO.txt
	File /r ${SRCPATH}\stream.gob
	# client-admin definition
	SetOutPath $INSTDIR
    
    # diccionario de espa??ol
    SetOutPath $INSTDIR\enchant\share\enchant\myspell
    SetOverwrite on
    File /r ${SRCPATH}\dict_es\*.*

    # creating the StartMenuGroup
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    SetOutPath $INSTDIR # the sortcuts starts in this path
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^Name).lnk" "$INSTDIR\${EXENAME}.exe" \
        "" "$INSTDIR\ossa.ico" 0 SW_SHOWNORMAL
    CreateShortcut "$DESKTOP\$(^Name).lnk" "$INSTDIR\${EXENAME}.exe" "" \
                "$INSTDIR\ossa.ico" 0
	#SetShellVarContext current # current user
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
	WriteRegStr HKLM "${REGKEY}" "InstallDir" $INSTDIR
	WriteRegStr HKLM "${REGKEY}" "Version" "${VERSION}"
    RmDir /r  $INSTDIR\Prerequisites
SectionEnd

;--------------------------------
;Descriptions
 
;textos segun los lenguajes
LangString DESC_SecMain ${LANG_ENGLISH} "Requerido archivos de programa."
LangString DESC_SecMain ${LANG_SPANISHINTERNATIONAL} "Requerido archivos de programa."
LangString DESC_SecODBC ${LANG_ENGLISH} "Controladores conexi??n POWER BI."
LangString DESC_SecODBC ${LANG_SPANISHINTERNATIONAL} "Controladores conexi??n POWER BI."
LangString DESC_SecODBC64 ${LANG_ENGLISH} "Controlador windows 64, mas com??n"
LangString DESC_SecODBC64 ${LANG_SPANISHINTERNATIONAL} "Controlador windows 64, mas com??n"
LangString DESC_SecODBC32 ${LANG_ENGLISH} "Controlador windows 32."
LangString DESC_SecODBC32 ${LANG_SPANISHINTERNATIONAL} "Controlador windows 32."

 
;Asignar textos a las secciones
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_SecMain)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecODBC} $(DESC_SecODBC)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecODBC64} $(DESC_SecODBC64)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecODBC32} $(DESC_SecODBC32)
!insertmacro MUI_FUNCTION_DESCRIPTION_END


Section -post SEC0001
    # make the installation available to all users
    SetShellVarContext current

    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd


# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Installer functions
Function .onInit
    # check if the app is runing
    FindWindow $0 "${WNDCLASS}" "${APPNAME}"
    ${If} $0 == 0
        InitPluginsDir
        !insertmacro MULTIUSER_INIT
    ${Else}
        MessageBox MB_ICONSTOP|MB_OK "The application you are trying to remove is running. Close it and try again."
        Abort
    ${EndIf}
FunctionEnd

Function LaunchLink
  ExecShell "" "$DESKTOP\$(^Name).lnk"
FunctionEnd

########################
# Uninstaller sections #
########################
Section /o -un.Main UNSEC0000
    # make the installation available to all users
    SetShellVarContext current

    SetOverwrite on
    Delete  "$DESKTOP\${APPNAME}.lnk"
    #UnRegDLL $INSTDIR\T3rLibraries\fbclient.dll
    RmDir /r $SMPROGRAMS\$StartMenuGroup
    RmDir /r  $INSTDIR\help
    RmDir /r  $INSTDIR\src
    RmDir /r  $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" Main
	DeleteRegKey HKLM "${REGKEY}"
SectionEnd

Section -un.post UNSEC0001
    # make the installation available to all users
    SetShellVarContext current

    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /r $SMPROGRAMS\$StartMenuGroup
    RmDir /r $INSTDIR  
SectionEnd

# Uninstaller functions
Function un.onInit
    ;SetAutoClose true
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MULTIUSER_UNINIT
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

# Installer Language Strings
# TODO Update the Language Strings with the appropriate translations.

LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_SPANISHINTERNATIONAL} "Uninstall $(^Name)"
