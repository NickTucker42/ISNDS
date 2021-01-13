unit NTADS2Reg;

interface
uses
{$IF CompilerVersion >= 23}    //XE2 and higher
 System.Classes,
{$ELSE}
 Classes,
{$IFEND}
 NTADS2,ActiveDS_TLB2,NTDSBrowser2;

Procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('NTADS2', [TNTADS2]);

  RegisterComponents('NTADS2', [TNTDSBrowser2]);

  RegisterComponents('NTADS2', [TPropertyEntry, TPropertyValue, TAccessControlEntry, TAccessControlList,
    TSecurityDescriptor, TLargeInteger, TNameTranslate, TCaseIgnoreList, TFaxNumber,
    TNetAddress, TOctetList, TEmail, TPath, TReplicaPointer,
    TTimestamp, TPostalAddress, TBackLink, TTypedName, THold,
    TPathname, TADSystemInfo, TWinNTSystemInfo, TDNWithBinary, TDNWithString,
    TADsSecurityUtility]);

end;

end.
