unit Model.DAO.Pedidos;

interface

uses
  Model.Entidades.Pedidos,
  Data.DB,
  Model.DAO.Interfaces,
  Model.Conexao.Interfaces,
  Model.Conexao.Firedac;

type
  TDAOPedido = class(TInterfacedObject, iDAOEntidade<TPedidos>)
    private
      FPedidos: TPedidos;
      FConexao: iConexao;
      FDataSet: TDataSet;

    public
      constructor Create;
      destructor  Destroy; override;
      class function New: iDAOEntidade<TPedidos>;
      function Listar : iDaoEntidade<TPedidos>;
      function ListarPorId(Id: Integer): iDaoEntidade<TPedidos>;
      function Excluir(Id: Integer): iDaoEntidade<TPedidos>; overload;
      function Excluir: iDaoEntidade<TPedidos>; overload;
      function Atualizar: iDaoEntidade<TPedidos>;
      function Inserir: iDaoEntidade<TPedidos>;
      function DataSet(DataSource: TDataSource):  iDaoEntidade<TPedidos>;
      function This: TPedidos;
  end;

implementation

uses
  System.SysUtils;

{ TDAOPedido }

function TDAOPedido.Atualizar: iDaoEntidade<TPedidos>;
begin
  Result := Self;
  try
    FConexao
      .SQL('update pedidos set data_pedido=:data, id_cliente=:idcliente, total_pedido=:total where numero_pedido=:id')
      .Params('data', FPedidos.Data_Pedido)
      .Params('idcliente', FPedidos.Id_Cliente)
      .Params('total', FPedidos.Total_Pedido)
      .Params('id', FPedidos.Numero_Pedido)
      .ExecSQl;
  except on e: Exception do
    raise Exception.Create('Erro ao tentar atualizar o registro: ' + e.ToString);
  end;
end;

constructor TDAOPedido.Create;
begin
  FConexao  :=  TModelConexao.New;
  FPedidos  :=  TPedidos.Create(Self)
end;

function TDAOPedido.DataSet(DataSource: TDataSource): iDaoEntidade<TPedidos>;
begin
  Result  :=  Self;
  if not Assigned(FDataSet) then
    DataSource.DataSet  :=  FConexao.DataSet
  else
    DataSource.DataSet  :=  FDataSet;
end;

destructor TDAOPedido.Destroy;
begin
  FPedidos.DisposeOf;
  inherited;
end;

function TDAOPedido.Excluir(Id: Integer): iDaoEntidade<TPedidos>;
begin
  Result := Self;
  try
    FConexao
      .SQL('delete from pedidos where numero_pedido=:id')
      .Params('id', Id)
      .ExecSQl;
  except on e: Exception do
    raise Exception.Create('Erro ao tentar excluir o registro: ' + e.ToString);
  end;
end;

function TDAOPedido.Excluir: iDaoEntidade<TPedidos>;
begin
  Result := Self;
  try
    FConexao
      .SQL('delete from pedidos where numero_pedido=:id')
      .Params('id', FPedidos.Numero_Pedido)
      .ExecSQl;
  except on e: Exception do
    raise Exception.Create('Erro ao tentar excluir o registro: ' + e.ToString);
  end;
end;

function TDAOPedido.Inserir: iDaoEntidade<TPedidos>;
begin
  Result := Self;
  try
    FConexao
      .SQL('insert into pedidos (data_pedido, id_cliente, total_pedido) values (:datapedido, :idcliente, :total)')
      .Params('datapedido', FormatDateTime('yyyy-mm-dd', Date))
      .Params('idcliente', FPedidos.Id_Cliente)
      .Params('total', FPedidos.Total_Pedido)
      .ExecSQL;
  except on e: Exception do
    raise Exception.Create('Erro ao tentar inserir o registro: ' + e.ToString);
  end;
end;

function TDAOPedido.Listar: iDaoEntidade<TPedidos>;
begin
  Result  :=  Self;
  FDataSet  :=
    FConexao
      .SQL('select * from pedidos')
      .Open
      .DataSet;
end;

function TDAOPedido.ListarPorId(Id: Integer): iDaoEntidade<TPedidos>;
begin
  Result    :=  Self;
  FDataSet  :=
    FConexao
      .SQL('select * from pedidos where numero_pedido=:id')
      .Params('id', Id)
      .Open
      .DataSet;
end;

class function TDAOPedido.New: iDAOEntidade<TPedidos>;
begin
  Result  :=  Self.Create;
end;

function TDAOPedido.This: TPedidos;
begin
  Result  :=  FPedidos;
end;

end.
