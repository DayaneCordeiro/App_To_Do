# Flutter 🤓

* no terminal digita flutter devices:
	* mostra todos os emuladores ativos
		* se for apenas um apenas digitar flutter run
		* se forem mais: flutter run -d <id do emulador>

* **Tudo** no flutter é widget
	* Divididos em dois tipos principais:
		* statelesswidget - sem estados, sem persistência, apenas um desenho na tela
		* statefullwidget - tem estado - começa com o create state

* Classe com underline antes do nome representa classe privada
* Método build constroi o layout da tela
* Uma aplicação Material roda no IOS, porém existem widgets que são exclusivos do Android ou exclusivos do IOS
* Sempre no código retorna o MateriaApp, independente se seja Android ou IOS (dentro do build Widget)
* Flutter é declarativo (HTML e CSS junto)
* debugShowCheckedModeBanner: false, -> tira aquela tirinha de debug que fica na tela

* **Coisas que a aplicação precisa para funcionar:**
	* A importação do material.dart
	* A função main que chama uma função runApp que recebe com parâmetro um Widget (normalmente stateleeswidget)
	* Sempre retornar o MaterialApp
		* title: invisível dentro da aplicação, mas é o nome do app quando vai clicar pra abrir
		* theme: layout
			* primarySwatch -> palheta de cores
		* home: quem literalmente chama a aplicação (nova classe com o conteúdo)

* O **Scaffold** (esqueleto da página) representa literalmente uma página. Ele não tem child, mas tem o body, que pode ter um container que tem child
	* Propriedade mais usadas do Scaffold:
		* appBar
		* body

~~~
return Scaffold(
	appBar: AppBar(
		leading: Text('Oi'), // Onde fica o menu hamburguer
		title: Text('Todo List'), // Título da appBar
		actions: <Widget>[ // actions
			Icon(Icons.access_alarm), // forma de utilizar os icones dentro do flutter sem precisar importar
		],
	),
	body: Container(
		child: Center(
			child: Text('Hello World'),
		),
	),
);
~~~

### Modelando o Item
* Models são os itens que representam alguma informação que vem de fonte externa
* Diferente das outras linguagens, o **construtor** no Dart pode ser escrito de uma maneira bem mais simples:

~~~
Item({this.title, this.done});
~~~

* Código desenvolvido nessa aula:
	* dentro da pasta lib -> foi criada a pasta models
	* dentro da pasta models -> foi criada o arquivo item.dart com o seguinte conteúdo:

~~~
class Item {
  String title;
  bool done;

  /// @brief Constructs a Item
  Item({this.title, this.done});

  /// @brief Converts a Item into  JSON
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  /// @brief Converts a JSON into Item
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;
    data['done'] = this.done;

    return data;
  }
}
~~~

* Dica para criar códigos que vão trabalhar com Json: https://javiercbk.github.io/json_to_dart/ esse site gera

### ListView
* Mudamos o MyHomePage para statefulWidget levando em consideração que irá mudar a todo momento que o usuário inserir ou excluir itens e a geramos a classe estado:

~~~
class MyHomePage extends StatefulWidget {
  var items = new List<Item>();

  /* Essa página será chamada apenas uma vez então criamos o método construtor */
  MyHomePage() {
    items = [];
    items.add(Item(title: "Item 1", done: false));
    items.add(Item(title: "Item 2", done: true));
    items.add(Item(title: "Item 3", done: false));
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
~~~

* classe estado:

~~~
class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
          itemCount: widget.items.length,
          /* Quantidade que a lista possui naquele momento */
          itemBuilder: (BuildContext context, int index) {
            /* Função que determina como os itens devem ser construidos na tela */
            return Text(widget.items[index].title);
          }),
    );
  }
}
~~~

### CheckboxListTile
* Modificamos o retorno do itemBuilder para os checkboxes

~~~
itemBuilder: (BuildContext context, int index) {
  /* Função que determina como os itens devem ser construidos na tela */
  final item = widget.items[index]; // Limpando o código

  return CheckboxListTile(
    title: Text(item.title),
    key: Key(item.title),
    value: item.done,
    onChanged: (value) {},
  );
},
~~~

### SetState
* Para mudar o estado do checkbox é necessário além de permitir que o estado mude, mandar a tela se atualizar.
  * É necessário usar o **setState(() {})** -> só funciona dentro de um StatefulWidget.
    * O setState é construído dessa forma por que recebe uma função anônima como parâmetro.

~~~
return CheckboxListTile(
  title: Text(item.title),
  key: Key(item.title),
  value: item.done,
  onChanged: (value) {
    /* Avisa para a página que o item mudou */
    setState(() {
      item.done = value;
    });
  },
);
~~~

### TextFormField
* Criamos na AppBar o input que receberá o texto da tarefa

~~~
appBar: AppBar(
  /* Cria uma caixa de texto */
  title: TextFormField(
    keyboardType: TextInputType.text,
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
    decoration: InputDecoration(
      labelText: "Nova Tarefa",
      labelStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
),
~~~

* Para pegar aquilo que o usuário digitou no input usamos o TextEditingController

~~~
var newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* Cria uma caixa de texto */
        title: TextFormField(
          controller: newTaskController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
~~~

### Adicionando um item
* Invés de colocarmos o botão de adição dentro da própria appBar, iremos utilizar uma nova propriedade:
  * floatingActionButton <- identico ao botão + que aparece no app padrão do flutter

~~~
floatingActionButton: FloatingActionButton(
  onPressed: () {},
  child: Icon(Icons.add),
  backgroundColor: Colors.pink,
),
~~~

* Para de fato criar o item iremos adicionar uma função no código

~~~
/// @brief Recupera o valor do newTaskController e cria um novo item
  void add() {
    if (newTaskController.text.isEmpty) return;

    /* Necessário criar dentro do setState para já criar e atualizar a tela de uma vez */
    setState(() {
      widget.items.add(
        Item(
          title: newTaskController.text,
          done: false,
        ),
      );
      newTaskController.clear();
    });
  }
~~~

* Determinamos que o onpressed irá chamar a função add, nesse caso, não podemos usar ()

~~~
floatingActionButton: FloatingActionButton(
  /* Determinar que o onpressed chame a função add, não pode usar () */
  onPressed: add,
  child: Icon(Icons.add),
  backgroundColor: Colors.pink,
),
~~~

### Removendo um item
* Vamos remover com o efeito de arrastar para o lado, para isso vamos mudar o checkboxtile para dismissible

~~~
return Dismissible(
  child: CheckboxListTile(
    title: Text(item.title),
    value: item.done,
    onChanged: (value) {
      /* Avisa para a página que o item mudou */
      setState(() {
        item.done = value;
      });
    },
  ),
  key: Key(item.title),
  background: Container(
    color: Colors.redAccent.withOpacity(0.2),
  ),
  onDismissed: (direction) {
    remove(index);
  },
);
~~~

* E para funcionar internamente (pois no front já funciona), criamos a função de remover

~~~
/// @brief Remove uma determinada tarefa quando ela é arrastada pro lado
void remove(int index) {
  setState(() {
    widget.items.removeAt(index);
  });
}
~~~

### Instalando pacotes
* Aplicação ainda não tem memória e para persistir os dados (quando fecha o app) e como o app é bem pequeno vamos usar a memória no shared preferences
* No arquivo pubspec.yaml vamos adicionar os pacotes necessários
  * Importante ressaltar que esse tipo de arquivo (.yaml) é "orientado à identação", se não identar corretamente, não funciona.
* Dentro de dependencies inserir: shared_preferences: ^0.5.3
  * Importante fechar a aplicação antes de salvar
  * Quando salvar o flutter já irá rodar automaticamente o comando pub get e irá instalar as alterações no projeto
  * importar na main o 'package:shared_preferences/shared_preferences.dart'

### Lendo os itens
* Leitura de dados não pode ser real time então a função de load precisa ser assíncrona
* Vamos criar a função de load e a primeira coisa a fazer é instanciar o SharedPreferences

~~~
Future load() async {
  /* Primeiro passo: instanciar o shared preferences */
  /* Await: não prossegue com a função enquanto o shared preferences não estiver finalizado */
  var preferences = await SharedPreferences.getInstance();
  var data = preferences.getString('data');

  if (data != null) {
    /* Transfosmar a string em Json */
    /* Iterable: coluna que permite iterações */
    Iterable decoded = jsonDecode(data);

    /* Percorrer o Json e adicionar os itens na lista */
    /* map nesse caso funciona como um foreach */
    /* Pega o item no formato Json e insere no list*/
    List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

    /* Atualiza a página */
    setState(() {
      widget.items = result;
    });
  }
}
~~~

* Posteriormente precisamos chamar a função, mas fazendo isso no build seria ruim por que chamaria ela toda hora, então chamamos o construtor da _MyHomePageState com o método load dentro

~~~
/// @brief Chama o método load para a página
_MyHomePageState() {
  /* Não pode chamar no build, pois se não iria chamar o load toda hora */
  load();
}
~~~

### Salvando os itens