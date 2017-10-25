{*
 * Stream Adapter: Pascal stream class that is implemented as an interface, thus offering reference-counting.
 * Jonas Raoni Soares da Silva <http://raoni.org>
 * https://github.com/jonasraoni/stream-adapter
 *}

unit StreamAdapter;

interface

uses
  Classes;

type
  IStream = interface( IInterface )
    ['{FBEF199A-09BC-4B61-89EA-1EF8B22C93A5}']
    function Read(var Buffer; const Count: Longint): Longint;
    function Write(const Buffer; const Count: Longint): Longint;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
    procedure ReadBuffer(var Buffer; const Count: Longint);
    procedure WriteBuffer(const Buffer; const Count: Longint);
    function CopyFrom(Source: TStream; const Count: Int64): Int64;
    function WriteTo(Dest: TStream; const Count: Int64): Int64;

    procedure SetPosition( const Value: Int64 );
    procedure SetSize( const Value: Int64 );
    function GetPosition: Int64;
    function GetSize: Int64;

    property Position: Int64 read GetPosition write SetPosition;
    property Size: Int64 read GetSize write SetSize;
  end;

  TStreamAdapter = class( TInterfacedObject, IStream )
  private
    FStream: TStream;
    procedure SetPosition( const Value: Int64 );
    procedure SetSize( const Value: Int64 );
    function GetPosition: Int64;
    function GetSize: Int64;

  public
    constructor Create( Stream: TStream );
    destructor Destroy; override;

    function Read(var Buffer; const Count: Longint): Longint;
    function Write(const Buffer; const Count: Longint): Longint;

    procedure ReadBuffer(var Buffer; const Count: Longint);
    procedure WriteBuffer(const Buffer; const Count: Longint);

    function CopyFrom(Source: TStream; const Count: Int64): Int64;
    function WriteTo(Dest: TStream; const Count: Int64): Int64;

    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;

    property Position: Int64 read GetPosition write SetPosition;
    property Size: Int64 read GetSize write SetSize;
  end;

implementation

{ TStreamAdapter }

function TStreamAdapter.CopyFrom(Source: TStream; const Count: Int64): Int64;
begin
  Result := FStream.CopyFrom( Source, Count );
end;

constructor TStreamAdapter.Create(Stream: TStream);
begin
  FStream := Stream;
end;

destructor TStreamAdapter.Destroy;
begin
  FStream.Free;
  inherited;
end;

function TStreamAdapter.GetPosition: Int64;
begin
  Result := FStream.Position;
end;

function TStreamAdapter.GetSize: Int64;
begin
  Result := FStream.Size;
end;

function TStreamAdapter.Read(var Buffer; const Count: Integer): Longint;
begin
  Result := FStream.Read( Buffer, Count );
end;

procedure TStreamAdapter.ReadBuffer(var Buffer; const Count: Integer);
begin
  FStream.ReadBuffer( Buffer, Count );
end;

function TStreamAdapter.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  Result := FStream.Seek( Offset, Origin );
end;

procedure TStreamAdapter.SetPosition(const Value: Int64);
begin
  FStream.Position := Value;
end;

procedure TStreamAdapter.SetSize(const Value: Int64);
begin
  FStream.Size := Value;
end;

function TStreamAdapter.Write(const Buffer; const Count: Integer): Longint;
begin
  Result := FStream.Write( Buffer, Count );
end;

procedure TStreamAdapter.WriteBuffer(const Buffer; const Count: Integer);
begin
  FStream.WriteBuffer( Buffer, Count );
end;

function TStreamAdapter.WriteTo(Dest: TStream; const Count: Int64): Int64;
begin
  Result := Dest.CopyFrom( FStream, Count );
end;

end.
