library %BasicName%;

{$R *.dres}

uses
  uPlugInInterface,
  uPlugInImageHosterClass,
  u%FullName% in 'u%FullName%.pas';

{$R *.res}

function LoadPlugin(var APlugIn: IImageHosterPlugIn): WordBool; safecall; export;
begin
  try
    APlugIn := T%FullName%.Create;
    Result := True;
  except
    Result := False;
  end;
end;

exports
  LoadPlugIn name 'LoadPlugIn';

begin
end.
