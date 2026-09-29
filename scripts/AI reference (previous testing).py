import google.generativeai as genai
import os
from py4godot import gdclass, gdmethod
# Make absolutely sure this is the correct import for Node2D for your plugin version
from py4godot.classes.Node2D import Node2D
from py4godot.classes.Label import Label
from py4godot.classes.LineEdit import LineEdit

# --- Configure the API Key ---

@gdclass
class main(Node2D):

	output_label: Label = None
	input_line: LineEdit = None
	model = None # Will hold the initialized generative model
	chat = None  # Will hold the ongoing chat session

	@gdmethod
	def _ready(self):
		self.label_node = self.get_node("output_label")
		print("START INITIALISE")
		
		
		
		
		print("END INITIALISE") 
		self.initialize_ai()
	@gdmethod 
	def initialize_ai(self):
	  	
		try:
			# --- Configure API Key (Important!) ---
			# (e.g., from environment variable, config file)
			api_key = os.environ.get("GEMINI_API_KEY")
			if not api_key:
				 raise ValueError("GEMINI_API_KEY environment variable not set.")
			genai.configure(api_key=api_key)
			print("--- Gemini API Configured ---")

			# --- Create the Model (ONCE) ---
			# Store it in the instance variable 'self.ai_model'
			self.model = genai.GenerativeModel('gemini-2.0-flash') # Or your preferred model
			
			self.chat = self.model.start_chat(history=[])

		except Exception as e:
			error_msg = f"AI Initialization Error: {e}"
			print(f"--- {error_msg} ---")
			self.set_output_text(error_msg)
			# Ensure these are None if init fails
			self.model = None
			self.chat = None
	def set_label_text(self, new_text: str):
		self.label_node.text = str(new_text) 
		
	@gdmethod
	
	def _on_line_edit_text_submitted(self, new_text):
		
		

		# --- Generate Content (Simple Text Prompt) ---
		prompt = new_text

		try:
			print(prompt)
			response = self.chat.send_message(prompt)
			print(f"Chat Model: {response.text}")
			self.set_label_text(response.text)
		except Exception as e:
			print(f"\nAn error occurred during chat: {e}")


	
