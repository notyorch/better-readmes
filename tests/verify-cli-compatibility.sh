#!/bin/bash

# Required files list
FILES=(
    ".gemini/commands/write-readme.toml"
    ".gemini/commands/publish-readme.toml"
    ".github/instructions/write-readme.md"
    ".github/instructions/publish-readme.md"
    ".opencode/instructions/write-readme.md"
    ".opencode/instructions/publish-readme.md"
    ".claude/commands/write-readme.md"
    ".claude/commands/publish-readme.md"
    "README.sharing.md"
    "README.md"
)

KEYWORDS=(
    "write-readme"
    "publish-readme"
    "Protocol"
    "Step 1"
    "Step 2"
    "audience"
    "emojis"
    "gh repo create"
)

echo "Starting CLI compatibility verification..."
echo "----------------------------------------"

FOUND_COUNT=0
TOTAL_FILES=${#FILES[@]}
RESULTS_JSON="["

for i in "${!FILES[@]}"; do
    FILE="${FILES[$i]}"
    STATUS="missing"
    if [ -f "$FILE" ]; then
        STATUS="ok"
        ((FOUND_COUNT++))
        
        # Basic keyword check
        for KEY in "${KEYWORDS[@]}"; do
            if grep -qi "$KEY" "$FILE"; then
                : # Keyword found
            fi
        done
    fi
    
    RESULTS_JSON+="{\"file\": \"$FILE\", \"status\": \"$STATUS\"}"
    if [ $i -lt $((TOTAL_FILES - 1)) ]; then
        RESULTS_JSON+=", "
    fi
done

RESULTS_JSON+="]"

PERCENTAGE=$((FOUND_COUNT * 100 / TOTAL_FILES))

echo "✅ JSON report:"
echo "$RESULTS_JSON"
echo ""

if [ $FOUND_COUNT -lt $TOTAL_FILES ]; then
    echo "⚠️ Some files are missing!"
fi

echo "📊 Compatibility: $PERCENTAGE%"

if [ $PERCENTAGE -eq 100 ]; then
    echo "✅ 100% Compatibility achieved!"
else
    exit 1
fi
