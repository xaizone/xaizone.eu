pre-build:
	mkdir -p data && > data/assets.yaml && for f in assets/*.*; do echo $${f##*/}: "$$( git log --date=format:"%Y-%m-%d %H:%M:%S" --pretty="%ad" -1 $$f)" >> data/assets.yaml; done

build: pre-build
	hugo --minify

clean:
	rm -rf public/