APPNAME=tk-python-template
PORT=8081
TAG=latest
USERNAME=tk3413

etest:
	behave e2e/features

find:
	ps -fA | grep python

docker-build:
	docker buildx build --platform=linux/amd64 -t ${APPNAME}:${TAG} .

docker-build-local:
	docker buildx build -t ${APPNAME}:${TAG} .

docker-run:
	docker run -itd --rm --name ${APPNAME} -p ${PORT}:${PORT} ${APPNAME}:${TAG}

explore:
	docker run -it --rm --name teserver -p ${PORT}:${PORT} --entrypoint \
	/bin/sh ${APPNAME}:${TAG}

docker-publish:
	docker tag ${APPNAME}:${TAG} ${USERNAME}/${APPNAME}:${TAG}
	docker push ${USERNAME}/${APPNAME}:${TAG}
