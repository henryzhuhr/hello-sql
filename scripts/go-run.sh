if [ -z PG_CONNECTION_URL ]; then
    echo "PG_CONNECTION_URL is not set"
    exit 1
fi

go run main.go -postgres_connect_url=$PG_CONNECTION_URL