
HTTP interface


```
docker build -f Dockerfile.http -t llamafile .
docker run --gpus=all --rm -ti --network="host" llamafile
```


CLI

```
docker build -t llama -f Dockerfile.cli .
docker run --rm --gpus all llama "five reasons to get a pet skunk"
```



