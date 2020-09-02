# Flutter

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