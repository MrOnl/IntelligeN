unit u%FullName%;

interface

uses
  // Delphi
  Windows, SysUtils, Classes, StrUtils, HTTPApp,
  // DEC
  DECFmt,
  // RegEx
  RegExpr,
  // HTTPManager
  uHTTPInterface, uHTTPClasses,
  // Plugin system
  uPlugInInterface, uPlugInImageHosterClass, uPlugInHTTPClasses, uPlugInConst,
  // Utils
  uHTMLUtils;

type
  T%FullName% = class(TImageHosterPlugIn)
  protected { . }
  const
    WEBSITE = '%Website%';
	
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

{ T%FullName% }

function T%FullName%.Upload;
var
  LHTTPRequest: IHTTPRequest;
  LHTTPOptions: IHTTPOptions;

  LRequestID: Double;
  LHTTPProcess: IHTTPProcess;
begin
  Result := False;
  AImageUrl := '';

  LHTTPRequest := THTTPRequest.Create(WEBSITE);
  with LHTTPRequest do
  begin
    LHTTPRequest.Referer := WEBSITE;
  end;

  with AHTTPParams do
  begin
    AddFormField('param1', 'value1');
	
	{ TODO : add general upload params }

    if not(AImageHosterData.ImageHostResize = irNone) then
    begin
      { TODO : update resize params }

	    case AImageHosterData.ImageHostResize of
        ir320x240:
          AddFormField('imageSize', '320_240');
        ir450x338:
          AddFormField('imageSize', '450_338');
        ir640x480:
          AddFormField('imageSize', '640_480');
        ir800x600:
          AddFormField('imageSize', '800_600');
      end;

    end
    else
	  begin
      AddFormField('imageSize', '1');
	  end;
  end;

  LHTTPOptions := TPlugInHTTPOptions.Create(Self);
  with LHTTPOptions do
  begin
  
  end;

  LRequestID := HTTPManager.Post(LHTTPRequest, AHTTPParams, LHTTPOptions);

  HTTPManager.WaitFor(LRequestID);

  LHTTPProcess := HTTPManager.GetResult(LRequestID);

  { TODO : update identifier }
  if (Pos('identifier that the upload was successful', string(LHTTPProcess.HTTPResult.SourceCode)) > 0) then
  begin

    with TRegExpr.Create do
      try
		    InputString := string(LHTTPProcess.HTTPResult.SourceCode);
        { TODO : update regular expression that matches the uploaded directlink }
		    Expression := 'expression to get image url';

        if Exec(InputString) then
        begin
          AImageUrl := Match[1];
          Result := True;
        end;
      finally
        Free;
      end;

  end
  else if LHTTPProcess.HTTPResult.HasError then
  begin
    ErrorMsg := LHTTPProcess.HTTPResult.HTTPResponseInfo.ErrorMessage;
  end
  else
  begin
    with TRegExpr.Create do
      try
		    InputString := string(LHTTPProcess.HTTPResult.SourceCode);
        { TODO : update regular expression that matches the error message if upload fails }
		    Expression := 'Expression to get error message';

        if Exec(InputString) then
        begin
          Self.ErrorMsg := HTML2Text(Match[1]);
        end;
      finally
        Free;
      end;
  end;
end;

function T%FullName%.GetAuthor;
begin
  Result := '%CompanyName%';
end;

function T%FullName%.GetAuthorURL;
begin
  Result := 'http://example.com/';
end;

function T%FullName%.GetDescription;
begin
  Result := GetName + ' image hoster plug-in.';
end;

function T%FullName%.GetName;
begin
  Result := '%FullName%';
end;

function T%FullName%.AddLocalImage;
var
  LHTTPParams: IHTTPParams;
begin
  Result := False;

  LHTTPParams := THTTPParams.Create;
  with LHTTPParams do
  begin
    { TODO : add specific local upload params }
  end;

  Result := Upload(AImageHosterData, LHTTPParams, AUrl);
end;

function T%FullName%.AddWebImage;
var
  LHTTPParams: IHTTPParams;
begin
  Result := False;

  LHTTPParams := THTTPParams.Create;
  with LHTTPParams do
  begin
    { TODO : add specific remote upload params }
  end;

  Result := Upload(AImageHosterData, LHTTPParams, AUrl);
end;

end.
