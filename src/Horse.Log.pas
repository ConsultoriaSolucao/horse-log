unit Horse.Log;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  SysUtils, Classes, HTTPDefs, fpjson, jsonparser,
  {$ELSE}
  System.Classes, System.JSON, System.SysUtils, Web.HTTPApp,
  {$ENDIF}
  Horse, Horse.Commons;

function Log: THorseCallback; overload;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)}TNextProc{$ELSE}TProc{$ENDIF});

implementation

uses
  Modelo.Log;

function Log: THorseCallback; overload;
begin
  Result := Middleware;
end;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)}TNextProc{$ELSE}TProc{$ENDIF});
var
  aNr_cpfcnpj, aNm_unit: string;
begin
  aNr_cpfcnpj := '';
  aNm_unit := '';

  try
    Next;
  finally
    if Req.Params.ContainsKey('___nm_unit') then
    begin
      aNm_unit := Req.Params.Field('___nm_unit').AsString;
      Req.Params.Dictionary.Remove('___nm_unit');
    end;

    if Req.Params.ContainsKey('___nr_cpfcnpj') then
    begin
      aNr_cpfcnpj := Req.Params.Field('___nr_cpfcnpj').AsString;
      Req.Params.Dictionary.Remove('___nr_cpfcnpj');
    end;

    TModeloLog.New //
      .Nr_cpfcnpj(aNr_cpfcnpj) //
      .Nm_unit(aNm_unit) //
      .Request(Req) //
      .Response(Res) //
      .RegistraLog;
  end;
end;

end.
