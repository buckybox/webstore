bind 'unix:///home/buckybox/webstore/shared/puma.sock'
threads 8, 32
workers 2
preload_app!
