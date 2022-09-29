#!/usr/bin/python3.10
import sys, tty, termios, os

class NavBarClass:
    # LAYER 0
    _MENU_LAYER_0 = ['Fichier', 'Commandes', 'Options', 'Infos']
    # LAYER 1
    _MENU_LAYER_1 = {
        'Fichier'   : ['F1', 'F2', 'F3'],
        'Commandes' : ['C1', 'C2', 'C3', 'C4', 'C5', 'C6'],
        'Options'   : ['O1'],
        'Infos'     : ['I1', 'I2']    
    }
    # LAYER 2
    _MENU_LAYER_2 = {
        'F2'        : ['sub_F2_1', 'sub_F2_2', 'sub_F2_3', 'sub_F2_4']
    }

    hierarchie_menu = ['']
    pos             = ['']

    menu_level = 0;
    box_size   = 0;

    def user_select(self, user_input:int):
        self.pos[len(self.pos)-1] = (self.pos[len(self.pos)-1] + user_input) % len(self.hierarchie_menu[len(self.hierarchie_menu)-1]);

    def display(self):
        os.system("clear")
        print("\x1B[2J\x1B[0;0H")
        cpt_cursor = 0
        print("'q' to quit")
        for onglet in self.hierarchie_menu[len(self.hierarchie_menu)-1]:
            if cpt_cursor == self.pos[len(self.pos)-1]:
                asterix = "\x1B[30;107m*"
            else:
                asterix = " "
            space_between = " " * (self.box_size - len(onglet))
            print(asterix + onglet + "\x1B[0m" + space_between, end='')
            cpt_cursor += 1
        print("\x1B[5;0H")

    def debug(self):
        d_pos = self.pos[len(self.pos)-1]
        print('pos: ' + str(d_pos))

    def quit_menu(self):
        if self.menu_level == 0:
            return -1;
        else:
            self.hierarchie_menu.pop()
            self.pos.pop()
            self.menu_level -= 1
            return self.menu_level

    def const_refresh(self):
        self.menu_level += 1
        self.pos.append(0)

    def reset_box(self, init:int):
        if init == 1: # LAYER 0
            self.hierarchie_menu[0] = self._MENU_LAYER_0
            self.pos[0] = 0
        else:
            if self.menu_level == 0: # LAYER 1
                if self.hierarchie_menu[len(self.hierarchie_menu)-1][self.pos[len(self.pos)-1]] in self._MENU_LAYER_1:
                    self.hierarchie_menu.append(self._MENU_LAYER_1[self.hierarchie_menu[len(self.hierarchie_menu)-1][self.pos[len(self.pos)-1]]])
                    self.const_refresh()
            elif self.menu_level == 1: # LAYER 2
                if self.hierarchie_menu[len(self.hierarchie_menu)-1][self.pos[len(self.pos)-1]] in self._MENU_LAYER_2:
                    self.hierarchie_menu.append(self._MENU_LAYER_2[self.hierarchie_menu[len(self.hierarchie_menu)-1][self.pos[len(self.pos)-1]]])
                    self.const_refresh()               
        self.reset_size()

    def reset_size(self):
        self.box_size = len(self.hierarchie_menu[len(self.hierarchie_menu)-1][0])
        for onglet in self.hierarchie_menu[len(self.hierarchie_menu)-1]:
            if self.box_size < len(onglet):
                self.box_size = len(onglet)
        self.box_size += 2

def char_user_input():
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch

if __name__ == "__main__":
    my_bar = NavBarClass()
    my_bar.reset_box(init=1)
    my_bar.display()
    my_bar.debug()

    while 1:
        inputy = char_user_input()

        if ord(inputy) == 27:
            inputy = char_user_input()
            if ord(inputy) == 91:
                inputy = char_user_input()
                # if inputy == 65: print("top arrow")
                # if inputy == 66: print("bottom arrow")
                if ord(inputy) == 67:
                    my_bar.user_select(user_input=1)
                    # print("right arrow")
                if ord(inputy) == 68:
                    my_bar.user_select(user_input=-1)
                    # print("left arrow")
        elif ord(inputy) == 13: # == 'enter'
            my_bar.reset_box(0)
        elif inputy == 'q':
            if my_bar.quit_menu() == -1:
                os.system("clear")
                break
            my_bar.reset_size()
        my_bar.display()
        my_bar.debug()





