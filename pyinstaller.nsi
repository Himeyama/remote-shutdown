!define MUI_ICON "www\icon.ico"
!define ICON "_internal\www\icon.ico"
!define PRODUCT_NAME "Remote Shutdown"
!define INSTALL_DIR "$LOCALAPPDATA\remote-shutdown" # インストール先
!define PUBLISH_DIR "dist\remote_shutdown"
!define EXEC_FILE "remote_shutdown.exe"
!define PRODUCT_PUBLISHER "Hikari"

# Modern UI
!include MUI2.nsh
# nsDialogs
!include nsDialogs.nsh
# LogicLib
!include LogicLib.nsh

# アプリケーション名
Name "${PRODUCT_NAME}"

BrandingText "${PRODUCT_NAME} v${VERSION}"

# 作成されるインストーラ
OutFile "Install.exe"

# インストールされるディレクトリ
InstallDir "${INSTALL_DIR}"

# アイコン
Icon "${MUI_ICON}"
UninstallIcon "${MUI_ICON}"

# ページ
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE LICENSE.txt
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "Japanese"

# デフォルト セクション
Section
    # 出力先を指定します。
    SetOutPath "$INSTDIR"

    # インストールされるファイル
    File /r "${PUBLISH_DIR}\\*.*"

    # アンインストーラを出力
    WriteUninstaller "$INSTDIR\\Uninstall.exe"

    # スタート メニューにショートカットを登録
    CreateDirectory "$SMPROGRAMS\\${PRODUCT_NAME}"
    SetOutPath "$INSTDIR"
    CreateShortcut "$SMPROGRAMS\\${PRODUCT_NAME}\\${PRODUCT_NAME}.lnk" "$INSTDIR\\${EXEC_FILE}" "" "$INSTDIR\${ICON}"
    CreateShortcut "$SMPROGRAMS\\Startup\\${PRODUCT_NAME}.lnk" "$INSTDIR\\${EXEC_FILE}" "" "$INSTDIR\${ICON}"

    # レジストリに登録
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "Publisher" "${PRODUCT_PUBLISHER}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\${ICON}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "DisplayVersion" "${VERSION}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "InstallDate" "${DATE}"
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "EstimatedSize" "${SIZE}"
SectionEnd

# アンインストーラ
Section "Uninstall"
    # アンインストーラを削除
    Delete "$INSTDIR\\Uninstall.exe"

    # ファイルを削除
    Delete "$INSTDIR\\${EXEC_FILE}"

    # ディレクトリを削除
    RMDir /r "$INSTDIR"

    # スタート メニューから削除
    Delete "$SMPROGRAMS\\${PRODUCT_NAME}\\${PRODUCT_NAME}.lnk"
    Delete "$SMPROGRAMS\\Startup\\${PRODUCT_NAME}.lnk"
    RMDir "$SMPROGRAMS\\${PRODUCT_NAME}"

    # レジストリ キーを削除
    DeleteRegKey HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}"
SectionEnd