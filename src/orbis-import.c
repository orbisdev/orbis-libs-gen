#include "orbis-import.h"
#include <stdlib.h>
#include <string.h>

orbis_imports_t *orbis_imports_new(int n_libs)
{
	orbis_imports_t *imp = malloc(sizeof(*imp));
	if (imp == NULL)
		return NULL;

	imp->postfix = calloc(64, sizeof(char));

	imp->firmware = NULL;

	imp->n_libs = n_libs;

	imp->libs = calloc(n_libs, sizeof(*imp->libs));

	return imp;
}

void orbis_imports_free(orbis_imports_t *imp)
{
	if (imp) {
		int i;
		for (i = 0; i < imp->n_libs; i++) {
			orbis_imports_lib_free(imp->libs[i]);
		}

		if (imp->firmware)
			free(imp->firmware);

		free(imp->postfix);
		free(imp);
	}
}

orbis_imports_lib_t *orbis_imports_lib_new(const char *name, uint32_t NID, int n_modules)
{
	orbis_imports_lib_t *lib = malloc(sizeof(*lib));
	if (lib == NULL)
		return NULL;

	lib->name = strdup(name);
	lib->NID = NID;
	lib->n_modules = n_modules;

	lib->modules = calloc(n_modules, sizeof(*lib->modules));

	return lib;
}


orbis_imports_module_t *orbis_imports_module_new(const char *name, bool kernel, uint32_t NID, int n_functions, int n_variables)
{
	orbis_imports_module_t *mod = malloc(sizeof(*mod));
	if (mod == NULL)
		return NULL;

	mod->name = strdup(name);
	mod->NID = NID;
	mod->is_kernel = kernel;
	mod->n_functions = n_functions;
	mod->n_variables = n_variables;

	mod->functions = calloc(n_functions, sizeof(*mod->functions));

	mod->variables = calloc(n_variables, sizeof(*mod->variables));

	return mod;
}

void orbis_imports_module_free(orbis_imports_module_t *mod)
{
	if (mod) {
		int i;
		for (i = 0; i < mod->n_variables; i++) {
			orbis_imports_stub_free(mod->variables[i]);
		}
		for (i = 0; i < mod->n_functions; i++) {
			orbis_imports_stub_free(mod->functions[i]);
		}
		free(mod->name);
		free(mod);
	}
}


void orbis_imports_lib_free(orbis_imports_lib_t *lib)
{
	if (lib) {
		int i;
		for (i = 0; i < lib->n_modules; i++) {
			orbis_imports_module_free(lib->modules[i]);
		}
		free(lib->name);
		free(lib);
	}
}

orbis_imports_stub_t *orbis_imports_stub_new(const char *name, uint32_t NID)
{
	orbis_imports_stub_t *stub = malloc(sizeof(*stub));
	if (stub == NULL)
		return NULL;

	stub->name = strdup(name);
	stub->NID = NID;

	return stub;
}

void orbis_imports_stub_free(orbis_imports_stub_t *stub)
{
	if (stub) {
		free(stub->name);
		free(stub);
	}
}

/* For now these functions are just dumb full-table searches.  We can implement qsort/bsearch/whatever later if necessary. */

static orbis_imports_common_fields *generic_find(orbis_imports_common_fields **entries, int n_entries, uint32_t NID) {
	int i;
	orbis_imports_common_fields *entry;

	for (i = 0; i < n_entries; i++) {
		entry = entries[i];
		if (entry == NULL)
			continue;

		if (entry->NID == NID)
			return entry;
	}

	return NULL;
}

orbis_imports_lib_t *orbis_imports_find_lib(orbis_imports_t *imp, uint32_t NID) {
	return (orbis_imports_lib_t *)generic_find((orbis_imports_common_fields **)imp->libs, imp->n_libs, NID);
}
orbis_imports_module_t *orbis_imports_find_module(orbis_imports_lib_t *lib, uint32_t NID) {
	return (orbis_imports_module_t *)generic_find((orbis_imports_common_fields **)lib->modules, lib->n_modules, NID);
}
orbis_imports_stub_t *orbis_imports_find_function(orbis_imports_module_t *mod, uint32_t NID) {
	return (orbis_imports_stub_t *)generic_find((orbis_imports_common_fields **)mod->functions, mod->n_functions, NID);
}
orbis_imports_stub_t *orbis_imports_find_variable(orbis_imports_module_t *mod, uint32_t NID) {
	return (orbis_imports_stub_t *)generic_find((orbis_imports_common_fields **)mod->variables, mod->n_variables, NID);
}
