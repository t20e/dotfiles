# Start the backend llama.cpp APIs for chat and autocomplete.
# VSC's Continue extension maps to the APIs

#!/usr/bin/env bash

usage(){
    echo "Usage: $0 [OPTION]"
    echo "Options:"
    echo "  (None)    Default: Starts ONLY the Autocomplete and Embeddings."
    echo "  --chat    Start ONLY the Chat model"
    echo "  --all     Start Autocomplete, Embeddings, and the Chat models"
    exit 1
}

# Parse command line flags
START_AUTOCOMPLETE=true
START_EMBEDDING=true
START_CHAT=false

case "$1" in
    --all)
        START_CHAT=true
        ;;
    --chat)
        START_AUTOCOMPLETE=false
        START_EMBEDDING=false
        START_CHAT=true
        ;;
    -h|--help)
        usage
        ;;
    *)
        if [ -n "$1" ]; then
            echo "Unknown option: $1"
            usage
        fi
        ;;
esac

# Kill old lingering instances
pkill -u "$(whoami)" -f llama-server

echo "Bootstrapping local llama.cpp cluster..."

autocompleteModel="ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF:Q8_0"
chatModel="ggml-org/gemma-4-31B-it-GGUF:Q4_K_M"
embeddingModel="nomic-ai/nomic-embed-text-v1.5-GGUF:Q4_K_M"


if [ "$START_EMBEDDING" = true ]; then
    # Setup Embedding server
    echo "  -> Launching Vector Embeddings on port: 8082"
    llama-server -hf $embeddingModel --port 8082 --embeddings --pooling mean -c 512 -ub 512 -t 2 --no-webui > /dev/null 2>&1 &
fi

if [ "$START_AUTOCOMPLETE" = true ]; then
    # Autocomplete Model - uses a smaller model for instant autocomplete suggestions
    echo "  -> Launching Autocomplete model on port: 8081"
    llama-server -hf $autocompleteModel --port 8081 -c 4096 -np 8 --no-webui > /dev/null 2>&1 &
fi

if [ "$START_CHAT" = true ]; then
    # Chat Model
    echo "  -> Launching large chat model on port: 8080"
    llama-server -hf $chatModel --port 8080 -c 16000 -np 8
else
    # Keep the script open to monitor the background components
    echo "Core coding stack active. Press Ctrl+C to quit and release models from VRAM."
    wait
fi
