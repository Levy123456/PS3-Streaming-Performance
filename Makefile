.SUFFIXES:
ifeq ($(strip $(PSL1GHT)),)
$(error "PSL1GHT não está configurado no ambiente.")
endif
include $(PSL1GHT)/ppu_rules
TARGET := PS3StreamingPerformance
BUILD := build
SOURCES := Src
DATA :=
SHADERS :=
INCLUDES :=
TITLE := PS3 Streaming Performance
APPID := LVP000001
CONTENTID := UP0001-$(APPID)_00-0000000000000000
CFLAGS := -Wall -mcpu=cell $(MACHDEP) $(INCLUDE)
CXXFLAGS := $(CFLAGS)
LDFLAGS := $(MACHDEP)
LIBS := -lrsx -lgcm_sys -lio -lsysutil -lrt -llv2 -lm
ifneq ($(BUILD),$(notdir $(CURDIR)))
export OUTPUT := $(CURDIR)/$(TARGET)
export VPATH := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir))
export DEPSDIR := $(CURDIR)/$(BUILD)
export BUILDDIR := $(CURDIR)/$(BUILD)
CFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
ifeq ($(strip $(CPPFILES)),)
export LD := $(CC)
else
export LD := $(CXX)
endif
export OFILES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o)
export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
$(LIBPSL1GHT_INC) \
-I$(CURDIR)/$(BUILD)export LIBPATHS := $(LIBPSL1GHT_LIB)
.PHONY: all clean pkg
all: $(OUTPUT).self
$(BUILD):
@mkdir -p $(BUILD)
@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile
clean:
@rm -rf $(BUILD) $(OUTPUT).elf $(OUTPUT).self
pkg: $(BUILD) $(OUTPUT).pkg
else
DEPENDS := $(OFILES:.o=.d)
$(OUTPUT).self: $(OUTPUT).elf
$(OUTPUT).elf: $(OFILES)
-include $(DEPENDS)
endif
