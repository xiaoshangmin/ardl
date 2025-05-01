; 定义安装程序信息
[Setup]
AppName=Ardl
AppVersion=1.0
DefaultDirName={pf}\Ardl
DefaultGroupName=Ardl
OutputDir=.
OutputBaseFilename=ardl
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin

; 复制 Flutter 生成的 Windows 运行文件
[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; 创建快捷方式
[Icons]
Name: "{group}\Ardl"; Filename: "{app}\ardl.exe"
Name: "{commondesktop}\Ardl"; Filename: "{app}\ardl.exe"; Tasks: desktopicon

; 创建卸载信息
[UninstallDelete]
Type: filesandordirs; Name: "{app}"

; 任务设置
[Tasks]
Name: "desktopicon"; Description: "创建桌面快捷方式"; GroupDescription: "附加任务："

; 运行程序
[Run]
Filename: "{app}\ardl.exe"; Description: "运行 Ardl App"; Flags: nowait postinstall skipifsilent
