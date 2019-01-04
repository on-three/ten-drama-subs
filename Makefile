
ifndef EP
# don't use leading zeroes when defining episode as bash interprets as octal
$(error episode number is not defined. e.g. EP=2)
endif

# specify season if necessary (defaults to 01)
SEASON ?= 01
# ensure season is in two digit format
SEASON := $(shell printf "%02d\n" $(SEASON))

# sometimes we want ep numbers in form '01' and sometimes just '1'
ZEP := $(shell printf "%02d\n" $(EP))
NEP := $(shell printf "%01d\n" $(EP))

GROUP := squap
QUALITY := 720p

EN_NAME := Ten.s$(SEASON)e$(ZEP)
JP_NAME := Ten.天.天和通りの快男児.第$(NEP)話
RELEASE_NAME := [${GROUP}]Ten.Tenhodoori.No.Kaidanji.s01e$(ZEP)[${QUALITY}]

#NAME ?= $(JP_NAME)
NAME ?= $(RELEASE_NAME)

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
GEN_MKV := ./gen.mkv.sh
MPV := mpv

all: $(MKV)

# if i need to convert from .flv to .mp4 this rule helps
mp4:
	ffmpeg -y -i $(FLV) -vcodec copy -acodec copy $(MP4)

raw: $(RAW)

$(OUT_DIR):
	mkdir -p $@

$(MKV): $(MP4) $(ASS_EN)	
	$(GEN_MKV) $(MP4) $(ASS_EN) $(MKV)

upload:
	$(UPLOAD) $(MKV)

play:
	$(MPV) $(MKV)
