ENCLAVE_NAME := focil
ETHEREUM_PACKAGE := github.com/ethpandaops/ethereum-package
CONFIG_FILE := kurtosis.config

.PHONY: run
run:
	kurtosis run $(ETHEREUM_PACKAGE) --enclave $(ENCLAVE_NAME) --args-file ./$(CONFIG_FILE).local.yaml

.PHONY: run-interop
run-interop:
	kurtosis run $(ETHEREUM_PACKAGE) --enclave $(ENCLAVE_NAME) --args-file ./$(CONFIG_FILE).local.interop.yaml

.PHONY: run-registry
run-registry:
	kurtosis run $(ETHEREUM_PACKAGE) --enclave $(ENCLAVE_NAME) --args-file ./$(CONFIG_FILE).registry.yaml

.PHONY: run-registry-interop
run-registry-interop:
	kurtosis run $(ETHEREUM_PACKAGE) --enclave $(ENCLAVE_NAME) --args-file ./$(CONFIG_FILE).registry.interop.yaml

.PHONY: stop
stop:
	kurtosis enclave rm $(ENCLAVE_NAME) -f
