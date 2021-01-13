unit NTADS2;

{
//==============================================================================
 [AUTHOR]
   Author name     = Nick Tucker
   Author e-mail   = NickTucker42@gmail.com
   Author web site = https://github.com/NickTucker42/ISNDS.git

 [TNTADS2]
   Version = V 3.3.0.0
   Copyright © 2002 - 2015 by Nick Tucker

This Source Code Form is subject to the terms of the Mozilla Public License,
v. 2.0. You can obtain one at http://mozilla.org/MPL/2.0/.

//==============================================================================
 [About]

NTADS (NTADS2) was created so I could uses Delphi to interact with Active
Directory.
This work was originally just meant for me and the code may be dirty here and
there but for the most part it does work.  I am sure there is great room for
improvement so if you have any fixes or additions please let me know instead
of keeping it to yourself :) I am more than happy to include additions into the
"official" version on my website and give you credit where credit is due.

If you do use NTADS in your applications I would certainly appreciate a mention
in your "About" dialog.

NTADS if free for use in commercial application as long as credit is given with
a link to my website.

The original component was developed with D6 and later used in D2005.  I did
update it when D2009 came out but I have not done anywork to change anything to
use some of the newer methods that D2009 or XE/2 has.

Nick Tucker
May 2012.

//==============================================================================
History:

 May 2012  V 1.5.0.0
   +  First release as "Open Source"

 March 2013 V3.0.0.0
   +  Complete rewrite.
   +  Renamed to NTADS2

 September 2013 V3.1.0.0
   +  Added 64Bit capability. 64Bit version of  ActiveDs_TLB2
      Add the folder "32Bit" to the 32 bit library path
      Add the folder "64bit" to the 64 bit library path
   +  Added IsMember.
   +  Various bug fixes.
   +  AddToGroup will check membership before adding.
   +  RemoveFromGroup will check membership before removing.
   +  Cleaned up some error codes.

  December 2013 v3.2.0.0
   +  Added some constants to some methods that use ExecuteSearch.
   +  Added an abort method for those that didn't have one.
   +  Added GetComputerSite
   +  Added GetAnyDCName
   +  Added GetDomainFunctionalLevel
   +  Added GetForestFunctionalLevel
   +  Added GetDCMaxLevel
   +  Added RootDSE settings
   +  Added GetSites
   +  Added GetDCInSite
   +  Added GetSubnets
   +  Added CreateSubnet
   +  Added GetDClist
   +  Added fQuietEnum

  Feburary 2015 V3.3.0.0
   +  Added ObjectToGuid
   +  Added GuidToObject
   +  Added NormalizeName
   ~  Fixed ChangePassword - Thanks David Wright!
   +  Added fQuietEnum to stop event firing.
   ~  Fixed LocateDCinSite
   +  Added GetObjectInfo2 that returns tObjData instead of rObjData
   +  Added GroupMember2 that returns an objectList
   ~  Fixed a few memory leaks
   !! Depreciate GetAllusers,Enumgroup,GroupMembers in favor of GroupMembers2
   +  Added IsMemberOfNested
   +  Added SecurityOnly for GroupMembers2



//==============================================================================
}

interface

uses
{$IF CompilerVersion >= 23}    //XE2 and higher
  System.SysUtils, System.Classes,system.Variants,Winapi.activeX,winapi.windows,
  system.Win.ComObj,winapi.winsock,winapi.winsock2,Generics.Collections,
{$ELSE}
  SysUtils, Classes,Variants,activex,Windows,ComObj,
{$IFEND}

 strUtils, ActiveDs_TLB2,Vcl.Dialogs;

{$WARN SYMBOL_PLATFORM OFF}
{$WARN ZERO_NIL_COMPAT OFF}

const

//===== Current ISNDS version.
 CompVer                               = '3.3.0.0';

 //Used in the Index property for some metods that use ExecuteSearch.
 srchServer                            = Maxint-1;
 srchDomains                           = Maxint-2;
 srchObjects                           = Maxint-3;
 srchSites                             = Maxint-4;
 srchSiteDCs                           = Maxint-5;
 srchSubnets                           = Maxint-6;

 ADS_NAME_INITTYPE_GC                  = 3;
 ADS_NAME_INITTYPE_DOMAIN              = 1;
 ADS_NAME_INITTYPE_SERVER              = 2;

//Functional levels
  flError                              = -1;
  fl2000                               = 0;
  fl2003i                              = 1;
  fl2003                               = 2;
  fl2008                               = 3;
  fl2008R2                             = 4;
  fl2012                               = 5;
  fl2012R2                             = 6;  //just guessing on this one.


// http://www.rlmueller.net/NameTranslateFAQ.htm
// http://msdn.microsoft.com/en-us/library/aa772267.aspx 

 ADS_NAME_TYPE_1779                    = 1;     // LDAP: Distinguished Names
 ADS_NAME_TYPE_CANONICAL               = 2;     // Mydomain.com\thisuser
 ADS_NAME_TYPE_NT4                     = 3;     // NT Format MyDomain\thisuser
 ADS_NAME_TYPE_DISPLAY                 = 4;
 ADS_NAME_TYPE_DOMAIN_SIMPLE           = 5;
 ADS_NAME_TYPE_ENTERPRISE_SIMPLE       = 6;
 ADS_NAME_TYPE_GUID                    = 7;
 ADS_NAME_TYPE_UNKNOWN                 = 8;
 ADS_NAME_TYPE_USER_PRINCIPAL_NAME     = 9;     // thisuser@mydomain.com
 ADS_NAME_TYPE_CANONICAL_EX            = 10;
 ADS_NAME_TYPE_SERVICE_PRINCIPAL_NAME  = 11;
 ADS_NAME_TYPE_SID_OR_SID_HISTORY_NAME = 12;

 GLOBAL_GROUP                          = $00000002;
 DOMAIN_LOCAL_GROUP                    = $00000004;
 LOCAL_GROUP                           = $00000004;
 UNIVERSAL_GROUP                       = $00000008;
 SECURITY_ENABLED                      = $80000000;

 DS_FORCE_REDISCOVERY                  = $00000001;
 DS_DIRECTORY_SERVICE_REQUIRED         = $00000010;
 DS_DIRECTORY_SERVICE_PREFERRED        = $00000020;
 DS_GC_SERVER_REQUIRED                 = $00000040;
 DS_PDC_REQUIRED                       = $00000080;
 DS_BACKGROUND_ONLY                    = $00000100;
 DS_IP_REQUIRED                        = $00000200;
 DS_KDC_REQUIRED                       = $00000400;
 DS_TIMESERV_REQUIRED                  = $00000800;
 DS_WRITABLE_REQUIRED                  = $00001000;
 DS_GOOD_TIMESERV_PREFERRED            = $00002000;
 DS_AVOID_SELF                         = $00004000;
 DS_ONLY_LDAP_NEEDED                   = $00008000;
 DS_IS_FLAT_NAME                       = $00010000;
 DS_IS_DNS_NAME                        = $00020000;
 DS_TRY_NEXTCLOSEST_SITE               = $00040000;
 DS_DIRECTORY_SERVICE_6_REQUIRED       = $00080000;
 DS_RETURN_DNS_NAME                    = $40000000;
 DS_RETURN_FLAT_NAME                   = $80000000;


//******   Error results *******************************************************
 ErrSuccess              = 0;

 ErrGroupCannotBeLocated = 201;

 ErrCannotOpenContainer  = dword(-2147016656);
 ErrAlreadyExists        = dword(-2147024713);
 ErrNoSuchObject         = dword(-2147024894);
 ErrAccessDenied         = dword(-2147024891);
 ErrInvalidsyntax        = dword(-2147024773);
 ErrSpecifiedName        = dword(-2147022694);
 ErrNetworkPath          = dword(-2147024843);

 errUserNotFound         = 400;

 ErrBindError            = 700;

 ErrNoAD                 = 999;
//******   Error results *******************************************************

type
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]


  PAddrInfo = ^TAddrInfo;
  TAddrInfo = packed record
    ai_flags: Integer;
    ai_family: Integer;
    ai_socktype: Integer;
    ai_protocol: Integer;
    ai_addrlen: LongWord;
    ai_canonname: Array of Char;
    ai_addr: PSOCKADDR;
    ai_next: PAddrInfo;
  end;

   tObjTypes = (  objUnknown,
                  objContainer,                //d  1       C
                  objOrganizationalUnit,       //d  2       C
                  objComputer,                 //d  3
                  objGroup,                    //d  4
                  objUser,                     //d  5
                  objPrinter,                  //d  6
                  objPrintQueue,               //d  7
                  objService,                  //d  8
                  objFileService,              //d  9
                  objFileShare,                //d  10
                  objBuiltinDomain,            //d  11     C
                  objtrustedDomain,            //d  12     C
                  objLostandFound,             //d  13     C
                  objsecret,                   //d  14
                  objDomainPolicy,             //d  15
                  objDFSConfiguration,         //d  16
                  objnTFRSSettings,            //d  17
                  objFileLinkTracking,         //d  18
                  ObjNameSpace,                //d  19
                  objinfrastructureUpdate,     //d  20    C
                  objRidManager,               //d  21
                  objrpcContainer,             //d  22
                  objSamServer,                //d  23
                  objDNSZone,                  //d  24
                  objFSecurityPrincipal,       //d  25
                  objGPolicyContainer,         //d  26
                  objdomainDNS,                //   28     C
                  ObjmsExchSystemObjectsContainer   //29   C

                  );

   rObjData = Record
                Name        : String;
                Description : String;
                Class_      : String;
                GUID        : String;
                ADsPath     : String;
                Parent      : String;
                Schema      : String;
                ClassIndex  : Integer;     //3.3
                Created     : tDateTime;
                Modified    : tDateTime;
               End;

   tObjData = class(TObject)               //3.3
                Name        : String;
                Description : String;
                Class_      : String;
                GUID        : String;
                ADsPath     : String;
                Parent      : String;
                Schema      : String;
                Data1       : string;     //3.3  Can be anything as needed
                Data2       : string;     //3.3  Can be anything as needed
                ClassIndex  : Integer;    //3.3
                Created     : tDateTime;
                Modified    : tDateTime;
               End;

type

 ADS_SEARCH_HANDLE = THandle;

 tEnumEvent = Procedure (sender : tObject ; OBJ : rObjData; Count : int64;
      Index:Integer;var Abort, Keep : boolean ) of object;
 tEnumStart = Procedure (sender : tObject;Index:Integer) of object;
 tEnumStop  = Procedure (sender : tObject;Index:Integer) of object;

 tSearchEvent = Procedure (sender : tObject ; Data,OBJClass : String;
                              Count : int64;Index:Integer) of object;
 tSearchStart = Procedure (sender : tObject;Index:Integer) of object;
 tSearchStop  = Procedure (sender : tObject;Index:Integer) of object;


 tGroup2Start = Procedure (sender : tObject) of object;                   //3.3
 tGroup2Stop  = Procedure (sender : tObject) of object;                   //3.3
 tGroup2EnumEvent = Procedure (sender : tObject ; AObject : tObjData;     //3.3
                             Index:Integer; var Abort,Keep:boolean) of object;

 //===== Depreciated ===========================================================
 tGroupStart = Procedure (sender : tObject;Index:Integer) of object;
 tGroupStop  = Procedure (sender : tObject;Index:Integer) of object;
 tGroupEnumEvent = Procedure (sender : tObject ; Objectname,
               Groupname  : String; ObjClass,index:Integer;
                                       var Abort:boolean) of object;
 //===== Depreciated ===========================================================


  tgroup = (gtGlobal,gtDomain,gtUniversal);

  tRootDSE = Class(TPersistent)
    Private
     fconfigurationNamingContext  : string;
     fcurrentTime                 : string;
     fdefaultNamingContext        : string;
     fdnsHostName                 : string;
     fdsServiceName               : string;
     fhighestCommittedUSN         : string;
     fisGlobalCatalogReady        : string;
     fisSynchronized              : string;
     fldapServiceName             : string;
     frootDomainNamingContext     : string;
     fschemaNamingContext         : string;
     fserverName                  : string;
    Public
    Published
     Property configurationNamingContext  : string read fconfigurationNamingContext;
     Property currentTime                 : string read fcurrentTime;
     Property defaultNamingContext        : string read fdefaultNamingContext;
     Property dnsHostName                 : string read fdnsHostName;
     Property dsServiceName               : string read fdsServiceName;
     Property highestCommittedUSN         : string read fhighestCommittedUSN;
     Property isGlobalCatalogReady        : string read fisGlobalCatalogReady;
     Property isSynchronized              : string read fisSynchronized;
     Property ldapServiceName             : string read fldapServiceName;
     Property rootDomainNamingContext     : String read frootDomainNamingContext;
     Property schemaNamingContext         : string read fschemaNamingContext;
     Property serverName                  : String read fserverName;
  End;

  tInfo = Class(TPersistent)
   Private
    FPDCE        : String;
    FSchema      : String;
    FForest      : String;
    FDomain      : String;
    FSDomain     : String;
    FNative      : Boolean;
    FMachine     : String;
    FUsername    : String;
    FSite        : String;

   Public
   //
   Published
    Property PDCEmulator :  String  read FPDCE     Write FPDCE     Stored false;
    Property Schema      :  String  read FSchema   write FSchema   Stored false;
    Property Domain      :  String  read FDomain   Write FDomain   Stored false;
    Property SDomain     :  String  read FSDomain  Write FSDomain  Stored false;
    Property Forest      :  String  read FForest   Write FForest   Stored false;
    Property Machine     :  String  read FMachine  Write Fmachine  Stored false;
    Property Native      :  Boolean Read FNative   Write Fnative   Stored false;
    Property Site        :  String  read FSite     Write FSite     Stored false;
    Property Username    :  String  read Fusername Write FUsername Stored false;
  End;

  tSearch = Class(TPersistent)
   Private
    FSearchPath  : String;
    FSubs        : Boolean;
    FFilter      : String;
    FCatagory    : String;
   public
   //
   Published
    Property ObjectCatagory :  String  read FCatagory    Write FCatagory;
    Property SearchPath     :  String  read FSearchPath  Write FSearchPath;
    Property SearchSubs     :  Boolean read FSubs        Write FSubs;
    Property SearchFilter   :  String  read FFilter      Write FFilter;
  End;

  tLogon = Class(TPersistent)
   Private
    Fusername     : String;
    FPassword     : String;
    FLogon        : Boolean;
   public
   //
   Published
    Property  Username  :  String  read  Fusername  write Fusername;
    Property  Password  :  String  read  FPassword  write FPassword;
    Property  Logon     :  Boolean read  FLogon     Write FLogon;
  End;

// psockaddr = ^tsockaddr;
// tsockaddr = record
//  sa_Family : Shortint;
//  sa_data   : array[0..13] of char;
// end;

//  PSocket_address = ^tSocket_address;
//  tSocket_address = record
//   SockAddr     : sockaddr;
//   SocketLength : integer;
//  end;
 //ADDED!!

 PDOMAIN_COONTROLLER_INFO = ^TDOMAIN_COONTROLLER_INFO;
 TDOMAIN_COONTROLLER_INFO = record
  DomainControllerName        : pwidechar;
  DomainControllerAddress     : pwidechar;
  DomainControllerAddressType : ULong;
  DomainGuid                  : tGUID;
  DomainName                  : pwidechar;
  DnsForestName               : pwidechar;
  Flags                       : ULong;
  DcSiteName                  : PWideChar;
  ClientSiteName              : PWideChar;
 end;



//==============================================================================
  TNTADS2 = class(TComponent)
  private
    { Private declarations }
   FRowCount     : Integer;
   FLasterror    : LongInt;
   FGRoupIndex   : Integer;

   FProvider     : String;
   FLastErrorS   : String;

   Finfo         : tInfo;
   FLogon        : tLogon;
   FSearch       : tSearch;
   FRootDSE      : tRootDSE;

   fEnumEvent    : tEnumEvent;    //Called when "Enum" found something.
   fEnumStart    : tEnumStart;
   fEnumStop     : tEnumStop;

   fSearchEvent  : tSearchEvent;  //Called when Search found something.
   fSearchStart  : tSearchStart;
   fSearchStop   : tSearchStop;

   fGroup2Start   : tGroup2Start;                        //3.3
   fGroup2Stop    : tGroup2Stop;                         //3.3
   fGroup2Enum    : tGroup2EnumEvent;                    //3.3

   fGroupStart   : tGroupStart;
   fGroupStop    : tGroupStop;
   fGroupEnum    : tGroupEnumEvent;

   fAbort        : boolean;
   fSecurityOnly : Boolean;                             //3.3

   //stops events in the EnumContainer method if true
   fQuietEnum    : Boolean;                             //3.3


   fNestedUser   : string;  //used with the procedure below.
   Procedure GroupMember2evt (sender : tObject ; AObject : tObjData;     //3.3
                             Index:Integer; var Abort,Keep:boolean);
   function My_WSAStringToAddress(sIP: string): sockaddr;


  protected
    { Protected declarations }

  public

   { Public declarations }


   Constructor Create(AOwner : tcomponent);  Override;
   Destructor Destroy;                       Override;

   //===== Depreciated ================= //3.3 =================================
   //===== Depreciated =========================================================
   Function  GetAllusers(ADSpath:string):tstringlist;
                                    [deprecated('Consider using GroupMembers2')]

   Function  Enumgroup(ADSPath:string):tstringlist;
                                    [deprecated('Consider using GroupMembers2')]

   Function  GroupMembers(ADSPath: String;Index:Integer;Recurse: Boolean
                       ): Boolean;  [deprecated('Consider using GroupMembers2')]
   //===== Depreciated =========================================================
   //===== Depreciated =========================================================


   //===== Overload methods ====================================================
   Function DeleteObject(ADSPathtoCont,OType,Name:widestring):Boolean; Overload;
   Function CreateUser(ADSPathtoCont,Name,
                                     Pre2K,Password : String):Boolean; overload;
   Function CreateGroup(ADSPathtoCont,Name,Pre2K,Description:String;
                               GType:tGroup;Security:Boolean):Boolean; Overload;
   Function  AddToGroup(ADSPathtoGroup,Name:string):Boolean;           Overload;
   function  RemoveFromGroup(ADSPathtogroup,Name:string):Boolean;      Overload;
   Function  ExecuteSearch(Var ReturnList:tStringlist;
                              Index:Integer):boolean;                  OverLoad;
   Function  EnumUser(User:IadsUser) : tStringlist;                    OverLoad;
   Function  GetObjectInfo(ADS : iADS): rObjData;                      Overload;
   Function  GetObjectInfo2(ADS : iADS): tObjData;                     Overload;

   Function  IsMember(ADSPathtoGroup,Member:string):Boolean;           Overload;

  published
    { Published declarations }

   //===== H E L P E R S =======================================================


   Function  LoadEnvironmentStrings:tStrings;
   Function  GetClassIndex(Class_ : String):tObjTypes;
   function  locateobjects(ojbClass,Filter:string;Global:boolean):tStringlist;
   Function  CorrectDomain(Domain:String):String;
   Function  ToDotname(Path:string):String;
   Function  NameTranslate(InName:String;FromType,ToType:Integer):String;
   Function  GetServerlist(ADSPath:string) : tStringlist;
   Function  GetDClist : tStringlist;                                  //3.2.0.0
   Function  GetSucureChannel(Server: string): string;                 //NEW
   Function  LocateDCinSite(Server, ADSite,Domain:String):String;      //FIXED!!
   Function  GetDomains(path:String;ShortName:boolean):tStringList;
   procedure pathtolist(path:string;var l : tstringlist);
   Function  Translateerror(Error:string):dword;
   Function  IsMember(Group:IadsGroup;Member:string):Boolean; Overload;

   function  IsMemberOfNested(Group:String;Member:string):Boolean;    //3.3

   Procedure Abort;                                                    //3.2.0.0
   Function  GetComputerSite(Computer:string):String;                  //3.2.0.0
   Function  GetAnyDCName:string;                                      //3.2.0.0
   function  GetDomainFunctionalLevel(Domain:String):Integer;          //3.2.0.0
   function  GetForestFunctionalLevel:Integer;                         //3.2.0.0
   Function  GetDCMaxLevel(DC:string):Integer;                         //3.2.0.0
   function  GetAllSites:tStringlist;                                  //3.2.0.0
   function  GetDCInSite(Site:string):tstringlist;                     //3.2.0.0
   function  GetSubnets:tStringlist;                                   //3.2.0.0
   function  CreateSubnet(Site,Subnet,
                                        Description:string):Boolean;   //3.2.0.0
   Function  Normalizename(name: string): String;                      //3.2.0.1
   Function  GuidToObject(GuidName: string): String;
   Function  ObjectToGuid(ObjectName: string): String;
   Function  GetSiteFromAddress(Computer,IPAddress:string):String;
   //ADDED

   //===== Main Methods ========================================================


   //===== Open objects =============
   Function  OpenObject(ADSPath:String; ClassType : TGUID): IUnknown;
   Function  OpenContainer(ADSPath  : String) : IADSContainer;
   Function  OpenUser(ADSPath       : String) : IADSUser;
   Function  OpenGroup(ADSPath      : String) : IADSGroup;
   Function  OpenIADS(ADSPath       : String) : IADS;

   //===== Manipulate objects =======
   Function  MoveObject(cont:iadscontainer;Name:String):Boolean;
   Function  DeleteObject(Cont:IadsContainer;
                                       OType,Name:widestring):Boolean; OverLoad;
   Function  CreateUser(Cont:IADSContainer;
                                Name,Pre2K,Password : String):Boolean; overload;
   Function  CreateGroup(Cont:IADSContainer;Name,Pre2K,Description:String;
                              GType:tGroup;Security:Boolean):Boolean; Overload;
   Function  AddToGroup(Group:iadsGroup;Name:string):Boolean;  Overload;
   function  RemoveFromGroup(Group:iadsGroup;Name:string):Boolean;  Overload;


   //Fix provided by David wright when old password = ''
   Function  ChangePassword(ADSPath,Old,New:String):Boolean;           //3.3


   //===== Misc =====================
   Function  GetClass(ADSPath:String):String;
   Function  ObjectExists(ADSPath:String):Boolean;
   Procedure GetInfo;
   Procedure GetRootDSE;                                               //3.2
   Function  GetObjectInfo(ADSPath:String): rObjData;  Overload;
   Function  GetObjectInfo2(ADSPath:String): tObjData;  Overload;      //3.3

   //===== Properties ===============
   function  GetPropertyValue(Cont:IADS;Name:string):OleVariant;
   function  GetPropertyList(ADSPath : String;Mandatory:Boolean):tStringList;

   //===== Enumerations =============
   Procedure EnumerateContainer(Cont : IADsContainer;Index:Integer;
                                                    Var ReturnList:tStringlist);
   Function  EnumUser(ADSPath:string) : tStringlist; OverLoad;
   Function  EnumUser2(ADSPath:string) : tObjectList<tObjData>;

   function  GroupMembers2(ADSPath:string;Index:Integer;Recurse:Boolean):
                                   tObjectList<tObjData>;           //3.3

   //===== Search ===================
   Function  ExecuteSearch(Index:Integer):boolean;                     OverLoad;



   //===== Properties ==========================================================
   Property Info           :  tInfo    read FInfo        Write FInfo;
   Property Logon          :  tLogon   read FLogon       Write FLogon;
   Property Search         :  tSearch  read FSearch      Write FSearch;
   Property RootDSE        :  tRootDSE read FRootDSE     write FRootDSE;

   Property Lasterror      :  LongInt  read FLasterror   Write FLastError;
   Property LasterrorS     :  String   read FLasterrors  Write FLastErrors;

   Property Provider       :  String   read FProvider    Write FProvider;

   Property QuietEnum      :  Boolean  read fQuietEnum   write FQuietEnum;
   property SecurityOnly   :  Boolean  read fSecurityOnly write fSecurityOnly;


   //===== Events ==============================================================
   Property OnEnum         : tenumevent    Read fEnumEvent    Write fEnumevent;
   Property OnEnumStart    : tEnumStart    Read fEnumStart    Write fEnumStart;
   Property OnEnumStop     : tEnumStop     Read fEnumStop     Write fEnumStop;

   Property OnSearch       : tSearchevent  Read fSearchEvent  Write fSearchevent;
   Property OnSearchStart  : tSearchStart  Read fSearchStart  Write fSearchStart;
   Property OnSearchStop   : tSearchStop   Read fSearchStop   Write fSearchStop;

   //3.3
   Property OnGroup2Start  : tGroup2Start     Read fGroup2Start Write fGroup2Start;
   Property OnGroup2Stop   : tGroup2Stop      Read fGroup2Stop  Write fGroup2Stop;
   Property OnGroup2Enum   : tGroup2EnumEvent Read fGroup2Enum  Write fGroup2Enum;

   Property OnGroupStart   : tGroupStart     Read fGroupStart Write fGroupStart;
   Property OnGroupStop    : tGroupStop      Read fGroupStop  Write fGroupStop;
   Property OnGroupEnum    : tGroupEnumEvent Read fGroupEnum  Write fGroupEnum;


  end;


//The ADsFreeEnumerator function frees an enumerator object created with the
//ADsBuildEnumerator function.
//http://msdn.microsoft.com/en-us/library/windows/desktop/aa772182%28v=vs.85%29.aspx
function ADsFreeEnumerator(pEnumVariant:IEnumVARIANT):HRESULT; safecall;
                                                      external 'activeds.dll';

//The ADsGetObject function binds to an object given its path and a specified
//interface identifier.
//http://msdn.microsoft.com/en-us/library/windows/desktop/aa772184%28v=vs.85%29.aspx
function ADsGetObject(lpszPathName: PWideChar;
                      const riid: TGUID;
                      out obj): HResult; stdcall; external 'activeds.dll';

//The ADsOpenObject function binds to an ADSI object using explicit user
//name and password credentials.ADsOpenObject is a wrapper function for
//IADsOpenDSObject and is equivalent to the IADsOpenDSObject::OpenDsObject method.
//http://msdn.microsoft.com/en-us/library/windows/desktop/aa772238%28v=vs.85%29.aspx
function ADsOpenObject(lpszPathName: PWideChar;
                       lpszUserName: PWideChar;
                       lpszPassword: PWideChar;
                       dwReserved: LongInt;
                       const riid: TIID;
                       out obj): HResult; stdcall; external 'activeds.dll';

//The DsGetDcName function returns the name of a domain controller in a
//specified domain. This function accepts additional domain controller
//selection criteria to indicate preference for a domain controller with
//particular characteristics.
//http://msdn.microsoft.com/en-us/library/windows/desktop/ms675983%28v=vs.85%29.aspx
function DsGetDcNameW (ComputerName : PWideChar;
                     DomainName   : PWideChar;
                     Guid         : pguid;
                     SiteName     : PWideChar;
                     Flags        : Integer;
                     PDC_Info     : PDOMAIN_COONTROLLER_INFO
                     ):HResult; stdcall; external 'netapi32.dll';
//    FIXED!

function NetApiBufferFree(P: Pointer): DWord; stdcall; external 'netapi32.dll';
//ADDED

Function DsAddressToSiteNamesW(Computername   : PWideChar;
                               EntryCount     : DWord;
                               SocketAddress  : PSocket_Address;
                               Var Sitenames  : PWideChar)
                               : DWord; stdcall; external 'netapi32.dll';

Function DsAddressToSiteNamesA(Computername   : PAnsiChar;
                               EntryCount     : DWord;
                               SocketAddress  : PSocket_Address;
                               Var Sitenames  : PAnsiChar)
                               : DWord; stdcall; external 'netapi32.dll';


//ADDED!

function DsGetSiteNameW(ComputerName: PWideChar; var SiteName: PWideChar)
                      : DWORD; stdcall; external 'netapi32.dll';

function getaddrinfo( const nodename: PChar;
                      const servname : PChar;
                      const hints: PAddrInfo;
                      var res: PAddrInfo): Integer; stdcall; external 'ws2_32.dll';

procedure freeaddrinfo(ai: PAddrInfo); stdcall; external 'ws2_32.dll';


//===== Forwards ===============================================================
 function ObjectGUIDtoGUID(oGUID:string):string;
 function GUIDtoObjectGUID(GUID:string):string;
 Procedure ClearEnumList(var List:tStringlist);


implementation


//==============================================================================
//==============================================================================
Constructor TNTADS2.Create;
Begin
 inherited Create(aowner);
 FRowCount     := 100;
 FProvider     := 'LDAP://';
 fSecurityOnly := True;
 FInfo         := tInfo.Create;
 FSearch       := tSearch.Create;
 FLogon        := tLogon.Create;
 FRootDSE      := TRootDSE.Create;
 FLogon.FLogon := False;
 GetInfo;
 GetRootDSE;
end;

Destructor TNTAds2.Destroy;
Begin
 FInfo.Free;
 FSearch.Free;
 FLogon.Free;
 FRootDSE.Free;
 Inherited Destroy;
end;
//==============================================================================
//==============================================================================


//=====  H E L P E R S =========================================================

// Convert between DN naming and a GUID
Function TNTADS2.ObjectToGuid(ObjectName:string):String;
begin
 Result := self.NameTranslate(Objectname,ADS_NAME_TYPE_1779,ADS_NAME_TYPE_GUID);
end;

// and the reverse.
Function TNTADS2.GuidToObject(GuidName:string):String;
begin
 Result := self.NameTranslate(GuidName,ADS_NAME_TYPE_GUID,ADS_NAME_TYPE_1779);
end;


//===== Convert a name to a type 1779 name
// Can accept an NT4, UPN or 1779 amd return the 1779
function TNTADS2.Normalizename(name: string): String;
begin
 if pos('\',name) > 0 then
  result := self.NameTranslate(name,ADS_NAME_TYPE_NT4,ADS_NAME_TYPE_1779)
 else

 if pos('@',name) > 0 then
  result := self.NameTranslate(name,ADS_NAME_TYPE_USER_PRINCIPAL_NAME,
                                                           ADS_NAME_TYPE_1779)
 else
 result := name;
end;

procedure TNTADS2.pathtolist(path:string;var l : tstringlist);  //2.0.0.8
//var // Forest : string;
//     domain : String;
Begin
 l.Clear;

 //Remove the forest
 delete(path,length(path)-Length(self.Info.Forest),maxint);

 repeat
  l.Add( copy(path,1,pos(',',path)-1));
  delete(path,1,pos(',',path));
 until (pos(',',path) = 0) or (length(path) =0);

 l.Add(path);
 l.Add(self.Info.Forest);
End;


Procedure ClearEnumList(var List:tStringlist);
var i : integer;
Begin
 for I := 0 to list.Count - 1 do
  if list.Objects[i] <> nil then list.Objects[i].Free;

 list.Clear;
End;


function ObjectGUIDtoGUID(oGUID:string):string;
var ts  : string;
    t1  : string;
    t2  : string;
    t3  : string;

    function reversebytes(inn:String):string;
    var    i : integer;
    begin
     result := '';
     i := 1;
     while I <= length(inn) do
     Begin
      result := copy(inn,i,2) + result;
      inc(i,2);
     End;

    end;

begin
// in  8575B94A 08B9 1247  BDB7 D700FB1F9005
// out 4AB97585 B908 4712  BDB7 D700FB1F9005

//Dirty but works . .

 while pos('-',oguid) > 0 do delete(oGuid,pos('-',oGuid),1);

 ts := copy(oGuid,1,16);  //get the first 8
 t1 := copy(oGuid,1,8);
 t1 := reversebytes(t1);

 t2 := copy(oGuid,9,4);
 t2 := reversebytes(t2);

 t3 := copy(oGuid,13,4);
 t3 := reversebytes(t3);

 result := t1+'-'+t2+'-'+t3+'-'+copy(oguid,17,maxint);
 insert('-',result,24);

end;

function GUIDtoObjectGUID(GUID:string):string;
var ts : string;
begin
 ts := ObjectGUIDtoGUID(Guid);
 while pos('-',ts) > 0 do delete(ts,pos('-',ts),1);
 result := ts;
end;

Function TNTADS2.NameTranslate(InName:String;FromType,ToType:Integer):String;
var nt : TNameTranslate;
Begin
 self.FLasterror  := 0;
 self.FLastErrorS := '';

 InName := replacestr(InName,'/','\');

 nt := TNameTranslate.Create(nil);
 try
  nt.Init(ADS_NAME_INITTYPE_GC,'');
  Result := '';
  nt.Set_(FromType,InName);
  result := nt.Get(ToType);
 except
  on e : exception do
  Begin
   self.FLasterror  := getLastError;
   self.FLastErrorS := e.Message;
  End;
 end;
 nt.Free;
End;

//===== Get the environemnatl strings ==========================================
Function TNTADS2.LoadEnvironmentStrings:tStrings;
var AllStrings, CurrentString: PChar;
begin
 Result := TStrings.Create;
 AllStrings := GetEnvironmentStrings;
 try
  if AllStrings <> nil then
  begin
   CurrentString := AllStrings;
   while True do
   begin
    result.Add(StrPas(CurrentString));
    Inc(CurrentString, Succ(StrLen(CurrentString)));
    if CurrentString[0] = #0 then Break;
   end;
  end;
 finally
  FreeEnvironmentStrings(AllStrings);
 end;
end;
//==============================================================================



//===== Get a server list ======================================================
Function TNTADS2.GetServerlist(ADSPath:string) : tStringlist;
Begin
 result := tstringlist.Create;
 self.Search.FCatagory   := 'Computer';
 self.Search.FSearchPath  := ADSpath;
 Self.Search.FFilter      := 'operatingsystem=*server*';
 Self.Search.FSubs        := true;
 executesearch(Result, srchServer);                                    //3.2.0.0
end;


function TNTADS2.My_WSAStringToAddress(sIP : string): sockaddr;
var
   WSAData  : TWSAData;
   Rtn      : Integer;
   PBuf     : SOCKADDR;
   BufLen   : integer;
begin

  if WSAStartup($0202, WSAData) = 0 then
  begin
    BufLen := 64;
    PBuf.sa_family := AF_INET;
    Rtn := WSAStringToAddress( PWideChar( sIP ), AF_INET, nil, PBuf, BufLen);
     if (Rtn <> SOCKET_ERROR) then
       Result := PBuf;
    WSACleanup;
 end;

end;

function TNTADS2.GetSiteFromAddress(Computer, IPAddress: string): String;
var res       : PChar;
    ret       : dword;
    Sock      : SOCKET_ADDRESS;// array[0..0] of SOCKET_ADDRESS;
    s         : LPSOCKADDR;
    ss        : sockaddr;

begin
 //CN=NTDS Settings,CN=GLUSEH-SP420006,CN=Servers,CN=USEH-P,CN=Sites,CN=Configuration,DC=novartis,DC=net
 if Trim(Computer) = '' then  //Get the PDCe for the current domain
 Begin
  Computer := Self.Info.PDCEmulator;
  Computer := Copy(Computer,Pos(',',Computer)+1,255);
  Computer := Copy(Computer,1,Pos(',',Computer)-1);
  Delete(Computer,1,3);
 End;

 ss := My_WSAStringToAddress(IPAddress);

 res := #0;
 FillChar(Sock,SizeOf(sock),#0);

 Sock.lpSockaddr      := @ss;
 Sock.iSockaddrLength := SizeOf(ss);

 ret := DsAddressToSiteNamesW(PChar(Computer),1,@Sock,res);
 if ret <> 0 then
  Result := ''
  else
  Begin
   Result := res;
   Delete(result ,1, 2);  //remove first 2 chars for some reason.....
  End;

  NetApiBufferFree(res);
end;


//===== Retunrs all the Domain controlles in the forest ========================
function TNTADS2.GetDClist: tStringlist;
var sitelist : tstringlist;
    i        : integer;
    i2       : integer;
    l        : tstringlist;
    s        : tstringlist;
    server   : string;
begin
 result := tstringlist.Create;
 fQuietEnum := true;

 //List all the sites
 Sitelist := self.GetAllSites;
 try

  //get the servers in the sites
  for I := 0 to sitelist.Count-1 do
  Begin
   l := self.GetDCInSite(sitelist[i]);

   //Locate the real server object
   for i2 := 0 to l.Count-1 do
   Begin
    server := l[i2];
    if pos('LDAP://',server) > 0 then
      Delete(server,1,10);
    server := copy(server,1,pos(',',server)-1);
    s      := self.locateobjects('computer',server,true);
    if s.Count > 0 then
      result.Add( s[0] );
    s.Free;

   End;

   l.Free;
  End;

 finally
  Sitelist.Free;
  fQuietEnum := false;
 end;
end;

//==============================================================================

function TNTADS2.GetSucureChannel(Server:string):string;
 Var Pinfo : PDOMAIN_COONTROLLER_INFO;
    Flags : ULong;
Begin
 result := '';
 Flags := DS_FORCE_REDISCOVERY; // DS_BACKGROUND_ONLY;
 if DsGetDcNameW (pwidechar(Server),nil,nil,
      nil,Flags,@Pinfo) = S_OK then
    result := pinfo^.DomainControllerName;
 NetApiBufferFree(Pinfo);
End;


//===== Locate a DC in a site =====FIXED!!!!!===================================
Function TNTADS2.LocateDCinSite(Server,ADSite,Domain:String):String;
Var Pinfo : PDOMAIN_COONTROLLER_INFO;
    Flags : ULong;
Begin
 result := '';
 Flags := DS_BACKGROUND_ONLY;
 if DsGetDcNameW (pwidechar(Server),pwidechar(Domain),nil,
      pWideChar(ADSite),Flags,@Pinfo) = S_OK then
    result := pinfo^.DomainControllerName;
 NetApiBufferFree(Pinfo);
End;
//==============================================================================


//===== Get a Domain Controller ================================================
{
 Returns a computer name in the format <computer>.<dc>.<dc>    DNSName
 for example   MyServer.MyDomain.Com
}

Function TNTADS2.GetAnyDCName:string;                                  //3.2.0.0
var info : IADsADSystemInfo;
begin
 info := CoADSystemInfo.create;
 try
  result := info.GetAnyDCName;
 except
  result := '';
 end;
 info := nil;
end;
//==============================================================================


//===== Returns the functional level of the domain =============================
function TNTADS2.GetDomainFunctionalLevel(Domain:String):Integer;      //3.2.0.0
var obj : iads;
Begin
 obj := self.OpenIADS(Domain);
 if obj <> nil then
  result := obj.Get('msDS-Behavior-Version')
 else
  result := -1;
 obj := nil;
End;
//==============================================================================


//===== Returns the functional level of the Forest =============================
function TNTADS2.GetForestFunctionalLevel:Integer;                     //3.2.0.0
var obj : iads;
Begin
 obj := self.OpenIADS('cn=partitions,cn=configuration,'+self.Info.Forest);
 if obj <> nil then
  result := obj.Get('msDS-Behavior-Version')
 else
  result := -1;
 obj := nil;
End;
//==============================================================================


//=====  Get the max level a DC can support ====================================
{
Pass the SHORT name only:  MyServer   *** Currently not working ***
}
Function TNTADS2.GetDCMaxLevel(DC:string):Integer;                     //3.2.0.0
var obj : iADS;
    ts  : string;
Begin
 ts := 'cn=NTDS Settings,cn='+DC+
                     ',cn=servers,cn=sites,cn=configuration,'+self.Info.Forest;

 obj := self.OpenIADS(ts);
 if obj <> nil then
  result := obj.Get('msDS-Behavior-Version')
 else
  result := -1;
 obj := nil;
End;
//==============================================================================

//===== Given a computer name, get the site it is on. ==========================
{
 Computer name must be in the format <computer>.<dc>.<dc>
 for example   MyServer.MyDomain.Com
 Only appears to work on MS OS devices.
}
function TNTADS2.GetComputerSite(Computer: string): String;            //3.2.0.0
var info : IADsADSystemInfo;
begin
 info := CoADSystemInfo.create;
 try
  result := info.GetDCSiteName(Computer);
 except
  on e : Exception do
  Begin
   Self.LasterrorS := 'Error '+e.Message;
   result := '';
  End;
 end;
 info := nil;
end;
//==============================================================================


Function TNTADS2.GetClassIndex(Class_ : String):tObjTypes;
Begin
 class_ := uppercase(Class_);
 if Class_ = 'CONTAINER'            then result := objContainer
 else
 if Class_ = 'ORGANIZATIONALUNIT'   then result := objOrganizationalUnit
 else
 if Class_ = 'COMPUTER'             then result := objComputer
 else
 if Class_ = 'USER'                 then result := objUser
 else
 if Class_ = 'GROUP'                then result := objGroup
 else
 if Class_ = 'PRINTER'              then result := objPrinter
 else
 if Class_ = 'BUILTINDOMAIN'        then result := objBuiltinDomain
 else
 if Class_ = 'LOSTANDFOUND'         then result := objLostandFound
 else
 if Class_ = 'NAMESPACE'            then result := objNameSpace
 else
 if Class_ = 'SECRET'               then result := objSecret
 else
 if Class_ = 'DOMAINPOLICY'         then result := objDomainPolicy
 else
 if class_ = 'DFSCONFIGURATION'     then result := objDFSConfiguration
 else
 if class_ = 'NTFRSSETTINGS'        then result := objnTFRSSettings
 else
 if class_ = 'FILELINKTRACKING'     then result := objFileLinkTracking
 else
 if class_ = 'NAMESPACE'            then result := ObjNameSpace
 else
 if class_ = 'INFRASTRUCTUREUPDATE' then result := objinfrastructureUpdate
 else
 if class_ = 'TRUSTEDDOMAIN'        then result := objtrustedDomain
 else
 if class_ = 'FILESHARE'            then result := objFileShare
 else
 if class_ = 'FILESERVICE'          then result := objFileService
 else
 if class_ = 'SERVICE'              then result := objService
 else
 if class_ = 'PRINTQUEUE'           then result := objPrintQueue
 else
 if class_ = 'RIDMANAGER'           then result := objRidManager
 else
 if class_ = 'RPCCONTAINER'         then result := objRpcContainer
 else
 if class_ = 'SAMSERVER'            then result := objSamServer
 else
 if class_ = 'DNSZONE'              then result := objDNSZone
 else
 if class_ = 'FOREIGNSECURITYPRINCIPAL' then result := objFSecurityPrincipal
 else
 if class_ = 'GROUPPOLICYCONTAINER'     then result := objGPolicyContainer
 else
 if class_ = 'DOMAINDNS'                then result := objDomainDNS
 else
 if class_ = 'MSEXCHSYSTEMOBJECTSCONTAINER' then
                         result := objmsExchSystemObjectsContainer
 else

 Begin
  result := objUnknown;
 end;
end;

Function TNTADS2.CorrectDomain(Domain:String):String;
var ts : string;

Begin
 ts := domain;
 if pos('.',ts) > 0 then
 Begin
  while pos('.',ts) > 0 do
  Begin
   insert(',DC=',ts,pos('.',ts));
   delete(ts,pos('.',ts),1);
  end;
  result := 'DC='+ts;
 end
 else
 result := Domain;
end;



Function TNTADS2.ToDotname(Path:string):String;
Var ts : string;
    m  : integer;
Begin
 result := path;
 if pos('=',path) = 0 then exit;

 ts := path;
 delete(ts,1,pos('=',ts)); //remove the first xx=  must assume could be x=
 while pos('=',ts) > 0 do
 Begin
  m := pos(',',ts);
  delete(ts,pos(',',ts),Pos('=',ts)-Pos(',',ts)+1);
  insert('.',ts,m);
 end;
 result := ts;
end;



function TNTADS2.Translateerror(Error: string): dword;
begin
 //  I really hate this but some methods do not return an errorcde,
 //  or at least I have not found a way.  SetInfo for example is one...
 //  This also prsents a language issue  . . . .

 error := uppercase(error);
 if error = 'THE OBJECT ALREADY EXISTS' then result := ErrAlreadyExists
 else
 result := 0;

end;

Function TNTADS2.GetDomains(path:String;ShortName:boolean):tStringList;
var cnt    : integer;
    ts     : string;
Begin
 result := tstringlist.create;
 if path = ''  then path := info.FForest;
 self.Search.FCatagory   := 'Domain';
 self.Search.FSearchPath := 'GC://'+correctdomain(path);
 self.Search.FSubs       := true;
 self.Search.FFilter     := '';

 executesearch(result,srchDomains); //3.2.0.0

 if ShortName then
  for cnt := 0 to result.count-1 do
  Begin
   ts := NameTranslate(Result[cnt],ADS_NAME_TYPE_1779,ADS_NAME_TYPE_NT4);
   Delete(ts,Length(ts),1);  //delete the trailing backslash
   result[cnt] := ts;
//   result[cnt] := Copy(result[cnt],1,pos(',',result[cnt])-1);
//   result[cnt] := copy(result[cnt],4,maxint);
  end;

end;




Function TNTADS2.IsMember(Group: IadsGroup; Member: string): Boolean;
begin
 result := false;
 if Group = nil then exit;

 //If using the WinNT provide member must include the domain!
 //WinNT://myDomain/Username

 result := Group.IsMember(Member);

end;

procedure TNTADS2.GroupMember2evt (sender : tObject ; AObject : tObjData; //3.3
                             Index:Integer; var Abort,Keep:boolean);
begin
 case index of
  424242 : begin
            if CompareText(fNestedUser,AObject.ADsPath) = 0  then
            Begin
             fNestedUser  := 'found'; //Indicate we found the user
             Abort        := True;    //exit immediatly if the user found
            End;
           end;
 end;
end;


function TNTADS2.IsMemberOfNested(Group: String; Member: string): Boolean; //3.3
var oldevent  : tGroup2EnumEvent;
    output    : TObjectList<tObjData>;
begin
 if Assigned( fGroup2Enum )  then
     oldevent := fGroup2Enum;      //unhook the event if it exists

 Self.OnGroup2Enum := GroupMember2evt;
 try

  if Pos(Self.Provider,Member) = 0 then
    Member := Self.Provider+Member;   //must be in the format LDAP://.....

  fNestedUser := Member;
  output      := Self.GroupMembers2(Group,424242,true);
  Result      := fNestedUser = 'found';

 finally

  output.Free;
  if Assigned(oldevent) then
    fGroup2Enum := oldevent;   //restore the original event hook

 end;

end;



Function TNTADS2.IsMember(ADSPathtoGroup,Member:string):Boolean;
var Group : iADSGroup;
Begin
 result := false;
 Flasterror   := 0;
 FLastErrors  := '';

 Group := OpenGroup(ADSPathtoGroup);
 if group = nil then exit;

 Result := IsMember(Group,Member);

End;
//=====  H E L P E R S =========================================================



//=====  Fill in the INFO structure ============================================
Procedure TNTADS2.GetInfo;
var info : IADsADSystemInfo;
Begin
 Flasterror   := 0;
 FLastErrors  := '';
 try
   info            := CoADSystemInfo.create;
   FInfo.FPDCE     := info.PDCRoleOwner;
   FInfo.FSchema   := info.SchemaRoleOwner;
   FInfo.FDomain   := CorrectDomain(info.DomainDNSName);
   FInfo.FSDomain  := info.DomainShortName;
   FInfo.FUsername := info.UserName;
   FInfo.FMachine  := info.ComputerName;
   FInfo.FSite     := info.SiteName;
   FInfo.FForest   := CorrectDomain(info.ForestDNSName);
   FInfo.FNative   := info.IsNativeMode;
   info            := nil;
 except
  on e : exception do
  Begin
   FLasterror    := 999;
   FLasterrors   := e.Message;
  end;
 end;
 info := nil;
end;
//=====  Fill in the INFO structure ============================================



//=====  GetObjectInfo =========================================================
Function TNTADS2.GetObjectInfo(ADS : iADS): rObjData;
Begin

 if ADS = nil then exit;
 ADS.GetInfo;
 result.ADsPath    := ADS.ADsPath;
 result.Class_     := ADS.Class_;
 result.GUID       := ADS.GUID;
 result.Parent     := ADS.Parent;
 result.ClassIndex := ord(self.GetClassIndex(ADS.Class_));
 result.Name       := ADS.Name;

 try
  result.Created  := ADS.Get('whenCreated');
  result.Modified := ADS.Get('whenChanged');
 except
  result.Created  := 0;
  result.Modified := 0;
 end;

 try
  result.Description := self.GetPropertyValue(ads,'description');
 except
  result.Description := '';
 end;

 try
  result.Schema   := ADS.Schema;
 except
  result.Schema   := '';
 end;

End;

function TNTADS2.GetObjectInfo(ADSPath: String): rObjData;
var ADS : iADS;
begin
 ADS := self.OpenIADS(ADSPath);
 result := GetObjectInfo(ADS);
 ADS := nil;
end;


function TNTADS2.GetObjectInfo2(ADSPath: String): tObjData;
var ADS : iADS;
begin
 ADS := self.OpenIADS(ADSPath);
 result := GetObjectInfo2(ADS);
 ADS := nil;
end;

function TNTADS2.GetObjectInfo2(ADS: iADS): tObjData;
begin
if ADS = nil then exit;

 ADS.GetInfo;

 Result             := tObjData.Create;
 result.ADsPath     := ADS.ADsPath;
 result.Class_      := ADS.Class_;
 result.GUID        := ADS.GUID;
 result.Parent      := ADS.Parent;
 result.ClassIndex  := ord(self.GetClassIndex(ADS.Class_));
 result.Name        := ADS.Name;

 try
  result.Created  := ADS.Get('whenCreated');
  result.Modified := ADS.Get('whenChanged');
 except
  result.Created  := 0;
  result.Modified := 0;
 end;

 try
 result.Description := self.GetPropertyValue(ads,'description');
 except
  result.Description := '';
 end;

 try
  result.Schema   := ADS.Schema;
 except
  result.Schema   := '';
 end;
//
end;

//=====  GetObjectInfo =========================================================




//===== Locate an object =======================================================
function TNTAds2.locateobjects(ojbClass,Filter:string;Global:Boolean):tStringlist;
begin
 result := tStringlist.Create;
 if Global then
 self.Search.FSearchPath := 'GC://'+self.Finfo.FForest
 else
 self.Search.FSearchPath := 'GC://'+self.Finfo.FDomain;
 self.Search.FFilter     := 'CN='+Filter;
 self.Search.FCatagory   := ojbClass;
 self.Search.FSubs       := True;
 try
  self.ExecuteSearch(Result,srchObjects);  //3.2.0.0
 Finally
 end;
end;
//===== Locate an object =======================================================



//===== Open an Object IUnknown ================================================
function tNTADS2.OpenObject(ADSPath: String; ClassType: TGUID): IUnknown;
var res  : HResult;
    err  : String;
begin
 result := Nil;
 self.FLasterror := 0;


 if Pos( Uppercase(FProvider), Uppercase(ADSPath) ) = 0   then
  ADSPath := FProvider+ADSPath;


 try
 if FLogon.FLogon then
 Begin
  res := ADsOpenObject(PWideChar(ADSPath),
                       PWideChar(FLogon.Fusername),    //why cannot a domain be specified here when using WinNT??
                       PWideChar(Flogon.FPassword),
                       ADS_SECURE_AUTHENTICATION,
                       ClassType,
                       Result);
 End
 else
 Begin
  res := ADsGetObject(PWideChar(ADSPath),ClassType,Result);
 End;

 if res <> S_OK then
 Begin
  result := nil;
  self.FLastError := res;
  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,Nil,
                              res,LANG_ENGLISH,PWideChar(err),255,Nil);
  if err = '' then
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,Nil,
                              res-2100,LANG_ENGLISH,PWideChar(err),255,Nil);
  if err = '' then err := 'Unknown error';
  self.FLastErrorS := err;
 End;

 except
  on e : exception do
  Begin
   self.FLastErrorS := e.Message;
   self.FLasterror  := GetLastError;
  End;

 end;

end;
//===== Open an Object IUnknown ================================================



//===== Open a Container =======================================================
function tNTADS2.OpenContainer(ADSPath : String): IADSContainer;
begin
 result := OpenObject(AdsPath,IID_IADsContainer) as IADSContainer;
end;
//===== Open a Container =======================================================



//===== Open a User ============================================================
function tNTADS2.OpenUser(ADSPath: String): IADSUser;
begin
 try
  result := OpenObject(AdsPath,IID_IADsUser) as IADSUser;
 except
  on e : Exception do
  Begin
   self.FLasterror  := getLastError;
   self.FLastErrorS := e.Message;
  End;
 end;
end;
//===== Open a User ============================================================



//===== Open a group ===========================================================
function tNTADS2.OpenGroup(ADSPath: String): IADSGroup;
begin
 result := OpenObject(AdsPath,IID_IADsGroup) as IADSGroup;
end;
//===== Open a group ===========================================================



//===== Open a generic object (IADS) ===========================================
Function tNTADS2.OpenIADS(ADSPath: String): IADS;
begin
 result := OpenObject(AdsPath,IID_IADS) as IADS;
end;
//===== Open a generic object (IADS) ===========================================



//===== Get an Objects Class type ==============================================
Function TNTADS2.GetClass(ADSPath:String):String;
var adsobj : IAds;
Begin
 result := '';
 try
  adsObj := OpenIADS(ADSpath);
  if adsObj <> nil then
   result := adsobj.Class_;
 finally
  adsobj := nil;
 end;
end;
//===== Get an Objects Class type ==============================================



//===== Does an Object exist ===================================================
Function TNTADS2.ObjectExists(ADSPath:String):Boolean;
var Obj : IAds;
Begin
 FLasterror  := 0;
 FLastErrors := '';
 try
  obj := OpenObject(AdsPath,IID_IADs) as IADS;
 except
  on E: Exception do
  Begin
   FLastErrors := e.message;
   FLasterror   := getlasterror;
//   result := false;
   obj := nil;
  end;
 end;
 result := obj <> nil;
 obj := nil;
end;
//===== Does an Object exist ===================================================



//===== Read a property ========================================================
function TNTADS2.GetPropertyValue(Cont:IADS;Name:string):OleVariant;
var I          : integer;
    I2         : integer;
    ts,t2      : OleVariant;
    ft         : tfiletime;
    SystemTime : TSystemTime;
Begin

 result := '';
 try

  t2 := (IadsDisp(Cont).Get(Name));

  i := vartype (IadsDisp(Cont).Get(Name));
  try
  case I of
   VarEmpty : result := '';
   varNull  : result := '';
   VarSmallint,VarInteger,VarSingle,VarDouble,VarCurrency,
   VarOleStr,VarBoolean,vardate:
    result := IadsDisp(Cont).Get(Name);

   varvariant  : result := '(Variant)';     //todo
   VarUnknown  : result := '(Unknown)';     //todo
   varDispatch : Begin
                  if (name = 'pwdLastSet') or (name = 'lastLogon') then
                  Begin
                   ts := IadsDisp(Cont).Get(Name);
                   ft.dwHighDateTime := ts.highpart;
                   ft.dwLowDateTime  := ts.lowpart;
                   FileTimeToSystemTime(ft, SystemTime);
                   result := ( SystemTimeToDateTime(SystemTime) );
                  end;
                 end;

                 else
                 Begin
                 if varisarray(t2) then
                 begin
                  case I of
                   $2011 : Begin  //varaient array of byte
                            for i2 := vararraylowbound(t2,1) to
                                      vararrayHighbound(t2,1) do
                            Begin
                             result := result+inttohex( t2[i2] ,2 );
                            End;
                           End;
                end;
               end
              else
               result := '('+inttohex(I,4)+')';
             End;
            end
  except
//   on e: Exception do  showmessage(e.message);
  end;
 finally
  cont := nil;
 end;
end;


//http://msdn.microsoft.com/en-us/library/windows/desktop/ms684291%28v=vs.85%29.aspx
procedure TNTADS2.GetRootDSE;
var RootDSE : iADS;
begin
 try
  RootDSE := self.OpenIADS('LDAP://RootDSE');
  self.RootDSE.fconfigurationNamingContext := RootDSE.Get('configurationNamingContext');
  self.RootDSE.fcurrentTime                := RootDSE.Get('currentTime');
  self.RootDSE.fdefaultNamingContext       := RootDSE.Get('defaultNamingContext');
  self.RootDSE.fdnsHostName                := RootDSE.Get('dnsHostName');
  self.RootDSE.fdsServiceName              := RootDSE.Get('dsServiceName');
  self.RootDSE.fhighestCommittedUSN        := RootDSE.Get('highestCommittedUSN');
  self.RootDSE.fisGlobalCatalogReady       := RootDSE.Get('isGlobalCatalogReady');
  self.RootDSE.fisSynchronized             := RootDSE.Get('isSynchronized');
  self.RootDSE.fldapServiceName            := RootDSE.Get('ldapServiceName');
  self.RootDSE.frootDomainNamingContext    := RootDSE.Get('rootDomainNamingContext');
  self.RootDSE.fschemaNamingContext        := RootDSE.Get('schemaNamingContext');
  self.RootDSE.fserverName                 := RootDSE.Get('serverName');
  RootDSE := nil;
 except
  on e : exception do
  Begin
   FLasterror    := 999;
   FLasterrors   := e.Message;
  end;
 end;
end;

//===== Read a property ========================================================



//===== Get he propert list for an object ======================================
function TNTADS2.GetPropertyList(ADSPath : String;Mandatory:Boolean):tStringList;
var prop     : olevariant;
    Cont     : IADS;
    adsclass : IAdsClass;
    i        : integer;
Begin
 result := tStringList.Create;
 try

  Cont      := OpenIADS(ADSPath);
  ADsGetObject(PWideChar(IadsODisp(cont).schema),IID_IADSClass,adsclass);

  if mandatory then
  Begin
   Prop := AdsClass.mandatoryProperties;
   if vartype(Prop) and vararray = vararray then
   Begin
    for i := vararraylowbound(Prop,1) to vararrayhighbound(prop,1) do
     result.add(Prop[i]);
   end
   else
   Begin
    Result.add(Prop);
   end;
  end

  else

  Begin
   Prop := adsclass.optionalProperties;
   if vartype(Prop) and vararray = vararray then
   Begin
    for i := vararraylowbound(Prop,1) to vararrayhighbound(prop,1) do
     result.add(Prop[i]);
   end
   else
   Begin
    Result.add(Prop);
   end;
  end;

 finally
  cont := nil;
  adsclass := nil;
 end;
end;
//===== Get he propert list for an object ======================================



//=====  Enumerate a container an see whats in it ==============================
Procedure TNTADS2.EnumerateContainer(Cont : IADsContainer;Index:Integer;
                                                    Var ReturnList:tStringlist);
var Enum          : IEnumVariant;
    ADsTempObj    : OLEVariant;
    ADsObj        : IAds;
    Value         : LongWord;
    Data          : rObjData;
    Abort         : boolean;
    enumcount     : Integer;
    Keep          : Boolean;
Begin
 enumcount := 0;

 if Assigned(fEnumStart) then fEnumStart(self,Index);
 Try
  Abort := false;
  Enum := (Cont._NewEnum) as IEnumVariant;
  while (Enum.Next(1, ADsTempObj, Value) = S_OK) do
  begin
   enumcount := Enumcount + 1;
   ADsObj := IUnknown(ADsTempObj) as IAds;
   ADSObj.GetInfo;
   Data.name     := adsobj.name;
   Data.Class_   := adsobj.Class_;
   Data.GUID     := adsobj.GUID;
   Data.AdsPath  := adsobj.ADSPath;
   Data.Parent   := adsobj.Parent;
   try
    Data.Created  := adsobj.Get('whenCreated');
    Data.Modified := adsobj.Get('whenChanged');
   except
    Data.Created  := 0;
    Data.Modified := 0;
   end;

   try
    Data.Schema  := adsobj.Schema;
   except
    //oops on ADs: not supported on all types
   end;

   Data.Classindex := ord(GetClassIndex(adsobj.class_));

   Keep := True;
   if Not fQuietEnum then
    if Assigned(fEnumEvent) then
                     fEnumevent(self,data,enumcount,Index,Abort,Keep);

   if (assigned(ReturnList)) and (Keep = True)
//                 then ReturnList.Add( adsobj.name+':'+inttostr(Data.index) );
                   then ReturnList.Add( adsobj.ADsPath);              //2.3.0.0


   adsobj := nil;
   variantclear(adstempobj);

   if Abort then break;
  end;

 Finally
  if Assigned(fEnumStop) then
           fEnumStop(self,Index);

  enum := nil;
  adsobj := nil;
 End;
end;
//=====  Enumerate a container an see whats in it ==============================



//===== Execute a search =======================================================
Function  TNTADS2.ExecuteSearch(Index:Integer):boolean;
Var L : tStringlist;
Begin
 l := Nil;
 result := ExecuteSearch(l,Index);
End;

Function TNTADS2.ExecuteSearch(Var ReturnList:tStringlist;Index:Integer):boolean;
var search    : IDirectorySearch;
    p         : pWideChar;  //2005
    ptrResult : Pointer;
    col       : ads_search_column ;
    hr        : HResult;
    hrs       : HResult;
    opt       : array of ads_searchpref_info; // has to be an array
    SData     : string;
    Cnt       : integer;
begin
 fAbort := false;

 if Assigned(fSearchStart) then fSearchStart(self,Index);
 result := False;

 AdsGetObject(pwidechar(FSearch.FSearchPath), IDirectorySearch, search);
 if search = nil then
 Begin
  if Assigned(fSearchStop) then fSearchStop(self,Index);
  result := false;
  exit;
 end;
  try
//   setlength(p,1);  //2009
   p := 'distinguishedName';
   setlength(opt,3);

   opt[0].dwSearchPref := ADS_SEARCHPREF_PAGESIZE;
   opt[0].vValue.dwType := ADSTYPE_INTEGER;
   opt[0].vValue.__MIDL____MIDL_itf_ads_0000_00000000.Integer := FRowCount;

   opt[1].dwSearchPref   := ADS_SEARCHPREF_SEARCH_SCOPE;
   opt[1].vValue.dwType  := ADSTYPE_INTEGER;

   if FSearch.FSubs then
   opt[1].vValue.__MIDL____MIDL_itf_ads_0000_00000000.Integer := ADS_SCOPE_SUBTREE
   else
   opt[1].vValue.__MIDL____MIDL_itf_ads_0000_00000000.Integer := ADS_SCOPE_ONELEVEL;

   opt[2].dwSearchPref := ADS_SEARCHPREF_CACHE_RESULTS;
   opt[2].vValue.dwType := ADSTYPE_BOOLEAN;
   opt[2].vValue.__MIDL____MIDL_itf_ads_0000_00000000.Boolean := 0;



   hr := search.SetSearchPreference(opt[0],length(opt));
   if (hr <> s_OK) then
   begin
    search := nil;
    if Assigned(fSearchStop) then fSearchStop(self,Index);
    result := false;
    Exit;
   end;

   if FSearch.FCatagory <> '' then
   Begin
    if FSearch.FFilter <> '' then
    search.ExecuteSearch(pWideChar('(&(objectCategory='+FSearch.FCatagory+')('+FSearch.FFilter+'))'),
                                 pwidechar(p), 1, ptrResult)
    else
    search.ExecuteSearch(pWideChar('(objectCategory='+FSearch.FCatagory+')'),pwidechar(p),1, ptrResult);
   end
   Else
   begin
    if FSearch.FFilter <> '' then
    search.ExecuteSearch(pWideChar('('+FSearch.FFilter+')'),pwidechar(p), 1, ptrResult)
    else
    search.ExecuteSearch(pWideChar(''),pwideChar(p),1, ptrResult);
   end;

    Self.FLastErrorS := '';
    Self.Lasterror   := 0;
   // searching.................................................................

   hr := search.GetFirstRow(ptrResult);
   cnt := 0;

   while (hr = 0) do
   begin
    hrs := search.GetColumn(ptrResult,('distinguishedName'),col);
    if Succeeded(hrs) then
    begin

     if col.pADsValues <> nil then
     Begin
      Result := True;
      inc(cnt);
      SData := (col.pAdsvalues^.__MIDL____MIDL_itf_ads_0000_00000000.CaseExactString);
                               //Who comes up with these names????

      if Assigned(fSearchEvent) then
              fSearchEvent(self,SData,GetClass(sdata),Cnt,Index);

      if Returnlist <> nil then
       ReturnList.Add( SData );

     end; // <> nil

     search.FreeColumn(col);
    end;  //Get column


    Hr := search.GetNextRow(ptrResult);
    if FAbort then Break;

   end; // hr = 0

  except
   on e : Exception do
   begin
    Self.FLastErrorS := e.Message;
    Self.Lasterror   := 10;
   end;
  end;

  if assigned(ptrResult) then
   search.CloseSearchHandle(ptrResult);
  ptrresult := 0;
  if Assigned(fSearchStop) then fSearchStop(self,Index);
  search := nil;

end;
//===== Execute a search =======================================================

{
 site =  ISS-0
 Subnet = 10.1.2.0/24
                 ^----  Must be 0
 Description = This is a subnet
}
function TNTADS2.CreateSubnet(Site,Subnet,Description:string):Boolean;
var cont : iadsContainer;
    obj  : iads;
Begin
 result := false;
 try
  Cont := self.OpenContainer('LDAP://CN=SUBNETS,CN=SITES,CN=CONFIGURATION,'+
                                                              self.Info.Forest);
  if cont <> nil then
  Begin
   obj := Cont.Create('subnet','CN='+subnet) as Iads;
   obj.Put('description',description);
   obj.Put('siteObject','CN='+site+',CN=Sites,CN=Configuration,'+
                                                              self.Info.Forest);
   obj.SetInfo;
   result := true;
  End;
 except
  on e : exception do
  Begin
   self.LasterrorS := e.Message;
   result := false;
  End;
 end;
End;

{
 OnEnumeration index = srchSitesubnets
}

function TNTADS2.GetSubnets:tStringlist;
var cont       : iADSContainer;
    ADsObj     : IADs;
    Enum       : IEnumVariant;
    ADsTempObj : OLEVariant;
    Value      : LongWord;
    Site       : string;
Begin
 cont := self.OpenContainer('LDAP://CN=Subnets,CN=SITES,CN=CONFIGURATION,'+
                                                             self.Info.FForest);

 result := tstringlist.Create;

 Enum := (Cont._NewEnum) as IEnumVariant;
  while (Enum.Next(1, ADsTempObj, Value) = S_OK) do
  begin
   ADsObj := IUnknown(ADsTempObj) as IAds;
   ADSObj.GetInfo;

   try
    Site := ADsObj.Get('siteObject');
    Delete(Site,1,3);
    site := Copy(Site,1,Pos(',',Site)-1);
   except
    Site := '';
   end;

   Result.Add(Copy(ADsObj.Name,4,100)+','+site);

   adsobj := nil;
   variantclear(adstempobj);


  end;

End;

{
 OnEnumeration index = srchSiteServers

 /CN=Servers,CN=Default-First-Site-Name,CN=SITES,CN=CONFIGURATION,DC=iss,DC=net
}
function TNTADS2.GetDCInSite(Site:string):tstringlist;                //3.2.0.0
var cont : iADSContainer;
    ts   : string;
Begin
 if pos('LDAP://',Site) > 0 then
   Delete(site,1,7);

 ts := 'LDAP://CN=Servers,CN='+site+',CN=SITES,CN=CONFIGURATION,'+self.Info.Forest;
 cont := self.OpenContainer(ts);

 result := tstringlist.Create;

 if cont <> nil then
  EnumerateContainer(Cont,srchSiteDCs,result);

End;

//===== Get al the sites in the current domain =================================
{
OnEnumeration index = srchSites
}
function TNTADS2.GetAllSites: tStringlist;
var Cont : iADSContainer;
    param : olevariant;
begin

 result := tstringlist.Create;

 Cont := self.OpenContainer('LDAP://CN=SITES,CN=CONFIGURATION,'+self.Info.FForest);
 param := vararrayof(['site']);
 Cont.Filter := param;

 EnumerateContainer(Cont,srchSites,result);

end;
//==============================================================================

//===== Enumerate a users groups ===============================================
Function TNTADS2.EnumUser(User:IadsUser) : tStringlist;
var enum        : IEnumVariant;
    TempUserObj : OleVariant;
    UserObj     : IAds;
    _Value      : LongWord;
Begin

 fAbort := false;
  result := tstringlist.create;

  if user = nil then exit;

 try
  Enum := (user.Groups._NewEnum) as IEnumVariant;

  while (Enum.Next(1, TempUserObj, _Value) = S_OK) do
  begin
   UserObj := IUnknown(TempUserObj) as IAds;
   variantclear(tempuserobj);
   result.add(UserObj.adspath);
   UserObj     := nil;
   if fAbort then Break;
  end;

 finally
  Enum     := nil;
  userobj  := nil;
  user     := nil;
  variantclear(tempuserobj);
 end;

End;


Function  TNTADS2.EnumUser(ADSpath:string):tStringlist;
Var User        : Iadsuser;
Begin
  self.LastErrorS := '';
  self.LastError  := 0;
  result := nil;

  try
   User := Self.OpenUser(ADSPath);
  except
   on e : exception do
   Begin
    self.LastErrorS  := e.Message;
    self.LastError   := ErrBindError;
    Exit;
   End;
  end;

  result := Enumuser(User);

end;


function TNTADS2.EnumUser2(ADSPath: string): tObjectList<tObjData>;
var enum        : IEnumVariant;
    TempUserObj : OleVariant;
    UserObj     : IAds;
    _Value      : LongWord;
    User        : IADsUser;
    data        : tObjData;
Begin

 fAbort := false;

 User := Self.OpenUser(ADSPath);

 if user = nil then exit;
 Result := tObjectList<tObjData>.Create;

 try
  Enum := (user.Groups._NewEnum) as IEnumVariant;

  while (Enum.Next(1, TempUserObj, _Value) = S_OK) do
  begin
   UserObj := IUnknown(TempUserObj) as IAds;
   variantclear(tempuserobj);
   Data := GetObjectInfo2(UserObj );
   result.Add( Data );
   UserObj     := nil;
   if fAbort then Break;
  end;

 finally
  Enum     := nil;
  userobj  := nil;
  user     := nil;
  variantclear(tempuserobj);
 end;
end;

//===== Enumerate a users groups ===============================================



//===== Enumerate a group ======================================================
function TNTADS2.GroupMembers2(ADSPath: string;Index:Integer;Recurse:Boolean):
                                                          tObjectList<tObjData>;
var group       : IADsGroup;
    Enum        : IEnumVARIANT;
    TempObj     : OleVariant;
    obj         : IAds;
    Num         : Cardinal;
    Data        : tObjData;
    Seen        : TStringList;
    Abort       : Boolean;
    Keep        : Boolean;

    procedure enumthegroup(APath:string);
    var gt : Cardinal;
    begin
      Group := self.OpenGroup(APath);
      group.GetInfo;
      gt := group.Get('groupType');
      if (fSecurityOnly) and (gt and SECURITY_ENABLED <> SECURITY_ENABLED)
                                                    then Exit;


      if group <> nil then
      Begin

       Enum := (Group.Members._NewEnum) as IEnumVariant;

       while (Enum.Next(1, TempObj, Num) = S_OK) do
       begin
         Obj := IUnknown(TempObj) as IAds;
         Data := GetObjectInfo2(obj );

         Keep := True;

         if assigned(fGroup2Enum) then
          fGroup2Enum(self,Data,Index,abort,Keep);

         Data.Data1 := APath;   //if a nested group this shows what group the user is nested in

         if Keep then
          result.add( Data )
         else
         Data.Free;

         variantclear(TempObj);

         if Abort then
          Break;
        end;

      End;

    end;

    procedure ProcessGroup(APath : string);
    var// res : tObjectlist<tobjdata>;
        m   : tObjData;
        g   : TStringList;
    I: Integer;
    begin
     g := TStringList.Create;
     try
       if abort then
             Exit;

       Seen.Add(APath);


       enumthegroup(APath);

       for m in result do
       begin
        if m.ClassIndex = 4 then
         g.Add(m.ADsPath);
       end;

       //only look at groups we have not seen before, avoid looping
       for I := 0 to g.Count-1 do
        if seen.IndexOf(g[i]) = -1 then
          ProcessGroup(G[i]);

     finally
      g.Free;
     end;

    end;

begin
   Result := tObjectList<tObjData>.Create;

   if Assigned(fGroup2Start) then
     fGroup2Start(self);

   if Recurse then
   begin
    Seen := TStringList.Create;
    Seen.Sorted := True;
    Seen.Duplicates := dupIgnore;
    Abort := false;
    try
     ProcessGroup( ADSPath );
    finally
     Seen.Free;
    end;

   end
   else
   begin
    enumthegroup(ADSPath);
   end;

   if Assigned(fGroup2Stop) then
     fGroup2Stop(self);

end;

//===== Enumerate a group for members ==========================================



//===== Move an object =========================================================
Function TNTADS2.MoveObject(cont:iadscontainer;Name:String):Boolean;
Begin
 Result := true;
 Self.FLasterror  := 0;
 self.FLastErrorS := '';

 try
  cont.MoveHere(Name,'');
 except
  on E: Exception do
  Begin
   self.FLastErrorS  := e.message;
   Self.FLasterror   := getlasterror;
   result := false;
  End;
 end;

end;
//===== Move an object =========================================================



//===== Delete an object =======================================================
function TNTADS2.DeleteObject(Cont: IadsContainer; OType,
  Name: widestring): Boolean;
begin
// result  := false;
 Self.FLasterror  := 0;
 self.FLastErrorS := '';

 try
  cont.delete(OType,Name);
  Result := true;
 except
   on E: Exception do
   Begin
    self.FLastErrorS := e.message;
    Self.FLasterror  := getlasterror;
    result := false;
   end;
 end;

end;


Function TNTADS2.DeleteObject(ADSPathtoCont,OType,Name:widestring):Boolean;
var cont : IADSContainer;
Begin
// result  := false;
 Self.FLasterror  := 0;
 self.FLastErrorS := '';

 try
  cont := OpenContainer(ADSPathtoCont);
 except
  on e : exception do
  Begin
   Self.FLasterror  := getlasterror;
   self.FLastErrorS := e.Message;
  end;
 end;

 try
  cont.delete(OType,Name);
  Result := true;
 except
   on E: Exception do
   Begin
    self.FLastErrorS := e.message;
    Self.FLasterror  := getlasterror;
    result := false;
   end;
 end;

 Cont := nil;
end;
//===== Delete an object =======================================================



//===== Create a user object ===================================================
Function TNTADS2.CreateUser(Cont:IADSContainer;Name,Pre2K,Password : String):Boolean;
Var User : IADSUser;
Begin
// result := false;
 Self.FLasterror  := 0;
 self.FLastErrorS := '';

 if pre2k = '' then Pre2k := Name;

 result := true;
 try

  user := cont.create('user','CN='+Name) as IADSUser;
  user.Put('samAccountName',Pre2k);
  user.put('displayName',Name);
  User.Setinfo;
  User.AccountDisabled := False;
  User.setPassword(Password);
  User.Setinfo;

 except
  on e : exception do
  begin
   Self.FLasterror := getLastError;
   Self.FLastErrorS := e.Message;
   result := false;
  end;
 end;

End;

Function TNTADS2.CreateUser(ADSPathtoCont,Name,Pre2K,Password : String):Boolean;
Var  Cont : IADSContainer;
     User : IADSUser;
Begin
 result := false;
 Self.FLasterror  := 0;
 self.FLastErrorS := '';

 if pre2k = '' then Pre2k := Name;

 Cont := OpenContainer(ADSPathtoCont);
 if cont = nil then
 Begin
  Self.FLasterror  := ErrCannotOpenContainer;
  self.FLastErrorS := 'Could not open the container';
  cont := nil;
  exit;
 end;

  //Call the overloaded function
 result := CreateUser(Cont,Name,Pre2K,Password);

 User := Nil;
 cont := Nil;
end;
//===== Create a user object ===================================================



//===== Change a password ======================================================
Function TNTADS2.ChangePassword(ADSPath,Old,New:String):Boolean;
var User : iadsUser;
Begin
 result := False;

 try
  User := Openuser(ADSPath);
 except
  on e : exception do
  begin
   Self.FLasterror := getLastError;
   Self.FLastErrorS := e.Message;
   result := false;
  end;
 end;

 if user = nil then exit;

 try
  try
   if Old = '' then
     user.SetPassword(New)   //Thanks David Wright !!
   else
    user.ChangePassword(Old,New);
   Result := true;
  except
   result := false;
  end;
 Finally
  User := nil;
 End;

end;
//===== Change a password ======================================================


//===== create a group =========================================================
Function TNTADS2.CreateGroup(Cont:IADSContainer;Name,Pre2K,Description:String;
                              GType:tGroup;Security:Boolean):Boolean;
Var grp  : IadsGroup;
    Sec  : olevariant;
//    res  : hresult;
Begin
 result := true;
 try
  self.FLastErrorS  := '';
  self.FLasterror   := 0;
  Grp := cont.create('group','CN='+Name) as IADSGroup;
  Grp.Put('samAccountName',Pre2K);
  Grp.put('name',Name);
  if description <> '' then
   Grp.put('description',description);
  case gtype of
   gtGlobal    : Sec := GLOBAL_GROUP;
   gtDomain    : Sec := LOCAL_GROUP;
   gtUniversal : Sec := UNIVERSAL_GROUP;
  end;
  if security then sec := sec or SECURITY_ENABLED;
  grp.put('groupType',sec);
  Grp.Setinfo;
 except
  on E: Exception do
  Begin
   self.FLastErrorS := e.message;
   self.FLasterror  := self.Translateerror(e.Message);
   result := false;
  end;
 end;
End;


Function TNTADS2.CreateGroup(ADSPathtoCont,Name,Pre2K,Description:String;
                             GType:tGroup;Security:Boolean):Boolean;
var Cont : IADSContainer;
Begin

 if pre2k = '' then Pre2k := Name;
 try

 cont := OpenContainer(ADSPathtoCont);
 except
   on E: Exception do
   Begin
    self.FLastErrorS := e.message;

   end;
 end;

 if cont = nil then
 Begin
  self.FLastErrorS := 'Could not open the container';
  self.FLasterror  := ErrCannotOpenContainer;
  result := false;
  exit;
 End;

 //Call the overloaded function
 result := CreateGroup(Cont,Name,Pre2K,Description,GType,Security);

end;
//===== create a group =========================================================



//===== AddToGroup =============================================================
procedure TNTADS2.Abort;
begin
 FAbort := true;
end;

Function  TNTADS2.AddToGroup(Group:iadsGroup;Name:string):Boolean;
Begin
// result := false;
 self.FLastErrorS  := '';
 self.FLasterror   := 0;

 {
 If WinNT://provider is used "Name" must include the Domain for isMember to work
 group.isMember('WinNT://MyDomain/AUser');
                         ^^^^^^^^^
 }
 if group.IsMember(name) then
 Begin
  Result := true;
  self.FLastErrorS := 'Object already a member';
  self.FLasterror  := ErrAlreadyExists;
  Exit;
 End;

  try
   group.add(Name);
   result := true;
  except
   on E: Exception do
   Begin
    self.FLastErrorS := e.message;
    self.FLasterror  := getlasterror;
    result := false;
   end;
  end;

End;

function TNTADS2.AddToGroup(ADSPathtoGroup,Name:string):Boolean;
var group : IADSGroup;
Begin
// result := false;
 self.FLastErrorS  := '';
 self.FLasterror   := 0;

 if Pos( Uppercase(FProvider), Uppercase(ADSPathtogroup) ) = 0   then
  ADSPathtogroup := FProvider+ADSPathtogroup;

  try
   Group := OpenGroup(ADSPathtogroup);
  except
   on E: Exception do
   Begin
    self.FLastErrorS   := e.message;
    self.FLasterror    := getlasterror;
    result := false;
    exit;
   end;
  end;

  //===== Open the overloaded method
  result := AddToGroup(Group,Name);

  Group := nil

end;
//===== AddToGroup =============================================================



//===== RemoveFromGroup ========================================================
function  TNTADS2.RemoveFromGroup(Group:iadsGroup;Name:string):Boolean;
Begin
 self.FLastErrorS  := '';
 self.FLasterror   := 0;

 {
 If WinNT://provider is used "Name" must include the Domain for isMember to work
 group.isMember('WinNT://MyDomain/AUser');
                         ^^^^^^^^^
 }


 if not group.IsMember(Name) then
 Begin
  result := true;
  self.FLastErrorS  := '';
  self.FLasterror   := 0;
  exit;
 End;

   try
   group.Remove(Name);
   result := true;
  except
   on E: Exception do
   Begin
    self.FLastErrorS  := e.message;
    self.FLasterror   := getlasterror;
    result := false;
   end;
  end;

End;

function TNTADS2.RemoveFromGroup(ADSPathtogroup,Name:string):Boolean;
var group : IADSGroup;
Begin
 result := false;
 self.FLastErrorS  := '';
 self.FLasterror   := 0;

 if Pos( Uppercase(FProvider), Uppercase(ADSPathtogroup) ) = 0   then
  ADSPathtogroup := FProvider+ADSPathtogroup;

 try

  try
   Group := OpenGroup(ADSPathtogroup);
  except
   exit;
  end;

  //===== Open the overloaded method
  result := RemoveFromGroup(Group,Name);

 finally
  Group := nil;
 end;

end;
//===== RemoveFromGroup ========================================================



//===== Depreciated ============================================================
//===== Depreciated ============================================================
//===== Depreciated ============================================================
//===== Depreciated ============================================================


//===== Enumerate a group for members ==========================================

//===== Sub function=======
Function TNTADS2.enumgroup(ADSPath:string):tstringlist;
var Group       : IADSGroup;
    Enum        : IEnumVariant;
    TempUserObj : OleVariant;
    UserObj     : IAds;
    _Value      : LongWord;
    cls         : string;
    abort       : boolean;
Begin
 try
  result := tstringlist.create;
  self.LastErrorS := '';
  self.LastError  := 0;

  try

   Group := self.OpenGroup(ADSPath);

   if group = nil then
   Begin
    self.LastErrorS  := 'The requested group cannot be located '+ADSPath;
    self.LastError   := errGroupCannotBeLocated;
    exit;
   End;


  except
   on e : exception do
   Begin
    self.LastErrorS  := e.Message;
    self.LastError   := ErrBindError;
    Exit;
   End;
  end;

  Enum := (Group.Members._NewEnum) as IEnumVariant;

  while (Enum.Next(1, TempUserObj, _Value) = S_OK) do
  begin
    UserObj := IUnknown(TempUserObj) as IAds;


    cls := lowercase(userobj.Class_);

    if assigned(fGroupEnum) then
     fGroupEnum(Nil,userobj.ADsPath,ADSpath,ord(self.GetClassIndex(cls)),
                                                             FGroupIndex,abort);
    result.add('{'+cls+'}'+UserObj.adspath);
    variantclear(tempuserobj);

    if abort then break;
   end

 finally

 end;
end;

//===== Sub function=======


Function TNTADS2.GetAllusers(ADSpath:string):tstringlist;
var seengroup : tstringlist;

 procedure dogroup(path:string);
 var  G   : tstringlist;
      GP  : Integer;
      l   : tstringlist;
      cnt : integer;
 Begin
  seengroup.add(path);
  g := tstringlist.Create;
  l := nil;
  try
   Try
    l := enumgroup(path);
    if l.Count > 0 then
    for cnt := 0 to l.count-1 do
    Begin
     if pos('{user}',l[cnt]) > 0 then
                              result.Add(copy(l[cnt],pos('}',l[cnt])+1,maxint));
     if pos('{group}',l[cnt]) > 0 then
                                   g.Add(copy(l[cnt],pos('}',l[cnt])+1,maxint));
    end;
   finally
    l.Free;
   end;

   //recurse
   if g.count > 0 then
   for GP := 0 to G.count-1 do
   Begin
    if seengroup.IndexOf(g[gp]) = -1 then DoGroup(G[GP]);
   end;

  finally
   g.free;
  end;
 end;

Begin
 result := tstringlist.Create;
 result.Sorted     := true;
 try
  if Assigned(fEnumStart) then fEnumStart(self,maxint);
  SeenGroup := tstringlist.create;
  DoGroup(ADSpath);
 finally
  if Assigned(fEnumStop) then fEnumStop(self,maxint);
  SeenGroup.free;
 end;
end;

//===== Main function=======

Function TNTADS2.GroupMembers(ADSPath: String;Index:Integer;
                                                     Recurse: Boolean): Boolean;
var l : tstringlist;
begin
 FGRoupIndex := Index;
 if Assigned(fGroupStart) then fGroupStart(self,FGRoupIndex);
 l := nil;
 try
  if Recurse then
   l := GetAllusers(ADSpath)
  else
   l := enumgroup(ADSPath);
 except
 end;

 if assigned(l) then l.Free;
 if Assigned(fGroupStop) then fGroupStop(self,FGRoupIndex);
 Result := true;
end;

//===== Initialization =========================================================

initialization
 CoInitializeEx (NIL, COINIT_MULTITHREADED);
end.
