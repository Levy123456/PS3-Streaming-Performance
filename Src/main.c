#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <io/pad.h>

#define MENU_ITEMS 5

static const char *menu_items[MENU_ITEMS] = {
	"Streaming Performance",
	"Graphics Boost",
	"FPS Settings",
	"Controller Settings",
	"System Information"
};

static int selected = 0;

static void show_menu(void)
{
	int i;

	printf("\n");
	printf("====================================\n");
	printf(" PS3 STREAMING PERFORMANCE\n");
	printf("====================================\n");

	for (i = 0; i < MENU_ITEMS; i++) {
		if (i == selected)
			printf(" > %s\n", menu_items[i]);
		else
			printf("   %s\n", menu_items[i]);
	}

	printf("------------------------------------\n");
	printf(" X: Selecionar | START + SELECT: Sair\n");
	printf("====================================\n");
}

int main(void)
{
	padInfo pad_info;
	padData pad_data;
	int previous_up = 0;
	int previous_down = 0;
	int previous_cross = 0;
	int i;

	memset(&pad_info, 0, sizeof(pad_info));
	memset(&pad_data, 0, sizeof(pad_data));

	printf("Inicializando PS3 Streaming Performance...\n");

	if (ioPadInit(7) != 0) {
		printf("Erro ao inicializar o controle.\n");
		return 1;
	}

	printf("Controle inicializado.\n");
	show_menu();

	while (1) {
		ioPadGetInfo(&pad_info);

		/* Procura o primeiro controle ativo entre as portas 0 e 6 */
		for (i = 0; i < MAX_PADS; i++) {
			if (pad_info.status[i]) {
				ioPadGetData(i, &pad_data);

				/* Garante que ha novos dados validos neste frame */
				if (pad_data.len > 0) {
					int up = (pad_data.button[2] & PAD_CTRL_UP) != 0;
					int down = (pad_data.button[2] & PAD_CTRL_DOWN) != 0;
					int start = (pad_data.button[2] & PAD_CTRL_START) != 0;
					int select = (pad_data.button[2] & PAD_CTRL_SELECT) != 0;
					int cross = (pad_data.button[3] & PAD_CTRL_CROSS) != 0;

					if (start && select) {
						printf("Encerrando aplicativo...\n");
						goto sair;
					}

					if (up && !previous_up) {
						selected--;
						if (selected < 0)
							selected = MENU_ITEMS - 1;
						show_menu();
					}

					if (down && !previous_down) {
						selected++;
						if (selected >= MENU_ITEMS)
							selected = 0;
						show_menu();
					}

					if (cross && !previous_cross) {
						printf("\nOpcao selecionada: %s\n", menu_items[selected]);
						printf("Funcionalidade em desenvolvimento.\n");
					}

					previous_up = up;
					previous_down = down;
					previous_cross = cross;
				}
				break; /* Usa apenas o primeiro controle encontrado */
			}
		}

		usleep(16000);
	}

sair:
	ioPadEnd();
	printf("PS3 Streaming Performance encerrado.\n");

	return 0;
}
