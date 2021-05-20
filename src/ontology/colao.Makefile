## Customize Makefile settings for colao
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

AISM_BASE="https://raw.githubusercontent.com/insect-morphology/aism/master/aism-base.owl"
mirror/aism-base.owl:
	if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I "$(AISM_BASE)" -o $@.tmp.owl && mv $@.tmp.owl $@; fi
.PRECIOUS: mirror/aism-base.owl
tmp/seed_aism_base.txt: mirror/aism-base.owl
	@if [ $(IMP) = true ]; then $(ROBOT) query -i $< -q ../sparql/terms.sparql $@; fi
imports/aism_import.owl: mirror/aism.owl tmp/seed_aism_base.txt
	@if [ $(IMP) = true ]; then $(ROBOT) remove -i $< -T tmp/seed_aism_base.txt --select complement --select "classes individuals" \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@; fi
.PRECIOUS: aism_import.owl

