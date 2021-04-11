#===============================================================
#Makefile for building MSP430 Code in command line environement 
#using the GCC Open Source Compiler for MSP430
#===============================================================

################# User Defined Variables #######################
# Project diretory
PROJECT_DIR       :=  $(shell pwd)
SOURCE_DIR        :=  $(PROJECT_DIR)/src
INCLUDE_DIR       :=  $(PROJECT_DIR)/inc
BUILD_DIR         :=  $(PROJECT_DIR)/build

# Name of device
DEVICE            :=  MSP430G2553

# Number of version
VERSION           :=  0.0.1

# Name of the final executable
TARGET            :=  test

# Decide whether the commands will be shown or not
VERBOSE           :=  FALSE

# Create a list of *.c sources in SOURCE_DIR
SOURCES           :=  $(wildcard $(SOURCE_DIR)/*.c)

# Define objects for all sources
OBJECTS           :=  $(subst src,build,$(SOURCES:.c=.o))
#####################################

################## GCC Root Variable ###################
GCC_DIR           ?=  ~/Embedded/Tools/Toolchains/msp430-gcc-linux64
GCC_MSP_INC_DIR   ?=  $(GCC_DIR)/include/msp
LDDIR             :=  $(GCC_MSP_INC_DIR)/$(shell echo $(DEVICE) | tr A-Z a-z)
######################################
GCC_BIN_DIR       ?=  $(GCC_DIR)/bin
GCC_INC_DIR       ?=  $(GCC_DIR)/msp430-elf/include
######################################
CC                :=  $(GCC_BIN_DIR)/msp430-elf-gcc
GDB               :=  $(GCC_BIN_DIR)/msp430-elf-gdb
######################################
CFLAGS            :=  -Os \
                      -D__$(DEVICE)__ \
                      -mmcu=$(DEVICE) \
                      -g -ffunction-sections \
                      -fdata-sections -DDEPRECATED
LDFLAGS           :=  -T $(LDDIR).ld \
                      -L $(GCC_MSP_INC_DIR) \
                      -mmcu=$(DEVICE) \
                      -g -Wl,--gc-sections
INCLUDES          :=  -I $(GCC_MSP_INC_DIR) \
                      -I $(GCC_INC_DIR) \
                      -I $(INCLUDE_DIR)
######################################

# Hide or not the calls depending of VERBOSE
ifeq ($(VERBOSE),TRUE)
    HIDE =	
else
    HIDE =	@
endif

.PHONY: all clean flash

all: $(TARGET)
$(OBJECTS): $(SOURCES)
	@echo ============================================
	@echo Making build directory
	$(HIDE)mkdir -p build
	@echo Compiling...
	$(HIDE)$(CC) $(INCLUDES) $(CFLAGS) -c $(SOURCES) -o $(OBJECTS)
	@echo ============================================
	
$(TARGET): $(OBJECTS)
	@echo ============================================
	@echo Linking objects and generating output binary
	$(HIDE)$(CC) $(LDFLAGS) $(OBJECTS) -o $(TARGET).out
	@echo Done.
	@echo ============================================

clean:
	@echo ============================================
	@echo Removing build directory
	$(HIDE)rm -rf build
	@echo Removing $(TARGET).out
	$(HIDE)rm -rf $(TARGET).out
	@echo Done.
	@echo ============================================

flash:
	@echo ============================================
	@echo Flashing $(TARGET).out t $(DEVICE)
	$(HIDE)mspdebug rf2500 "prog $(TARGET).out"
