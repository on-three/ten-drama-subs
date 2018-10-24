
ifndef EP
$(error episode number is not defined. e.g. EP=02)
endif

# specify season if necessary (defaults to 01)
SEASON ?= 01
# ensure season is in two digit format
SEASON := $(shell printf "%02d\n" $(SEASON))

# sometimes we want ep numbers in form '01' and sometimes just '1'
EP := $(shell printf "%02d\n" $(EP))
NEP := $(shell printf "%01d\n" $(EP))

EN_NAME := Ten.s$(SEASON)e$(EP)
JP_NAME := Ten.天.天和通りの快男児.第$(NEP)話

NAME ?= $(JP_NAME)

SUBS_DIR := .
DATA_DIR := .
VIDEO_DIR := ~/incoming/ten.fukumoto.drama
OUT_DIR := $(VIDEO_DIR)

# Inputs
FLV := $(VIDEO_DIR)/$(EN_NAME).flv
ASS_EN := $(SUBS_DIR)/$(EN_NAME).en_us.ass

# intermediate files and outputs
MKV := $(VIDEO_DIR)/$(NAME).mkv
MP4 := $(VIDEO_DIR)/$(EN_NAME).mp4

# tools
FFMPEG := ffmpeg
UPLOAD := tovps
all: $(MKV)


# if i need to convert from .flv to .mp4 this rule helps
mp4:
	ffmpeg -y -i $(FLV) -vcodec copy -acodec copy $(MP4)

raw: $(RAW)

$(OUT_DIR):
	mkdir -p $@

$(MKV): $(MP4) $(ASS_EN)
	$(FFMPEG) -y -i $(MP4) -i $(ASS_EN) \
	-map 0:v -map 0:a -map 1 \
	-vcodec copy -acodec copy \
	-metadata:s:s:0 language=eng -disposition:s:0 default \
	$@

upload:
	$(UPLOAD) $(MKV)

