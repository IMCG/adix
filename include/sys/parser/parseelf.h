#ifndef _PARSEELF_H
#define _PARSEELF_H

#include <sys/memory/mm_struct.h>

#define EI_NIDENT 16
//p_flags
#define PT_E 0x1ULL
#define PT_W 0x2ULL
#define PT_R 0x4ULL


typedef struct {
	unsigned char e_ident[EI_NIDENT];
	uint16_t e_type;
	uint16_t e_machine;
	uint32_t e_version;
	uint64_t e_entry;
	uint64_t e_phoff;
	uint64_t e_shoff;
	uint32_t e_flags;
	uint16_t e_ehsize;
	uint16_t e_phentsize;
	uint16_t e_phnum;
	uint16_t e_shentsize;
	uint16_t e_shnum;
	uint16_t e_shstrndx;
}Elf64_Ehdr;

typedef struct {
	uint32_t   p_type;
	uint32_t   p_flags;
	uint64_t   p_offset;
	uint64_t   p_vaddr;
	uint64_t   p_paddr;
	uint64_t   p_filesz;
	uint64_t   p_memsz;
	uint64_t   p_align;
}Elf64_Phdr;

typedef struct {
uint32_t   sh_name;
uint32_t   sh_type;
uint64_t   sh_flags;
uint64_t   sh_addr;
uint64_t   sh_offset;
uint64_t   sh_size;
uint32_t   sh_link;
uint32_t   sh_info;
uint64_t   sh_addralign;
uint64_t   sh_entsize;
}Elf64_Shdr;

void read_elf_header(int fd, Elf64_Ehdr *elf_header);
void print_elf_header(Elf64_Ehdr elf_header);
int is_elf(Elf64_Ehdr elf_header);
void read_prgm_header(int fd, Elf64_Phdr *prgm_header);
void print_prgm_header(Elf64_Phdr prgm_header);
uint64_t load_elf(struct mm_struct *this, char* filename);
#endif
