class Nutrients:
    ```
        Data Format: {
            "name": String,
            "usda_id": String,
            "fat": Integer,
            "calories": Float,
            "proteins": Integer,
            "carbohydrates": Integer,
            "serving": Integer,
            "nutrients": Object
        }
    ```
    def __init__(self, name, usda_id, fat, calories, proteins, carbohydrates, serving, nutrients):
        self.name = name
        self.usda_id = usda_id
        self.fat = fat
        self.calories = calories
        self.proteins = proteins
        self.carbohydrates = carbohydrates
        self.nutrients = nutrients
        self.serving = serving
    
    def read(self):
        data = dict()
        data["name"] = self.name
        data["usda_id"] = self.usda_id
        data["fat"] = self.fat
        data["calories"] = self.calories
        data["proteins"] = self.proteins
        data["carbohydrates"] = self.carbohydrates
        data["nutrients"] = self.nutrients
        data["serving"]self.serving

        return data
    
    def update(self, name, rda, wiki, required, Type, tui):
        self.name = name
        self.usda_id = usda_id
        self.fat = fat
        self.calories = calories
        self.proteins = proteins
        self.carbohydrates = carbohydrates
        self.nutrients = nutrients
        self.serving = serving
    