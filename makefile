ifdef RELEASE
	APP_VERSION := $(RELEASE)
else
	APP_VERSION := latest
endif

ifdef GH_USER
	REPO := ghcr.io/$(GH_USER)/
else
	REPO :=
endif

format:
	black src/

lint:
	flake8 src/

build-container:
	docker build -t $(REPO)gradio-aks:$(APP_VERSION) -f build/Dockefile .

tag-container: build-container
	docker tag $(REPO)gradio-aks:$(APP_VERSION) $(REPO)gradio-aks:latest

push-container: tag-container
	docker push $(REPO)gradio-aks:$(APP_VERSION)
	docker push $(REPO)gradio-aks:latest

gradio:
	python src/app.py
