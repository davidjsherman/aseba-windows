/*
	Aseba - an event-based framework for distributed robot control
	Copyright (C) 2007--2011:
		Stephane Magnenat <stephane at magnenat dot net>
		(http://stephane.magnenat.net)
		and other contributors, see authors.txt for details
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published
	by the Free Software Foundation, version 3 of the License.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

;--------------------------------
;Includes

  !define REGISTRY_KEY "Software\aseba"
  !addincludedir ".\include"
  !include aseba-common-header.nsh
  !include "x64.nsh"		; x64 support
  !include "${ASEBA_BIN}\version.nsi"			; Get NSIS style version number

;--------------------------------
;General

  ;Default installation folder
  InstallDir "$PROGRAMFILES\AsebaStudio"
  
;--------------------------------
;Pages

  !define MUI_WELCOMEPAGE_TITLE_3LINES		; Add extra space for the title on the welcome page
  !insertmacro MUI_PAGE_WELCOME
  
  ; Licence
  !define MUI_LICENSEPAGE_TEXT_TOP $(STR_License_Top)
  !insertmacro MUI_PAGE_LICENSE $(license)
  
  ; Install type (with / without the driver)
  Page custom nsInstallType

  ; Components
  !insertmacro MUI_PAGE_COMPONENTS
  
  ; Choose directory
  !insertmacro MUI_PAGE_DIRECTORY
  
  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_DEFAULTFOLDER "Aseba"
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGISTRY_KEY} 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  !insertmacro MUI_PAGE_STARTMENU "Application" $StartMenuFolder
  
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;Translations
  !insertmacro LANG_LOAD "English"			; translations/English.nsh
  !insertmacro LANG_LOAD "French"			; translations/French.nsh
  !insertmacro LANG_LOAD "German"			; translations/German.nsh
  !insertmacro LANG_LOAD "Italian"			; translations/Italian.nsh

; License: only the english license is used, because FSF strongly discourage using an unofficial translation
LicenseLangString license ${LANG_ENGLISH} "${ASEBA_SRC}\license.txt"
LicenseLangString license ${LANG_FRENCH}  "${ASEBA_SRC}\license.txt"
LicenseLangString license ${LANG_GERMAN}  "${ASEBA_SRC}\license.txt"
LicenseLangString license ${LANG_ITALIAN} "${ASEBA_SRC}\license.txt"

;--------------------------------
;Name and file (Defined here to be translation-enabled)

  !define MY_NAME $(STR_Package_Name)
  !define /date Iso8601 "%Y%m%dT%H%M"
  OutFile "${PACKAGE_BIN}\aseba-djs-${VERSION}-${Iso8601}-win32.exe"
  Name ${MY_NAME}

;--------------------------------
;Installer Sections

  !include aseba-common-start.nsh		; Logging, version file, shortcut cleaning, installation type
  !include aseba-common-bin.nsh			; Part common to the release + dbg package (included files may be different)
