#!/home/user/Modèles/flutter/bin/dart

import 'dart:convert';
import 'dart:io';

class NavBarClass {
  // LAYER 0
  List<String> my_menu = ['Fichier', 'Commandes', 'Options', 'Infos'];

  // LAYER 1
  List<String> sub_menu_fichier = ['F1', 'F2', 'F3'];
  List<String> sub_menu_commandes = ['C1', 'C2', 'C3', 'C4', 'C5', 'C6'];
  List<String> sub_menu_options = ['O1'];
  List<String> sub_menu_infos = ['I1', 'I2'];

  // LAYER 2
  List<String> sub_sub_menu_fichier_F2 = ['sub_F2_1', 'sub_F2_2', 'sub_F2_3', 'sub_F2_4'];


  List<List<String>> hierarchie_menu = [ [''] ];
  List<int> pos = [0];

  int menu_level = 0;
  int box_size = 0;

  void user_select(int user_input) {
    pos[pos.length-1] = (pos[pos.length-1] + user_input) % hierarchie_menu[hierarchie_menu.length-1].length;
  }

  void display() {
    print(Process.runSync("clear", [], runInShell: true).stdout);
    print("\x1B[2J\x1B[0;0H");
    int cpt_cursor = 0;
    String asterix;
    String space_between = "";
    print("'q' to quit");
    for (String onglet in hierarchie_menu[hierarchie_menu.length-1]) {
      if (cpt_cursor == pos[pos.length-1]) {
        asterix = "\x1B[30;107m*";
      } else {
        asterix = " ";
      }
      space_between = " " * (box_size - onglet.length);
      stdout.write("$asterix$onglet\x1B[0m$space_between");
      cpt_cursor++;
    }
    print("\x1B[5;0H");
  }

  void debug() {
    int d_pos = pos[pos.length-1];
    print('pos: $d_pos');
  }

  int quit_menu() {
    if (menu_level==0) {
      return -1;
    } else {
      hierarchie_menu.removeLast();
      pos.removeLast();
      menu_level--;
      return menu_level;
    }
  }

  void const_refresh() {
    menu_level++;
    pos.add(0);
  }

  void reset_box(bool init) {
    if (init) { // LAYER 0
      hierarchie_menu[0] = my_menu;
      pos[0] = 0;
    } else {
      if (menu_level == 0) { // LAYER 1
        switch (hierarchie_menu[hierarchie_menu.length-1][pos[pos.length-1]]) {
          case 'Fichier':
            hierarchie_menu.add(sub_menu_fichier);
            const_refresh();
            break;
          case 'Commandes':
            hierarchie_menu.add(sub_menu_commandes);
            const_refresh();
            break;
          case 'Options':
            hierarchie_menu.add(sub_menu_options);
            const_refresh();
            break;
          case 'Infos':
            hierarchie_menu.add(sub_menu_infos);
            const_refresh();
            break;
        }
      } else if (menu_level == 1) { // LAYER 2
        switch (hierarchie_menu[hierarchie_menu.length-1][pos[pos.length-1]]) {
          case 'F2':
            hierarchie_menu.add(sub_sub_menu_fichier_F2);
            const_refresh();
            break;
        }
      }
    }
    reset_size();
  }

  void reset_size() {
    box_size = hierarchie_menu[hierarchie_menu.length-1][0].length;
    for (String onglet in hierarchie_menu[hierarchie_menu.length-1]) {
      if (box_size < onglet.length) {
        box_size = onglet.length;
      }
    }
    box_size += 2;
  }
}

NavBarClass my_bar = NavBarClass();

void main() {
  my_bar.reset_box(true);
  my_bar.display();
  my_bar.debug();

  int inputy;
  while (true) {
    inputy = getch();
    print(inputy);
    if (inputy == 27) {
      inputy = getch();
      if (inputy == 91) {
        inputy = getch();
        // if (inputy == 65) print("top arrow");
        // if (inputy == 66) print("bottom arrow");
        if (inputy == 67) {
          my_bar.user_select(1);
          // print("right arrow");
        }
        if (inputy == 68) {
          my_bar.user_select(-1);
          // print("left arrow");
        }
      }
    } else if (inputy == 10) { // == 'enter'
      my_bar.reset_box(false);
    } else if (inputy == 113) { // == 'q'
      if (my_bar.quit_menu() == -1) {
        print(Process.runSync("clear", [], runInShell: true).stdout);
        break;
      }
      my_bar.reset_size();
    }
    my_bar.display();
    my_bar.debug();
  }
}

int getch() {
  stdin.echoMode = false;
  stdin.lineMode = false;
  return stdin.readByteSync();
}