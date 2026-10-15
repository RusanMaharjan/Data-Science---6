# Model

from google import genai
import os

# configure API Key
client = genai.Client(api_key = os.getenv('GEMINI_API_KEY'))

# API Model
def gemini_model(prompt):
    interaction = client.interactions.create(
        model = "gemini-3.8-flash",
        input = prompt
    )
    return interaction.output_text