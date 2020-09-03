import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner:
          false, //tira aquela tirinha de debug que fica na tela
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

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

class _MyHomePageState extends State<MyHomePage> {
  var newTaskController = TextEditingController();

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
      body: ListView.builder(
        itemCount: widget.items.length,
        /* Quantidade que a lista possui naquele momento */
        itemBuilder: (BuildContext context, int index) {
          /* Função que determina como os itens devem ser construidos na tela */
          final item = widget.items[index]; /* Limpando o código */

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
        },
      ),
      floatingActionButton: FloatingActionButton(
        /* Determinar que o onpressed chame a função add, não pode usar () */
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
