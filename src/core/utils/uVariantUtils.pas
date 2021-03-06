unit uVariantUtils;

interface

uses
  // Delphi
  Windows, SysUtils, Variants;

function HasUsefulValue(AValue: Variant): Boolean;

function VarToBoolDef(const V: Variant; const ADefault: Boolean): Boolean;
function VarToIntDef(const V: Variant; const ADefault: Integer): Integer;
function VarToInt64Def(const V: Variant; const ADefault: Int64): Int64;
function VarToFloatDef(const V: Variant; const ADefault: Extended): Extended; overload;
function VarToFloatDef(const V: Variant; const ADefault: Extended; const FormatSettings: TFormatSettings): Extended; overload;
function VarToFloatDefault(const V: Variant; const ADefault: Extended; ADotAsDecimalSeparator: Boolean = True): Extended;

implementation

function HasUsefulValue(AValue: Variant): Boolean;
begin
  case VarType(AValue) of
    varSmallInt, varInteger, varSingle, varDouble, varCurrency, varShortInt, varByte, varWord, varLongWord, varInt64, varUInt64:
      Result := (AValue > 0);
    varBoolean:
      Result := not(AValue = 0);
    varOleStr, varVariant, varStrArg, varString, varUString:
      Result := not(SameStr('', AValue));
  else
    Result := False;
  end;
end;

function VarToBoolDef(const V: Variant; const ADefault: Boolean): Boolean;
begin
  if not VarIsNull(V) then
    Result := StrToBoolDef(V, ADefault)
  else
    Result := ADefault;
end;

function VarToIntDef(const V: Variant; const ADefault: Integer): Integer;
begin
  if not VarIsNull(V) then
    Result := StrToIntDef(V, ADefault)
  else
    Result := ADefault;
end;

function VarToInt64Def(const V: Variant; const ADefault: Int64): Int64;
begin
  if not VarIsNull(V) then
    Result := StrToInt64Def(V, ADefault)
  else
    Result := ADefault;
end;

function VarToFloatDef(const V: Variant; const ADefault: Extended): Extended;
var
  LFormatSettings: TFormatSettings;
begin
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, LFormatSettings);

  Result := VarToFloatDef(V, ADefault, LFormatSettings);
end;

function VarToFloatDef(const V: Variant; const ADefault: Extended; const FormatSettings: TFormatSettings): Extended;
begin
  if not VarIsNull(V) then
    Result := StrToFloatDef(V, ADefault, FormatSettings)
  else
    Result := ADefault;
end;

function VarToFloatDefault(const V: Variant; const ADefault: Extended; ADotAsDecimalSeparator: Boolean): Extended;
var
  LFormatSettings: TFormatSettings;
begin
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, LFormatSettings);

  if ADotAsDecimalSeparator then
    LFormatSettings.DecimalSeparator := '.'
  else
    LFormatSettings.DecimalSeparator := ',';

  Result := VarToFloatDef(V, ADefault, LFormatSettings);
end;

end.
