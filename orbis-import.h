#ifndef ORBIS_IMPORT_H
#define ORBIS_IMPORT_H

#include "orbis-toolchain-public.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

/* These fields must always come at the beginning of the NID-bearing structs */
typedef struct {
	char *name;
	uint32_t NID;
} orbis_imports_common_fields;

typedef struct {
	char *name;
	uint32_t NID;
} orbis_imports_stub_t;

typedef struct {
	char *name;
	uint32_t NID;
	bool is_kernel;
	orbis_imports_stub_t **functions;
	orbis_imports_stub_t **variables;
	int n_functions;
	int n_variables;
	uint32_t flags;
} orbis_imports_module_t;

typedef struct {
	char *name;
	uint32_t NID;
	orbis_imports_module_t **modules;
	int n_modules;
} orbis_imports_lib_t;

typedef struct {
	char *firmware;
	char *postfix;
	orbis_imports_lib_t **libs;
	int n_libs;
} orbis_imports_t;


ORBIS_TOOLCHAIN_PUBLIC orbis_imports_t *orbis_imports_load(const char *filename, int verbose);
ORBIS_TOOLCHAIN_PUBLIC orbis_imports_t *orbis_imports_loads(FILE *text, int verbose);

ORBIS_TOOLCHAIN_PUBLIC orbis_imports_t *orbis_imports_new(int n_libs);
ORBIS_TOOLCHAIN_PUBLIC void orbis_imports_free(orbis_imports_t *imp);

ORBIS_TOOLCHAIN_PUBLIC orbis_imports_lib_t *orbis_imports_find_lib(orbis_imports_t *imp, uint32_t NID);


ORBIS_TOOLCHAIN_PUBLIC orbis_imports_lib_t *orbis_imports_lib_new(const char *name, uint32_t NID, int n_modules);
ORBIS_TOOLCHAIN_PUBLIC void orbis_imports_lib_free(orbis_imports_lib_t *lib);

ORBIS_TOOLCHAIN_PUBLIC orbis_imports_module_t *orbis_imports_find_module(orbis_imports_lib_t *lib, uint32_t NID);


ORBIS_TOOLCHAIN_PUBLIC orbis_imports_module_t *orbis_imports_module_new(const char *name, bool kernel, uint32_t NID, int n_functions, int n_variables);
ORBIS_TOOLCHAIN_PUBLIC void orbis_imports_module_free(orbis_imports_module_t *mod);

ORBIS_TOOLCHAIN_PUBLIC orbis_imports_stub_t *orbis_imports_find_function(orbis_imports_module_t *mod, uint32_t NID);
ORBIS_TOOLCHAIN_PUBLIC orbis_imports_stub_t *orbis_imports_find_variable(orbis_imports_module_t *mod, uint32_t NID);


ORBIS_TOOLCHAIN_PUBLIC orbis_imports_stub_t *orbis_imports_stub_new(const char *name, uint32_t NID);
ORBIS_TOOLCHAIN_PUBLIC void orbis_imports_stub_free(orbis_imports_stub_t *stub);

#endif