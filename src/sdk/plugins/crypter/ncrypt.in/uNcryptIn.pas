unit uNcryptIn;

interface

uses
  // Delphi
  Windows, SysUtils, StrUtils, Math,
  // RegEx
  RegExpr,
  // Common
  uBaseConst, uBaseInterface,
  // HTTPManager
  uHTTPInterface, uHTTPClasses,
  // plugin system
  uPlugInInterface, uPlugInCrypterClass, uPlugInHTTPClasses, uPlugInConst;

type
  TNcryptIn = class(TCrypterPlugIn)
  protected { . }
  const
    WEBSITE = 'http://ncrypt.in/';
  public
    function GetAuthor: WideString; override;
    function GetAuthorURL: WideString; override;
    function GetDescription: WideString; override;
    function GetName: WideString; override;

    function GetServiceRequiresAccess: TCrypterAccess; override;

    function AddFolder(const ACrypterData: ICrypterData; const AMirrorContainer: IDirectlinkContainer; out ACrypterFolderInfo: TCrypterFolderInfo): WordBool; override;
    function EditFolder(const ACrypterData: ICrypterData; const AMirrorContainer: IDirectlinkContainer; var ACrypterFolderInfo: TCrypterFolderInfo): WordBool; override;
    function DeleteFolder(const AAccountData: IAccountData; const AFolderIdentifier: WideString): WordBool; override;
    function GetFolder(const AAccountData: IAccountData; const AFolderIdentifier: WideString; out ACrypterFolderInfo: TCrypterFolderInfo): WordBool; override;
  end;

implementation

{ TNcryptIn }

function TNcryptIn.GetAuthor;
begin
  Result := 'Sebastian Klatte';
end;

function TNcryptIn.GetAuthorURL;
begin
  Result := 'http://www.intelligen2009.com/';
end;

function TNcryptIn.GetDescription;
begin
  Result := GetName + ' crypter plug-in.';
end;

function TNcryptIn.GetName;
begin
  Result := 'nCrypt.in';
end;

function TNcryptIn.GetServiceRequiresAccess;
begin
  Result := caNone;
end;

function TNcryptIn.AddFolder;
var
  LFoldertypes: TFoldertypes;
  LContainertypes: TContainertypes;

  LDirectlinkIndex: Integer;

  LHTTPParams: IHTTPParams;
  LRequestID: Double;
  LHTTPProcess: IHTTPProcess;
begin
  Result := False;

  with ACrypterFolderInfo do
  begin
    Link := '';
    Status := csNotChecked;
    Size := 0;
    PartSize := 0;
    Hoster := '';
    HosterShort := '';
    Parts := 0;
    StatusImage := '';
    StatusImageText := '';
  end;

  LFoldertypes := TFoldertypes(TFoldertype(ACrypterData.Foldertypes));
  LContainertypes := TContainertypes(TContainertype(ACrypterData.ContainerTypes));

  LHTTPParams := THTTPParams.Create;
  with LHTTPParams do
  begin
    if ACrypterData.UseAccount then
      AddFormField('auth_code', ACrypterData.AccountName);

    AddFormField('foldername', ACrypterData.FolderName);

    AddFormField('links', AMirrorContainer.Directlink[0].Value);

    for LDirectlinkIndex := 1 to AMirrorContainer.DirectlinkCount - 1 do
      AddFormField('mirror[]', AMirrorContainer.Directlink[LDirectlinkIndex].Value);

    AddFormField('show_mirrors', '0');

    AddFormField('show_links', IfThen(ftWeb in LFoldertypes, '1', '0'));

    AddFormField('show_container', IfThen(ftContainer in LFoldertypes, '1', '0'));

    if ftContainer in LFoldertypes then
    begin
      AddFormField('ccf', IfThen(ctCCF in LContainertypes, '1', '0'));

      AddFormField('dlc', IfThen(ctDLC in LContainertypes, '1', '0'));

      AddFormField('rsdf', IfThen(ctRSDF in LContainertypes, '1', '0'));
    end;

    AddFormField('cnl', IfThen(ACrypterData.UseCNL, '1', '0'));

    AddFormField('captcha', IfThen(ACrypterData.UseCaptcha, '1', '0'));

    if ACrypterData.UseVisitorPassword then
      AddFormField('password', ACrypterData.Visitorpassword);

    if ACrypterData.UseDescription then
      AddFormField('description', ACrypterData.Description);

    if ACrypterData.UseCoverLink then
      AddFormField('image', ACrypterData.CoverLink);

    if ACrypterData.UseEMailforStatusNotice then
    begin
      AddFormField('notify_adress', ACrypterData.EMailforStatusNotice);
    end;
  end;

  LRequestID := HTTPManager.Post(THTTPRequest.Create(website + 'api.php'), LHTTPParams, TPlugInHTTPOptions.Create(Self));

  HTTPManager.WaitFor(LRequestID);

  LHTTPProcess := HTTPManager.GetResult(LRequestID);

  if LHTTPProcess.HTTPResult.HasError then
  begin
    ErrorMsg := LHTTPProcess.HTTPResult.HTTPResponseInfo.ErrorMessage;
  end
  else if not(Pos('ncrypt.in', string(LHTTPProcess.HTTPResult.SourceCode)) = 0) then
  begin
    ACrypterFolderInfo.Link := copy(LHTTPProcess.HTTPResult.SourceCode, 1, Pos(#$A, LHTTPProcess.HTTPResult.SourceCode) - 1);
    ACrypterFolderInfo.StatusImage := copy(LHTTPProcess.HTTPResult.SourceCode, Pos(#$A, LHTTPProcess.HTTPResult.SourceCode));
    Result := True;
  end
  else
  begin
    ErrorMsg := LHTTPProcess.HTTPResult.SourceCode;
  end;
end;

function TNcryptIn.EditFolder;
begin
  //
end;

function TNcryptIn.DeleteFolder;
begin
  //
end;

function TNcryptIn.GetFolder;
var
  LHTTPParams: IHTTPParams;
  LRequestID: Double;
  LHTTPProcess: IHTTPProcess;
begin
  Result := False;

  with ACrypterFolderInfo do
  begin
    Status := csNotChecked;
    Size := 0;
    PartSize := 0;
    Hoster := '';
    HosterShort := '';
    Parts := 0;
    StatusImage := '';
    StatusImageText := '';
  end;

  LHTTPParams := THTTPParams.Create;
  with LHTTPParams do
  begin
    AddFormField('link', AFolderIdentifier);
  end;

  LRequestID := HTTPManager.Post(THTTPRequest.Create(website + 'api_status.php'), LHTTPParams, TPlugInHTTPOptions.Create(Self));

  HTTPManager.WaitFor(LRequestID);

  LHTTPProcess := HTTPManager.GetResult(LRequestID);

  if LHTTPProcess.HTTPResult.HasError then
  begin
    ErrorMsg := LHTTPProcess.HTTPResult.HTTPResponseInfo.ErrorMessage;
  end
  else
  begin
    with TRegExpr.Create do
      try
        InputString := LHTTPProcess.HTTPResult.SourceCode;
        Expression := '(.*?);(.*?);(\d+);(\d+)';

        if Exec(InputString) then
        begin

          case IndexText(Match[1], ['online', 'unknown', 'offline', 'unchecked', 'partly_online_offline', 'partly_online_unknown', 'partly_offline_unknown']) of
            0:
              ACrypterFolderInfo.Status := csOnline;
            1:
              ACrypterFolderInfo.Status := csUnknown;
            2:
              ACrypterFolderInfo.Status := csOffline;
            3:
              ACrypterFolderInfo.Status := csUnknown;
            4:
              ACrypterFolderInfo.Status := csMixedOnOffline;
            5:
              ACrypterFolderInfo.Status := csTemporaryOffline;
          else
            ACrypterFolderInfo.Status := csUnknown;
          end;

          ACrypterFolderInfo.Size := RoundTo((StrToInt64(Match[3]) / 1048576), -2);
          ACrypterFolderInfo.Hoster := Match[2];
          ACrypterFolderInfo.Parts := StrToIntDef(Match[4], 0);

          Result := True;
        end
        else
        begin
          Self.ErrorMsg := LHTTPProcess.HTTPResult.SourceCode;
        end;
      finally
        Free;
      end;
  end;
end;

end.
