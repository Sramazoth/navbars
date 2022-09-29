import java.util.*;

public class NavBarClass {
	// LAYER 0
	List<String> _MENU_LAYER_0 = List.of("Fichier", "Commandes", "Options", "Infos");

	// LAYER 1
	Map _MENU_LAYER_1 = Map.of(
	    "Fichier", List.of("F1", "F2", "F3"),
	    "Commandes", List.of("C1", "C2", "C3", "C4", "C5", "C6"),
	    "Options", List.of("O1"),
	    "Infos", List.of("I1", "I2")
	);

	// LAYER 2
	Map _MENU_LAYER_1 = Map.of(
	    "F2", List.of("sub_F2_1", "sub_F2_2", "sub_F2_3", "sub_F2_4")
	);

	List<List<String>> hierarchie_menu = List.of(List.of(""));
	List<Integer> pos = List.of(0);

	int menu_level = 0;
	int box_size = 0;

	public void user_select(int user_input) {
		pos[pos.length-1] = (pos[pos.length-1] + user_input) % hierarchie_menu[hierarchie_menu.length-1].length;
	}

	public void display() {
		String cmd = "clear";
		Runtime run = Runtime.getRuntime();
		Process pr = run.exec(cmd);
		pr.waitFor();
		print("\033[2J\033[0;0H");
		int cpt_cursor = 0;
		String asterix;
		String space_between = "";
		print("'q' to quit");
		List<String> actual_displayed_menu = hierarchie_menu[hierarchie_menu.length-1];
		for (int i = 0; i < actual_displayed_menu.length; i++) {
			String onglet = actual_displayed_menu[i];
			if (cpt_cursor == pos[pos.length-1]) {
				asterix = "\033[30;107m*";
			} else {
				asterix = " ";
			}
			space_between = " " * (box_size - onglet.length);
			print(asterix + onglet + "\033[0m" + space_between);
			cpt_cursor++;
		}
		print("\033[5;0H");
	}



	public static void main(String[] args) {
		System.out.println("Wrong command, please use: java nav_java instead");
	}
}