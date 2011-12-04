RAILS_ROOT=../..
APP_PATH=$(RAILS_ROOT)/app
CONTROLLER=$(APP_PATH)/controllers
MODELS=$(APP_PATH)/models
TESTS=$(RAILS_ROOT)/test
RB_FILES=$(CONTROLLER)/*_controller.rb $(MODELS)/board.rb $(MODELS)/text.rb $(RAILS_ROOT)/config/routes.rb #$(TESTS)/unit/*.rb $(TESTS)/functional/*.rb 


all:
	cp $(RB_FILES) .
	rocco ./*.rb 
	rm ./*.rb

clean:
	-rm -rf *.html
