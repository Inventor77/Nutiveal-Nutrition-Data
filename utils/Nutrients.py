class Nutrients:
    ```
        Data Format: {
            "name": String,
            "rda": Integer,
            "wiki": String,
            "required": Boolean,
            "type": String,
            "tui": Integer
        }
    ```
    def __init__(self, name, rda, wiki, required, Type, tui):
        self.name = name
        self.rda = rda
        self.wiki = wiki
        self.required = required
        self.type = Type
        self.tui = tui
    
    def read(self):
        data = dict()
        data["name"] = self.name
        data["rda"] = self.rda
        data["wiki"] = self.wiki
        data["required"] = self.required
        data["type"] = self.type
        data["tui"] = self.tui

        return data
    
    def update(self, name, rda, wiki, required, Type, tui):
        self.name = name
        self.rda = rda
        self.wiki = wiki
        self.required = required
        self.type = Type
        self.tui = tui
    