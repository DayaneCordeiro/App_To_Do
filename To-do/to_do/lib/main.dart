import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      /* remove aquela tirinha de debug que fica na tela */
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
    // items.add(Item(title: "Item 1", done: false));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
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

  /// @brief Remove uma determinada tarefa quando ela é arrastada pro lado
  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  /// @brief Carrega os dados que estão guardados
  /* Future é uma promessa */
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

  /// @brief Chama o método load para a página
  _MyHomePageState() {
    /* Não pode chamar no build, pois se não iria chamar o load toda hora */
    load();
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
        /* Quantidade que a lista possui naquele momento */
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          /* Função que determina como os itens devem ser construidos na tela */
          final item = widget.items[index]; /* Limpando o código */

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
