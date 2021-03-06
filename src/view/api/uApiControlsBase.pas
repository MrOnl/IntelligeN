unit uApiControlsBase;

interface

uses
  // Delphi
  Windows, SysUtils,
  // Common
  uBaseConst, uBaseInterface;

type
  TIValueItem = class(TInterfacedObject, IValueItem)
  private
    FValue: WideString;
  protected
    function GetValue: WideString; virtual; safecall;
    procedure SetValue(const AValue: WideString); virtual; safecall;
  public
    constructor Create(const AValue: WideString); virtual;
    constructor Clone(const AValueItem: IValueItem);
    destructor Destroy; override;

    property Value: WideString read GetValue write SetValue;
  end;

  TIControlData = class(TIValueItem, IControlData)
  private
    FControlID: TControlID;
  protected
    function GetControlID: TControlID; safecall;
    procedure SetControlID(AControlID: TControlID); safecall;
  public
    constructor Create(AControlID: TControlID; const AValue: WideString = '');
    constructor Clone(const AControlData: IControlData);
    destructor Destroy; override;

    property ControlID: TControlID read GetControlID write SetControlID;
  end;

  TIControlBase = class(TIControlData, IControlBase)
  protected
    FValueArray: array of array of string;

    procedure ResetValueArray;

    function GetProposedValuesCount: Integer; safecall;
  public
    constructor Create(AControlID: TControlID; const AValue: WideString = '');
    constructor Clone(const AControlBase: IControlBase);
    destructor Destroy; override;

    procedure AddProposedValue(const ASender: WideString; const AValue: WideString; const ATitle: WideString = ''); virtual; safecall;
    function GetProposedValue(const AIndex: Integer): WideString; safecall;
    function GetProposedValueSender(const AIndex: Integer): WideString; safecall;
    function GetProposedValueTitle(const AIndex: Integer): WideString; safecall;
    procedure UpdateValueFromProposedValue; safecall;

    property ProposedValuesCount: Integer read GetProposedValuesCount;
  end;

implementation

{ TIValueItem }

function TIValueItem.GetValue: WideString;
begin
  Result := FValue;
end;

procedure TIValueItem.SetValue(const AValue: WideString);
begin
  FValue := AValue;
end;

constructor TIValueItem.Create(const AValue: WideString);
begin
  inherited Create;
  FValue := AValue;
end;

constructor TIValueItem.Clone(const AValueItem: IValueItem);
begin
  Create(AValueItem.Value);
end;

destructor TIValueItem.Destroy;
begin
  inherited Destroy;
end;

{ TIControlData }

function TIControlData.GetControlID: TControlID;
begin
  Result := FControlID;
end;

procedure TIControlData.SetControlID(AControlID: TControlID);
begin
  FControlID := AControlID;
end;

constructor TIControlData.Create(AControlID: TControlID; const AValue: WideString = '');
begin
  inherited Create(AValue);
  FControlID := AControlID;
end;

constructor TIControlData.Clone(const AControlData: IControlData);
begin
  Create(AControlData.ControlID, AControlData.Value);
end;

destructor TIControlData.Destroy;
begin
  inherited Destroy;
end;

{ TIControlBase }

procedure TIControlBase.ResetValueArray;
var
  LIndex: Integer;
begin
  for LIndex := GetProposedValuesCount - 1 downto 0 do
    SetLength(FValueArray[LIndex], 0);
  SetLength(FValueArray, 0);
end;

function TIControlBase.GetProposedValuesCount: Integer;
begin
  Result := length(FValueArray);
end;

procedure TIControlBase.AddProposedValue(const ASender: WideString; const AValue: WideString; const ATitle: WideString = '');
var
  LNewIndex: Integer;
begin
  SetLength(FValueArray, length(FValueArray) + 1, 3);

  LNewIndex := GetProposedValuesCount - 1;

  FValueArray[LNewIndex][0] := ASender;
  FValueArray[LNewIndex][1] := AValue;
  FValueArray[LNewIndex][2] := ATitle;
end;

function TIControlBase.GetProposedValue(const AIndex: Integer): WideString;
begin
  Result := FValueArray[AIndex][1];
end;

function TIControlBase.GetProposedValueSender(const AIndex: Integer): WideString;
begin
  Result := FValueArray[AIndex][0];
end;

function TIControlBase.GetProposedValueTitle(const AIndex: Integer): WideString;
begin
  Result := FValueArray[AIndex][2];
end;

procedure TIControlBase.UpdateValueFromProposedValue;
var
  LFormatSettings: TFormatSettings;
  LProposedValueIndex: Integer;
begin
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, LFormatSettings);

  if ProposedValuesCount > 0 then
  begin
    LProposedValueIndex := 0;
    while (LProposedValueIndex < ProposedValuesCount) and (SameStr('', Value) or ((ControlID = cReleaseDate) and (Value = DateToStr(Date, LFormatSettings)))) do
    begin
      Value := GetProposedValue(LProposedValueIndex);
      Inc(LProposedValueIndex);
    end;
  end;
end;

constructor TIControlBase.Create(AControlID: TControlID; const AValue: WideString);
begin
  inherited Create(AControlID, AValue);
  SetLength(FValueArray, 0);
end;

constructor TIControlBase.Clone(const AControlBase: IControlBase);
var
  LIndex: Integer;
begin
  Create(AControlBase.ControlID, AControlBase.Value);

  for LIndex := 0 to AControlBase.ProposedValuesCount - 1 do
    AddProposedValue(AControlBase.GetProposedValueSender(LIndex), AControlBase.GetProposedValue(LIndex), AControlBase.GetProposedValueTitle(LIndex));
end;

destructor TIControlBase.Destroy;
begin
  ResetValueArray;
  inherited Destroy;
end;

end.
