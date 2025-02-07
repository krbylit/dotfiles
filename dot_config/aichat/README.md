# `aichat`

## Ollama integration

- Load our custom launch agent: `launchctl load ~/Library/LaunchAgents/com.ollama.server.plist`
- Pull models
  `ollama pull nomic-embed-text`
  `ollama pull deepseek-r1:14b`
- Set up RAG in a directory:
  `aichat` -> `.rag`

## Easy setup for casual users

- Install Ollama: (<https://ollama.com/>)
- Install Homebrew: in a terminal run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
  - NOTE: You may have to add Homebrew to your PATH. Instructions should be in the output from installing Homebrew
- Install `aichat`: `brew install aichat`
- Pull Ollama models
  `ollama pull nomic-embed-text`
  `ollama pull deepseek-r1:14b`
- Configure `aichat`

  - Create the file `~/.config/aichat/config.yaml` by running the following command in a terminal:

    ```
    mkdir -p ~/.config/aichat && cat > ~/.config/aichat/config.yaml << 'EOF'
    # ---- Behavior Settings ----
    stream: true # Enable streaming responses
    save: true # Persist messages
    keybindings: vi # Choose keybinding style (options: emacs, vi)
    editor: nvim # Command to edit input buffer or session
    wrap: auto # Enable automatic text wrapping
    wrap_code: false

    # ---- RAG Configuration ----

    rag_embedding_model: ollama:nomic-embed-text # Embedding model for context retrieval
    rag_reranker_model: null # Reranker model (set to null if not used)
    rag_top_k: 5 # Number of documents to retrieve for answering queries
    rag_chunk_size: 500 # Size of document chunks in characters
    rag_chunk_overlap: 50 # Overlap between chunks in characters
    rag_template: |
      Answer the query based on the context provided.

      Context:
      __CONTEXT__

      Query:
      __INPUT__

    # ---- Document Loaders ----

    document_loaders:
      pdf: "pdftotext \$1 -" # Command to load .pdf files
      docx: "pandoc --to plain \$1"

    # ---- LLM Configuration ----

    model: ollama:deepseek-r1:14b

    # temperature: 0.7 # Controls the creativity and randomness of the LLM's response

    # top_p: 0.9 # Alternative way to control LLM's output diversity, affecting the probability distribution of tokens

    # ---- Clients Configuration ----

    clients:
      - type: openai-compatible
        name: ollama
        api_base: http://localhost:11434/v1
    EOF

    ```

- Gather all documents you'd like to RAG over into one directory.
- Open a terminal in that directory and run:
  `aichat` -> `.rag` -> at 'Add documents:' prompt enter `./`
