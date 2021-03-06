unit uDdlwOrg;

interface

uses
  // Delphi
  Windows, SysUtils, Classes, StrUtils, HTTPApp,
  // HTTPManager
  uHTTPInterface, uHTTPClasses,
  // Plugin system
  uPlugInInterface, uPlugInImageHosterClass, uPlugInHTTPClasses, uPlugInConst;

type
  TDdlwOrg = class(TImageHosterPlugIn)
  protected { . }
  const
    WEBSITE: string = 'http://ddlw.org/';
    function Upload(const AImageHosterData: IImageHosterData; const AHTTPParams: IHTTPParams; out AImageUrl: WideString): Boolean;
  public
    function GetAuthor: WideString; override;
    function GetAuthorURL: WideString; override;
    function GetDescription: WideString; override;
    function GetName: WideString; override;

    function AddLocalImage(const AImageHosterData: IImageHosterData; const ALocalPath: WideString; out AUrl: WideString): WordBool; override;
    function AddWebImage(const AImageHosterData: IImageHosterData; const ARemoteUrl: WideString; out AUrl: WideString): WordBool; override;
  end;

implementation

{ TDdlwOrg }

function TDdlwOrg.Upload;
var
  LHTTPRequest: IHTTPRequest;
  LHTTPOptions: IHTTPOptions;

  LRequestID: Double;
  LHTTPProcess: IHTTPProcess;
begin
  Result := False;
  AImageUrl := '';

  LHTTPRequest := THTTPRequest.Create(WEBSITE + 'upload.py');
  with LHTTPRequest do
  begin
    Referer := WEBSITE;
  end;

  with AHTTPParams do
  begin
    if not(AImageHosterData.ImageHostResize = irNone) then
    begin
      case AImageHosterData.ImageHostResize of
        ir320x240:
          AddFormField('imgsize', '240');
        ir450x338:
          AddFormField('imgsize', '338');
        ir640x480:
          AddFormField('imgsize', '480');
        ir800x600:
          AddFormField('imgsize', '600');
      end;

    end
    else
      AddFormField('imgsize', 'original');
  end;

  LHTTPOptions := TPlugInHTTPOptions.Create(Self);
  with LHTTPOptions do
  begin
    HandleSketchyRedirects := False;
    RedirectMaximum := 0;
  end;

  LRequestID := HTTPManager.Post(LHTTPRequest, AHTTPParams, LHTTPOptions);

  HTTPManager.WaitFor(LRequestID);

  LHTTPProcess := HTTPManager.GetResult(LRequestID);

  if (Pos('/img/', string(LHTTPProcess.HTTPResult.HTTPResponse.Location)) > 0) then
  begin
    AImageUrl := LHTTPProcess.HTTPResult.HTTPResponse.Location;
    Result := True;
  end
  else if LHTTPProcess.HTTPResult.HasError then
  begin
    ErrorMsg := LHTTPProcess.HTTPResult.HTTPResponseInfo.ErrorMessage;
  end
  else
  begin
    ErrorMsg := LHTTPProcess.HTTPResult.SourceCode;
  end;
end;

function TDdlwOrg.GetAuthor;
begin
  Result := 'Sebastian Klatte';
end;

function TDdlwOrg.GetAuthorURL;
begin
  Result := 'http://www.intelligen2009.com/';
end;

function TDdlwOrg.GetDescription;
begin
  Result := GetName + ' image hoster plug-in.';
end;

function TDdlwOrg.GetName: WideString;
begin
  Result := 'Ddlw.org';
end;

function TDdlwOrg.AddLocalImage;
var
  LHTTPParams: IHTTPParams;
begin
  Result := False;

  LHTTPParams := THTTPParams.Create;
  with LHTTPParams do
    AddFile('file', ALocalPath);

  Result := Upload(AImageHosterData, LHTTPParams, AUrl);
end;

function TDdlwOrg.AddWebImage;
var
  LHTTPParams: IHTTPParams;
begin
  Result := False;

  LHTTPParams := THTTPParams.Create;
  with LHTTPParams do
    AddFormField('url', ARemoteUrl);

  Result := Upload(AImageHosterData, LHTTPParams, AUrl);
end;

end.
