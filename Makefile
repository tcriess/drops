VASM := vasmm68k_mot
VASMFLAGS_DEBUG := -Ftos -nowarn=62 -m68000 -no-fpu -no-opt
VASMFLAGS := -Ftos -nowarn=62 -m68000 -no-fpu -no-opt -nosym
MAIN := drops.s
TARGET_DEBUG := dropsd.tos
TARGET := drops.tos
PRECOMPUTE_DIFFS := precompute_diffs.py
OFFSET_SEQUENCES := offset_sequences.py
SPECTRUM_ANALYZER := spectrum_analyzer.py

.PHONY: all clean debug
all: $(TARGET)
debug: $(TARGET_DEBUG)

gen_diffs.s: $(PRECOMPUTE_DIFFS)
		python3 $(PRECOMPUTE_DIFFS) > gen_diffs.s

gen_drop_offsets.s: $(OFFSET_SEQUENCES)
		python3 $(OFFSET_SEQUENCES) > gen_drop_offsets.s

gen_spectrum_offsets.s: $(SPECTRUM_ANALYZER)
		python3 $(SPECTRUM_ANALYZER) > gen_spectrum_offsets.s

$(TARGET): $(wildcard *.s)
		$(VASM) $(VASMFLAGS) $(MAIN) -o $@

$(TARGET_DEBUG): $(wildcard *.s)
		$(VASM) $(VASMFLAGS_DEBUG) $(MAIN) -o $@

clean:
		rm -f $(TARGET)