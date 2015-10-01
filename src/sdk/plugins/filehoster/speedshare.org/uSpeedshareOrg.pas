{ ********************************************************
  *                                                      *
  *  Speedshare.org Delphi API                           *
  *  Version 2.0.0.0                                     *
  *  Copyright (c) 2010 Sebastian Klatte                 *
  *                                                      *
  ******************************************************** }
unit uSpeedshareOrg;

interface

uses
  // Delphi
  Windows, SysUtils, Classes, Math, HTTPApp,
  // Reg Ex
  RegExpr,
  // HTTPManager
  uHTTPInterface, uHTTPClasses,
  // plugin system
  uPlugInFileHosterClass, uPlugInHTTPClasses, uPlugInConst,
  // Utils
  uPathUtils, uSizeUtils;

type
  TSpeedshareOrg = class(TFileHosterPlugIn)
  public
    function GetName: WideString; override; safecall;
    function CheckLink(AFile: WideString): TLinkInfo; override; safecall;
    // function CheckLinks(AFiles: WideString): Integer; override; safecall;
  end;

implementation

{ TSpeedshareOrg }

function TSpeedshareOrg.GetName: WideString;
begin
  Result := 'Speedshare.org';
end;

function TSpeedshareOrg.CheckLink(AFile: WideString): TLinkInfo;
var
  LinkInfo: TLinkInfo;

  RequestID: Double;

  ResponeStr: string;
begin
  with LinkInfo do
  begin
    Link := AFile;
    Status := lsUnknown;
    Size := 0;
    FileName := '';
    Checksum := '';
  end;

  RequestID := HTTPManager.Get(THTTPRequest.Create(AFile), TPlugInHTTPOptions.Create(Self));

  repeat
    sleep(50);
  until HTTPManager.HasResult(RequestID);

  ResponeStr := HTTPManager.GetResult(RequestID).HTTPResult.SourceCode;

  if (Pos('File not found', ResponeStr) > 0) then
    LinkInfo.Status := lsOffline
  else
    with TRegExpr.Create do
      try
        InputString := ResponeStr;
        Expression := '\(([\d\.]+) (\w+)\).*?Download (.*?)<\/b>';

        if Exec(InputString) then
        begin
          LinkInfo.Status := lsOnline;
          LinkInfo.Size := TSizeFormatter.SizeToByte(Match[1], Match[2]);
          LinkInfo.FileName := Match[3];
        end;
      finally
        Free;
      end;

  Result := LinkInfo;
end;

end.