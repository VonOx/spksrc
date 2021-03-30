SPK_NAME = gladysassistant
SPK_VERS = 20213003
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png
SPK_DEPENDS = "Docker>=18.09.0-0506"
DSM_UI_DIR = app

REQUIRED_DSM = 6.2

DEPENDS =

MAINTAINER = vkulak62@gmail.com
DESCRIPTION = "A privacy-first, open-source home assistant"
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Gladys Assistant
CHANGELOG = ""

UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE   = https://gladysassistant.com/
LICENSE    = Apache License 2.0
HELPURL    = https://gladysassistant.com/docs/

WIZARDS_DIR = src/wizard/

SERVICE_SETUP = src/service-setup.sh

#DSM UI integration
SERVICE_PORT = 8420

INSTALL_DEP_SERVICES = Docker
START_DEP_SERVICES = Docker

COPY_TARGET = nop

POST_STRIP_TARGET = gladysassistant_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: gladysassistant_extra_install
gladysassistant_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/gladysassistant.sh $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/gladysassistant.json $(STAGING_DIR)/var/gladysassistant.dist
