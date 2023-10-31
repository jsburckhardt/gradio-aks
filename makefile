ifdef RELEASE
	APP_VERSION := $(RELEASE)
else
	APP_VERSION := latest
endif

ifdef GH_USER
	REPO := ghcr.io/$(GH_USER)/gradio-aks/
else
	REPO :=
endif

format:
	black src/

lint:
	flake8 src/

build-container:
	docker build -t $(REPO)chatbot:$(APP_VERSION) -f build/Dockerfile .

tag-container: build-container
	docker tag $(REPO)chatbot:$(APP_VERSION) $(REPO)chatbot:latest

push-container: tag-container
	docker push $(REPO)chatbot:$(APP_VERSION)
	docker push $(REPO)chatbot:latest
	trivy image --format spdx-json -o build/sbom.spdx.json "$(REPO)chatbot:$(APP_VERSION)"

gradio:
	python src/app.py
