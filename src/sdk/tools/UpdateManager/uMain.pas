unit uMain;

interface

uses
  // Delphi
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Buttons, StdCtrls, TypInfo, Generics.Collections,
  ShellAPI,
  // JEDI VCL
  JvWizard, JvWizardRouteMapNodes, JvExControls, JvLED,
  // DevExpress
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxCheckBox, cxLabel, cxTextEdit, cxDropDownEdit, cxBlobEdit, cxGridCustomTableView, cxGridTableView, cxGridCustomView,
  cxClasses, cxGridLevel, cxGrid, cxMemo, cxContainer, cxMaskEdit, cxSpinEdit,
  // Export
  uDynamicExport,
  // Api
  uApiUpdateConst, uApiUpdateInterface, uApiUpdateSettings, uApiUpdateController,
  // Utils
  uFileUtils, uPathUtils, uSetUtils, uStringUtils;

type
  TfMain = class(TForm)
    JvWizard: TJvWizard;
    JvWizardWelcomePage: TJvWizardWelcomePage;
    JvWizardInteriorPageLocalFiles: TJvWizardInteriorPage;
    JvWizardRouteMapNodes: TJvWizardRouteMapNodes;
    rbAddNewPath: TRadioButton;
    eRootDir: TEdit;
    sbSelectRootDir: TSpeedButton;
    rbSelectExisting: TRadioButton;
    lbSelectPath: TListBox;
    cxGLocalFiles: TcxGrid;
    cxGLocalFilesLevel: TcxGridLevel;
    cxGLocalFilesTableView: TcxGridTableView;
    cxGLocalFilesTableViewColumn1: TcxGridColumn;
    cxGLocalFilesTableViewColumn2: TcxGridColumn;
    cxGLocalFilesTableViewColumn3: TcxGridColumn;
    cxGLocalFilesTableViewColumn4: TcxGridColumn;
    cxGLocalFilesTableViewColumn5: TcxGridColumn;
    cxGLocalFilesTableViewColumn6: TcxGridColumn;
    lFileSystem: TLabel;
    JvWizardInteriorPageServer: TJvWizardInteriorPage;
    JvWizardInteriorPagePublish: TJvWizardInteriorPage;
    JvWizardInteriorPageServerInfo: TJvWizardInteriorPage;
    rbAddNewServer: TRadioButton;
    eServerDir: TEdit;
    rbSelectExistingServer: TRadioButton;
    lbSelectServer: TListBox;
    eServerAccessToken: TEdit;
    lServerAccessToken: TLabel;
    JvLEDConnectToServer: TJvLED;
    lConnectToServer: TLabel;
    JvLEDRecivingUpdateVersions: TJvLED;
    lRecivingUpdateVersions: TLabel;
    JvLEDRecivingFTPServer: TJvLED;
    lRecivingFTPServer: TLabel;
    JvLEDRecivingUpdateFiles: TJvLED;
    lRecivingUpdateFiles: TLabel;
    JvWizardInteriorPageUpdateFiles: TJvWizardInteriorPage;
    lServerInfoError: TLabel;
    eServerInfoError: TEdit;
    cxGUpdateFiles: TcxGrid;
    cxGUpdateFilesTableView: TcxGridTableView;
    cxGUpdateFilesTableViewColumn1: TcxGridColumn;
    cxGUpdateFilesTableViewColumn2: TcxGridColumn;
    cxGUpdateFilesTableViewColumn3: TcxGridColumn;
    cxGUpdateFilesTableViewColumn4: TcxGridColumn;
    cxGUpdateFilesTableViewColumn5: TcxGridColumn;
    cxGUpdateFilesTableViewColumn6: TcxGridColumn;
    cxGUpdateFilesLevel: TcxGridLevel;
    JvWizardInteriorPageUpdateVersion: TJvWizardInteriorPage;
    JvWizardInteriorPageUploadFiles: TJvWizardInteriorPage;
    rbAddNewVersion: TRadioButton;
    rbSelectExistingVersion: TRadioButton;
    lbSelectVersion: TListBox;
    cxSEMajorVersion: TcxSpinEdit;
    cxSEMinorVersion: TcxSpinEdit;
    cxSEMajorBuild: TcxSpinEdit;
    cxSEMinorBuild: TcxSpinEdit;
    lPreRelease: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure JvWizardCancelButtonClick(Sender: TObject);
    { *************************************** STEP - 1 *************************************** }
    procedure JvWizardWelcomePagePage(Sender: TObject);
    procedure JvWizardWelcomePageNextButtonClick(Sender: TObject; var Stop: Boolean);
    procedure rbSelectFileSystem(Sender: TObject);
    procedure eRootDirChange(Sender: TObject);
    procedure sbSelectRootDirClick(Sender: TObject);
    procedure lbSelectPathClick(Sender: TObject);
    { *************************************** STEP - 2 *************************************** }
    procedure JvWizardInteriorPageServerPage(Sender: TObject);
    procedure JvWizardInteriorPageServerNextButtonClick(Sender: TObject; var Stop: Boolean);
    procedure rbSelectServer(Sender: TObject);
    procedure eServerDirChange(Sender: TObject);
    procedure lbSelectServerClick(Sender: TObject);
    { *************************************** STEP - 3 *************************************** }
    procedure JvWizardInteriorPageServerInfoPage(Sender: TObject);
    { *************************************** STEP - 4 *************************************** }
    procedure JvWizardInteriorPageLocalFilesExitPage(Sender: TObject; const FromPage: TJvWizardCustomPage);
    procedure JvWizardInteriorPageLocalFilesPage(Sender: TObject);
    procedure JvWizardInteriorPageLocalFilesNextButtonClick(Sender: TObject; var Stop: Boolean);
    procedure cxGLocalFilesTableViewColumn2CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure cxGLocalFilesTableViewColumn5GetPropertiesForEdit(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure cxGLocalFilesTableViewDataControllerDataChanged(Sender: TObject);
    procedure lFileSystemClick(Sender: TObject);
    { *************************************** STEP - 5 *************************************** }
    procedure JvWizardInteriorPageUpdateFilesPage(Sender: TObject);

    { *************************************** STEP - 6 *************************************** }
    procedure JvWizardInteriorPageUpdateVersionPage(Sender: TObject);
    procedure rbSelectVersion(Sender: TObject);
    procedure cxSEMinorBuildPropertiesChange(Sender: TObject);
    { *************************************** STEP - 6 *************************************** }

    procedure JvWizardInteriorPageUploadFilesPage(Sender: TObject);

    { *************************************** STEP - 7 *************************************** }
  private
  var
    FActiveUpdateFileCollectionItem: TUpdateFileSystemCollectionItem;
    FActiveUpdateServerCollectionItem: TUpdateServerCollectionItem;

    FActiveVersionsList: TUpdateManagerVersionsList;
    FActiveUpdateFTPServer: IFTPServer;
    FActiveSystemsList: TUpdateManagerSystemsList;

    FActiveLocalFiles: TUpdateManagerLocalFileList;

    procedure LoadSettings;
    procedure SaveSettings;

    procedure CanContinue(AValue: Boolean; APage: TJvWizardCustomPage);
    procedure CheckCanContinueToServer;
    procedure CheckCanContinueToServerInfo;
    procedure CheckCanContinueToUpdateFiles;
    procedure CheckCanContinueToUploadFiles;
  protected
    function LoadServerInfos: Boolean;
    function LoadLocalFilesList: Boolean;
    function LoadUpdateFilesList: Boolean;

    procedure SaveFilesList;
    procedure MakeUpdate;
  public

  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.FormCreate(Sender: TObject);
begin
  cxGLocalFilesTableView.DataController.OnDataChanged := nil;
  LoadSettings;
end;

procedure TfMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FActiveVersionsList) then
    FActiveVersionsList.Free;

  if Assigned(FActiveUpdateFTPServer) then
    FActiveUpdateFTPServer := nil;

  if Assigned(FActiveSystemsList) then
    FActiveSystemsList.Free;

  if Assigned(FActiveLocalFiles) then
    FActiveLocalFiles.Free;

  SaveSettings;
end;

procedure TfMain.JvWizardCancelButtonClick(Sender: TObject);
begin
  Close;
end;

{ *************************************** STEP - 1 *************************************** }

procedure TfMain.JvWizardWelcomePagePage(Sender: TObject);
begin
  lbSelectPath.Items.Text := SettingsManager.Settings.GetLibraryFiles;
  CheckCanContinueToServer;
end;

procedure TfMain.JvWizardWelcomePageNextButtonClick(Sender: TObject; var Stop: Boolean);
begin
  if rbAddNewPath.Checked then
  begin
    FActiveUpdateFileCollectionItem := TUpdateFileSystemCollectionItem(SettingsManager.Settings.FileSystems.Add);
    FActiveUpdateFileCollectionItem.LibraryFile := eRootDir.Text;
  end
  else if rbSelectExisting.Checked then
    FActiveUpdateFileCollectionItem := SettingsManager.Settings.FindFileSystem(lbSelectPath.Items[lbSelectPath.ItemIndex]);
end;

procedure TfMain.rbSelectFileSystem(Sender: TObject);
begin
  eRootDir.Enabled := rbAddNewPath.Checked;
  sbSelectRootDir.Enabled := rbAddNewPath.Checked;

  lbSelectPath.Enabled := rbSelectExisting.Checked;

  CheckCanContinueToServer;
end;

procedure TfMain.eRootDirChange(Sender: TObject);
begin
  CheckCanContinueToServer;
end;

procedure TfMain.sbSelectRootDirClick(Sender: TObject);
var
  LDir: string;
begin
  LDir := eRootDir.Text;

  with TOpenDialog.Create(nil) do
    try
      Filter := 'IntelligeN 2009 FileSystem (' + INTELLIGEN_FILESYSTEM_LIB + ')|' + INTELLIGEN_FILESYSTEM_LIB;
      if Execute then
        eRootDir.Text := FileName;
    finally
      Free;
    end;
end;

procedure TfMain.lbSelectPathClick(Sender: TObject);
begin
  CheckCanContinueToServer;
end;

{ *************************************** STEP - 2 *************************************** }

procedure TfMain.JvWizardInteriorPageServerPage(Sender: TObject);
begin
  lbSelectServer.Items.Text := SettingsManager.Settings.GetUpdateServers;
  CheckCanContinueToServerInfo;
end;

procedure TfMain.JvWizardInteriorPageServerNextButtonClick(Sender: TObject; var Stop: Boolean);
begin
  if rbAddNewServer.Checked then
  begin
    FActiveUpdateServerCollectionItem := TUpdateServerCollectionItem(SettingsManager.Settings.UpdateServers.Add);
    FActiveUpdateServerCollectionItem.Name := eServerDir.Text;
    FActiveUpdateServerCollectionItem.AccessToken := eServerAccessToken.Text;
  end
  else if rbSelectExistingServer.Checked then
    FActiveUpdateServerCollectionItem := SettingsManager.Settings.FindServer(lbSelectServer.Items[lbSelectServer.ItemIndex]);
end;

procedure TfMain.rbSelectServer(Sender: TObject);
begin
  eServerDir.Enabled := rbAddNewServer.Checked;
  eServerAccessToken.Enabled := rbAddNewServer.Checked;

  lbSelectServer.Enabled := rbSelectExistingServer.Checked;

  CheckCanContinueToServerInfo;
end;

procedure TfMain.eServerDirChange(Sender: TObject);
begin
  CheckCanContinueToServerInfo;
end;

procedure TfMain.lbSelectServerClick(Sender: TObject);
begin
  CheckCanContinueToServerInfo;
end;

{ *************************************** STEP - 3 *************************************** }

procedure TfMain.JvWizardInteriorPageServerInfoPage(Sender: TObject);
var
  LCanContinue: Boolean;
begin
  LCanContinue := LoadServerInfos;
  CanContinue(LCanContinue, JvWizardInteriorPageServerInfo);
end;

{ *************************************** STEP - 4 *************************************** }

procedure TfMain.JvWizardInteriorPageLocalFilesExitPage(Sender: TObject; const FromPage: TJvWizardCustomPage);
begin
  cxGLocalFilesTableView.DataController.OnDataChanged := nil;
end;

procedure TfMain.JvWizardInteriorPageLocalFilesPage(Sender: TObject);
var
  LCanContinue: Boolean;
begin
  LCanContinue := LoadLocalFilesList;
  lFileSystem.Caption := ExtractFilePath(FActiveUpdateFileCollectionItem.LibraryFile);
  cxGLocalFilesTableView.DataController.OnDataChanged := cxGLocalFilesTableViewDataControllerDataChanged;
  CanContinue(LCanContinue, JvWizardInteriorPageLocalFiles);
end;

procedure TfMain.JvWizardInteriorPageLocalFilesNextButtonClick(Sender: TObject; var Stop: Boolean);
var
  LFileIndex: Integer;
begin
  for LFileIndex := 0 to FActiveLocalFiles.Count - 1 do
    with cxGLocalFilesTableView.DataController, FActiveLocalFiles[LFileIndex].LocalFile do
    begin
      Status := Values[LFileIndex, cxGLocalFilesTableViewColumn1.Index];
      // Action := TUpdateAction(GetEnumValue(TypeInfo(TUpdateAction), Values[LFileIndex, cxGFilesTableViewColumn5.Index]));
    end;
end;

procedure TfMain.cxGLocalFilesTableViewColumn2CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  V: Variant;
begin
  V := AViewInfo.Value;

  if not VarIsNull(V) then
  begin
    if Pos('New', V) > 0 then
      AViewInfo.EditViewInfo.TextColor := clPurple
    else if Pos('Mis', V) > 0 then
      AViewInfo.EditViewInfo.TextColor := clRed
    else
      AViewInfo.EditViewInfo.TextColor := clBlack;

    AViewInfo.EditViewInfo.Paint(ACanvas);

    ADone := True;
  end;
end;

procedure TfMain.cxGLocalFilesTableViewColumn5GetPropertiesForEdit(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
begin
  TcxCustomComboBoxProperties(AProperties).Items.Text := ARecord.Values[cxGLocalFilesTableViewColumn6.Index];
end;

procedure TfMain.cxGLocalFilesTableViewDataControllerDataChanged(Sender: TObject);
begin
  CheckCanContinueToUpdateFiles;
end;

procedure TfMain.lFileSystemClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(lFileSystem.Caption), nil, nil, SW_SHOW);
end;

{ *************************************** STEP - 5 *************************************** }

procedure TfMain.JvWizardInteriorPageUpdateFilesPage(Sender: TObject);
begin
  LoadUpdateFilesList;
end;

{ *************************************** STEP - 6 *************************************** }

procedure TfMain.JvWizardInteriorPageUpdateVersionPage(Sender: TObject);
var
  LVersionIndex: Integer;
begin
  for LVersionIndex := 0 to FActiveVersionsList.Count - 1 do
    lbSelectVersion.Items.Add(FActiveVersionsList[LVersionIndex].ToString);

  CheckCanContinueToUploadFiles;
end;

procedure TfMain.rbSelectVersion(Sender: TObject);
begin
  cxSEMajorVersion.Enabled := rbAddNewVersion.Checked;
  cxSEMinorVersion.Enabled := rbAddNewVersion.Checked;
  cxSEMajorBuild.Enabled := rbAddNewVersion.Checked;
  cxSEMinorBuild.Enabled := rbAddNewVersion.Checked;

  lbSelectVersion.Enabled := rbSelectExistingVersion.Checked;

  CheckCanContinueToUploadFiles;
end;

procedure TfMain.cxSEMinorBuildPropertiesChange(Sender: TObject);
begin
  lPreRelease.Visible := not(cxSEMinorBuild.Value = 0);
end;

{ *************************************** STEP - 6 *************************************** }

procedure TfMain.JvWizardInteriorPageUploadFilesPage(Sender: TObject);
begin
  //
end;

{ ****************************************************************************** }

procedure TfMain.LoadSettings;
begin

end;

procedure TfMain.SaveSettings;
begin

end;

{ ****************************************************************************** }

procedure TfMain.CanContinue(AValue: Boolean; APage: TJvWizardCustomPage);
begin
  with APage do
    case AValue of
      True:
        EnabledButtons := EnabledButtons + [bkNext];
    else
      EnabledButtons := EnabledButtons - [bkNext];
    end;
end;

procedure TfMain.CheckCanContinueToServer;
begin
  FActiveUpdateFileCollectionItem := nil;
  if rbAddNewPath.Checked then
    CanContinue(FileExists(eRootDir.Text) and (Pos(INTELLIGEN_FILESYSTEM_LIB, eRootDir.Text) > 0) and (lbSelectPath.Items.IndexOf(eRootDir.Text) = -1), JvWizardWelcomePage)
  else if rbSelectExisting.Checked then
    CanContinue((lbSelectPath.ItemIndex <> -1) and FileExists(lbSelectPath.Items[lbSelectPath.ItemIndex]), JvWizardWelcomePage);
end;

procedure TfMain.CheckCanContinueToServerInfo;
begin
  FActiveUpdateServerCollectionItem := nil;
  if rbAddNewServer.Checked then
    CanContinue((length(eServerDir.Text) > 10) and (Pos('http://', eServerDir.Text) > 0) and (lbSelectServer.Items.IndexOf(eServerDir.Text) = -1), JvWizardInteriorPageServer)
  else if rbSelectExistingServer.Checked then
    CanContinue((lbSelectServer.ItemIndex <> -1), JvWizardInteriorPageServer);
end;

procedure TfMain.CheckCanContinueToUpdateFiles;
var
  LFileIndex: Integer;
  LCanContinue: Boolean;
begin
  LCanContinue := False;
  with cxGLocalFilesTableView.DataController do
    for LFileIndex := 0 to RecordCount - 1 do
    begin
      if Values[LFileIndex, cxGLocalFilesTableViewColumn1.Index] then
      begin
        LCanContinue := True;
        break;
      end;
    end;
  CanContinue(LCanContinue, JvWizardInteriorPageLocalFiles);
end;

procedure TfMain.CheckCanContinueToUploadFiles;

  function FileVersionToStr(MajorVersion, MinorVersion, MajorBuild, MinorBuild: Integer): string;
  begin
    Result := IntToStr(MajorVersion) + '.' + IntToStr(MinorVersion) + '.' + IntToStr(MajorBuild) + '.' + IntToStr(MinorBuild);
  end;

begin
  if rbAddNewVersion.Checked then
  begin
    CanContinue((lbSelectServer.Items.IndexOf(FileVersionToStr(cxSEMajorVersion.Value, cxSEMinorVersion.Value, cxSEMajorBuild.Value, cxSEMinorBuild.Value)) = -1), JvWizardInteriorPageUpdateVersion)
  end
  else if rbSelectExistingVersion.Checked then
    CanContinue((lbSelectVersion.ItemIndex <> -1), JvWizardInteriorPageUpdateVersion);
end;

{ ****************************************************************************** }

function TfMain.LoadServerInfos: Boolean;

  procedure SetLEDStatus(AStatus: Boolean; ALED: TJvLED; AJump: Boolean = False);
  begin
    with ALED do
    begin
      case AStatus of
        True:
          case AJump of
            True:
              ColorOn := clBlue;
          else
            ColorOn := clLime;
          end;
      else
        ColorOn := clRed;
      end;
      Status := True;
    end;
  end;

  procedure SetErrorMsg(AStatus: Boolean; AMsg: string);
  begin
    with eServerInfoError do
    begin
      lServerInfoError.Visible := not AStatus;
      Visible := not AStatus;
      case AStatus of
        True:
          Text := '';
      else
        Text := AMsg;
      end;
    end;
  end;

var
  LLocalUploadController: TLocalUploadController;

  LStatus: WordBool;
  LErrorMsg: WideString;
begin
  LStatus := False;

  if Assigned(FActiveVersionsList) then
    FActiveVersionsList.Free;

  if Assigned(FActiveUpdateFTPServer) then
    FActiveUpdateFTPServer := nil;

  if Assigned(FActiveSystemsList) then
    FActiveSystemsList.Free;

  LLocalUploadController := TLocalUploadController.Create(FActiveUpdateServerCollectionItem);
  try
    LErrorMsg := '';

    LStatus := LLocalUploadController.GetVersions(FActiveVersionsList, LErrorMsg);

    SetLEDStatus(LStatus, JvLEDConnectToServer);
    SetLEDStatus(LStatus, JvLEDRecivingUpdateVersions);

    if not LStatus then
    begin
      SetErrorMsg(LStatus, LErrorMsg);
    end
    else
    begin
      LErrorMsg := '';

      LStatus := LLocalUploadController.GetFTPServer(FActiveUpdateFTPServer, LErrorMsg);
      SetLEDStatus(LStatus, JvLEDRecivingFTPServer);

      if not LStatus then
      begin
        SetErrorMsg(LStatus, LErrorMsg);
      end
      else
      begin
        LErrorMsg := '';

        LStatus := LLocalUploadController.GetSystems(FActiveSystemsList, LErrorMsg);
        SetLEDStatus(LStatus, JvLEDRecivingUpdateFiles);
      end;
    end;
  finally
    LLocalUploadController.Free;
  end;

  Result := LStatus;
end;

function TfMain.LoadLocalFilesList: Boolean;

  function ActionsToStr(AUpdateActions: TUpdateActions): string;
  begin
    with SplittString(',', SetToString(TypeInfo(TUpdateActions), AUpdateActions, False)) do
      try
        Result := Text;
      finally
        Free;
      end;
  end;

var
  LLocalUpdateController: TLocalUpdateController;

  LStatus: WordBool;
  LFileIndex: Integer;
begin
  LStatus := False;

  if Assigned(FActiveLocalFiles) then
    FActiveLocalFiles.Free;

  LLocalUpdateController := TLocalUpdateController.Create(FActiveUpdateFileCollectionItem.LibraryFile);
  try
    LLocalUpdateController.GetLocalFiles(FActiveSystemsList, FActiveLocalFiles);
  finally
    LLocalUpdateController.Free;
  end;

  with cxGLocalFilesTableView.DataController do
  begin
    RecordCount := 0;

    BeginUpdate;
    try
      RecordCount := FActiveLocalFiles.Count;

      for LFileIndex := 0 to RecordCount - 1 do
        with FActiveLocalFiles[LFileIndex] do
        begin
          Values[LFileIndex, cxGLocalFilesTableViewColumn1.Index] := LocalFile.Status;
          if LocalFile.Status then
            LStatus := True;
          Values[LFileIndex, cxGLocalFilesTableViewColumn2.Index] := GetEnumName(TypeInfo(TUpdateCondition), Integer(LocalFile.Condition));
          Values[LFileIndex, cxGLocalFilesTableViewColumn3.Index] := ExtractRelativePath(ExtractFilePath(FActiveUpdateFileCollectionItem.LibraryFile), LocalFile.FileName);
          Values[LFileIndex, cxGLocalFilesTableViewColumn4.Index] := FileVersion.ToString;
          // Values[LFileIndex, cxGLocalFilesTableViewColumn5.Index] := GetEnumName(TypeInfo(TUpdateAction), Integer(LocalFile.Action));
          // Values[LFileIndex, cxGLocalFilesTableViewColumn6.Index] := ActionsToStr(LocalFile.Actions);
        end;
    finally
      EndUpdate;
    end;
  end;

  Result := LStatus;
end;

function TfMain.LoadUpdateFilesList: Boolean;
begin
  //
end;

procedure TfMain.SaveFilesList;
begin

end;

procedure TfMain.MakeUpdate;
begin

end;

end.
