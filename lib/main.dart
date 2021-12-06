import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExampleModelMutable {
  int x;
  int y;
  List<ExampleModelMutable> children;
  Map<String, ExampleModelMutable> mapChildren;

  ExampleModelMutable(
      {required this.x,
      required this.y,
      required this.children,
      required this.mapChildren});

  ExampleModelMutable copyWth(
      {int? x,
      int? y,
      List<ExampleModelMutable>? children,
      Map<String, ExampleModelMutable>? mapChildren}) {
    return ExampleModelMutable(
        x: x ?? this.x,
        y: y ?? this.y,
        children: children ?? this.children,
        mapChildren: mapChildren ?? this.mapChildren);
  }


}

class ExampleModel {
  final int x;
  final int y;
  final List<ExampleModel> children;
  final Map<String, ExampleModel> mapChildren;

  ExampleModel(
      {required this.x,
      required this.y,
      required this.children,
      required this.mapChildren});

  ExampleModel copyWth(
      {int? x,
      int? y,
      List<ExampleModel>? children,
      Map<String, ExampleModel>? mapChildren}) {
    return ExampleModel(
        x: x ?? this.x,
        y: y ?? this.y,
        children: children ?? this.children,
        mapChildren: mapChildren ?? this.mapChildren);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExampleModel &&
        other.x == x &&
        other.y == y &&
        listEquals(other.children, children) &&
        mapEquals(other.mapChildren, mapChildren);
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ children.hashCode ^ mapChildren.hashCode;
  }
}

void main() => runApp(GetMaterialApp(home: Home()));

class Controller extends GetxController {
  var a = 1.obs;
  var b = 2.obs;
  var c = 3.obs;
  var ls = ["A", "B", "C"].obs;
  var obj = ExampleModel(
      x: 1,
      y: 2,
      children: [ExampleModel(x: 3, y: 4, children: [], mapChildren: {})],
      mapChildren: {}).obs;
  var objm = ExampleModelMutable(x: 1, y: 2, children: [
    ExampleModelMutable(x: 3, y: 4, children: [], mapChildren: {})
  ], mapChildren: {}).obs;

  get aplusb {
    print("eval a+b!");
    return b.value + a.value;
  }

  int aplusbfn() {
    print("eval a+b fn!");
    return b.value + a.value;
  }

  incA() => a++;
  incB() => b++;
  incC() => c++;
  appendL() => ls.add("D");
  touchL1() => ls[0] = "A";
  touchL() {
    final ll = [...ls];
    ls.clear();
    ls.addAll(ll);
  }

  changeL1() => ls[0] = ls[0] + ls[0];

  incObjX() => obj.value = obj.value.copyWth(x: obj.value.x + 1);
  incObjY() => obj.map((data) => data!.copyWth(y: data.y + 1));
  incObjNestedY() => obj.map((data) => data!.copyWth(
      children: [data.children[0].copyWth(y: data.children[0].y + 1)]));

  incObjMX() => objm.update((val) {
        val?.x += 1;
      });
  incObjMY() => objm.update((val) {
        val?.y += 1;
      });
  incObjMNestedY() => objm.update((val) {
        val?.children[0].y += 1;
      });
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    // 使用Get.put()实例化你的类，使其对当下的所有子路由可用。
    final Controller c = Get.put(Controller());

    return Scaffold(
      // 使用Obx(()=>每当改变计数时，就更新Text()。
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.a}"))),

      // 用一个简单的Get.to()即可代替Navigator.push那8行，无需上下文！
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(onPressed: c.incA, child: Text("incA")),
              TextButton(onPressed: c.incB, child: Text("incB")),
              TextButton(onPressed: c.incC, child: Text("incC")),
              TextButton(onPressed: c.appendL, child: Text("appendL")),
              TextButton(onPressed: c.touchL1, child: Text("touchL1")),
              TextButton(onPressed: c.touchL, child: Text("touchL")),
              TextButton(onPressed: c.changeL1, child: Text("changeL1")),
              TextButton(onPressed: c.incObjX, child: Text("incObjX")),
              TextButton(onPressed: c.incObjY, child: Text("incObjY")),
              TextButton(
                  onPressed: c.incObjNestedY, child: Text("incObjNestedY")),
              TextButton(onPressed: c.incObjMX, child: Text("incObjMX")),
              TextButton(onPressed: c.incObjMY, child: Text("incObjMY")),
              TextButton(
                  onPressed: c.incObjMNestedY, child: Text("incObjMNestedY")),
            ],
          ),
          Obx(() {
            print("render A");
            return Text("A = ${c.a}");
          }),
          Obx(() {
            print("render B");
            return Text("B = ${c.b}");
          }),
          Obx(() {
            print("render A+B(get value)");
            return Text("A+B(get value) = ${c.aplusb}");
          }),
          Obx(() {
            print("render A+B(fn)");
            return Text("A+B(fn) = ${c.aplusbfn()}");
          }),
          Obx(() {
            print("render CA parent ");
            return Row(
              children: [
                Text("CA.A = ${c.a}"),
                Obx(() {
                  print("render CA child ");
                  return Text("CA.C = ${c.c}");
                })
              ],
            );
          }),
          Obx(() {
            print("render full List");
            return Text("List = ${c.ls.join(" ")}");
          }),
          Obx(() {
            print("render l[0]");
            return Text("l[0] = ${c.ls[0]}");
          }),
          Obx(() {
            print("render l[1]");
            return Text("l[1] = ${c.ls[1]}");
          }),
          Obx(() {
            print("render l.length");
            return Text("l.length = ${c.ls.length}");
          }),
          Obx(() {
            print("render l fristIndexOf B");
            return Text(
                "l first index of B = ${c.ls.indexWhere((element) => element == "D")}");
          }),
          Text("=============="),
          Obx(() {
            print("render obj.x");
            return Text("obj.x = ${c.obj.value.x}");
          }),
          Obx(() {
            print("render obj.y");
            return Text("obj.y = ${c.obj.value.y}");
          }),
          Obx(() {
            print("render obj.y + obj.x");
            return Text("obj.y + obj.x = ${c.obj.value.y + c.obj.value.x}");
          }),
          Obx(() {
            print("render obj.children[0].y");
            return Text(" obj.children[0].y = ${c.obj.value.children[0].y}");
          }),
          Text("=============="),
          Obx(() {
            print("render objm.x");
            return Text("objm.x = ${c.objm.value.x}");
          }),
          Obx(() {
            print("render objm.y");
            return Text("objm.y = ${c.objm.value.y}");
          }),
          Obx(() {
            print("render objm.y + objm.x");
            return Text("objm.y + objm.x = ${c.objm.value.y + c.objm.value.x}");
          }),
          Obx(() {
            print("render objm.children[0].y");
            return Text(" objm.children[0].y = ${c.objm.value.children[0].y}");
          }),
        ],
      )),
    );
  }
}

class ChildRenderWidget extends StatelessWidget {
  final ExampleModel model;

  const ChildRenderWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("render obj.children[0].y (nested widget)");
    return Text(" obj.children[0].y = ${model.y}");
  }
}

class Other extends StatelessWidget {
  // 你可以让Get找到一个正在被其他页面使用的Controller，并将它返回给你。
  final Controller c = Get.find();

  @override
  Widget build(context) {
    // 访问更新后的计数变量
    return Scaffold(body: Center(child: Text("${c.aplusb}")));
  }
}
