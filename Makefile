BOOTLOADER_DIR := bootloader
KERNEL_DIR := kernel
USER_SPACE_DIR := user_space

BOOTLOADER_BIN := $(BOOTLOADER_DIR)/bootloader.bin
KERNEL_BIN := $(KERNEL_DIR)/kernel.bin
OS_IMAGE_BIN := os_image.bin

BOOTLOADER_ASM := $(BOOTLOADER_DIR)/bootloader.asm
KERNEL_C := $(KERNEL_DIR)/kernel.c
INTERRUPTS_ASM := $(KERNEL_DIR)/interrupts.asm
MEMORY_C := $(KERNEL_DIR)/memory.c
PROCESS_C := $(KERNEL_DIR)/process.c
FILESYSTEM_C := $(KERNEL_DIR)/filesystem.c
KEYBOARD_C := $(KERNEL_DIR)/device_drivers/keyboard.c
DISPLAY_C := $(KERNEL_DIR)/device_drivers/display.c
DISK_C := $(KERNEL_DIR)/device_drivers/disk.c
SHELL_C := $(USER_SPACE_DIR)/shell.c
USER_PROGRAMS_C := $(USER_SPACE_DIR)/user_programs.c

NASM := nasm
CC := gcc
LD := ld
CFLAGS := -m16 -c
LDFLAGS := -m elf_i386 -Ttext 0x1000 --oformat binary

.PHONY: all clean

all: $(OS_IMAGE_BIN)

$(OS_IMAGE_BIN): $(BOOTLOADER_BIN) $(KERNEL_BIN) $(SHELL_C) $(USER_PROGRAMS_C)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) $(SHELL_C) $(USER_PROGRAMS_C) > $(OS_IMAGE_BIN)

$(BOOTLOADER_BIN): $(BOOTLOADER_ASM)
	$(NASM) -f bin -o $@ $<

$(KERNEL_BIN): $(KERNEL_C) $(INTERRUPTS_ASM) $(MEMORY_C) $(PROCESS_C) $(FILESYSTEM_C) $(KEYBOARD_C) $(DISPLAY_C) $(DISK_C)
	$(CC) $(CFLAGS) -o $(KERNEL_DIR)/kernel.o $<
	$(NASM) -f elf $(INTERRUPTS_ASM) -o $(KERNEL_DIR)/interrupts.o
	$(CC) $(CFLAGS) -o $(KERNEL_DIR)/memory.o $(MEMORY_C)
	$(CC) $(CFLAGS) -o $(KERNEL_DIR)/process.o $(PROCESS_C)
	$(CC) $(CFLAGS) -o $(KERNEL_DIR)/filesystem.o $(FILESYSTEM_C)
	$(CC) $(CFLAGS) -o $(KERNEL_DIR)/device_drivers/keyboard.o $(KEYBOARD_C)
	$(CC) $(CFLAGS) -o $(KERNEL_DIR)/device_drivers/display.o $(DISPLAY_C)
	$(CC) $(CFLAGS) -o $(KERNEL_DIR)/device_drivers/disk.o $(DISK_C)
	$(LD) $(LDFLAGS) -o $@ $(KERNEL_DIR)/kernel.o $(KERNEL_DIR)/interrupts.o $(KERNEL_DIR)/memory.o $(KERNEL_DIR)/process.o $(KERNEL_DIR)/filesystem.o $(KERNEL_DIR)/device_drivers/keyboard.o $(KERNEL_DIR)/device_drivers/display.o $(KERNEL_DIR)/device_drivers/disk.o

clean:
	rm -f $(BOOTLOADER_BIN) $(KERNEL_BIN) $(OS_IMAGE_BIN) $(KERNEL_DIR)/*.o $(KERNEL_DIR)/device_drivers/*.o
