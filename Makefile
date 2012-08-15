package_name = $(notdir $(CURDIR:.deb=))
package_version = 0.1
package_dir = $(package_name)-$(package_version)
package_file = $(package_name)_$(package_version).orig.tar.gz
package_url = https://github.com/l0b0/$(package_name)/tarball/v$(package_version)

.PHONY: all deb test clean

all: deb

$(package_file):
	wget -O $(package_file) $(package_url)

$(package_dir): $(package_file)
	tar -zxvf $(package_file) --transform 's#^[^/]*#$(package_dir)#'

$(package_dir)/debian: $(package_dir)
	cd $(package_dir) && yes | dh_make --copyright gpl3 --single

$(package_name).deb: $(package_dir)/debian

deb: $(package_name).deb
	false

test: compile
	false

clean:
	-rm -r $(package_dir)
	-rm $(package_file)

include make-includes/variables.mk
