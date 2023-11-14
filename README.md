# myblog

## Installation
Make sure you have Python installed. You can download it from [python.org](https://www.python.org/downloads/).

Open a terminal or command prompt.

Run the following command to install the Blag tool:
```bash
pip install blag
```

### Add extension [Run on Save](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave)

Open vscode preferences `json`
Add the following settings: 
```json
{
    "emeraldwalk.runonsave": {
        "commands": [
            {
                "match": ".*",
                "isAsync": true,
                "cmd": "blag build"
            }
        ]
    }
}
```

### Add extension [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)

Open terminal 
```bash
cd build
code .
```
Right click `index.html` -> Open with 'Five Server'

Open web browser locally and view generated pages.  

## Usage
Create your markdown files in the `content` directory.

Run the following command to build static HTML files:
```bash
blag build
```
Your generated HTML files will be available in the `build` directory.

## Resources
[Python](https://www.python.org/)
[Blag Documentation](https://blag.readthedocs.io/en/latest/)