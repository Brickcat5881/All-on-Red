#Godot Imports
from py4godot import gdmethod, gdproperty
from py4godot.methods import private
from py4godot.signals import signal, SignalArg
from py4godot.classes import gdclass
from py4godot.classes.core import Vector3, Rect2, Callable
from py4godot.classes.Node import Node
from py4godot.classes.Node2D import Node2D
from py4godot.classes.Label import Label
from py4godot.classes.LineEdit import LineEdit
from py4godot.classes.FileAccess import FileAccess
from py4godot.classes.Sprite2D import Sprite2D
from py4godot.classes.Timer import Timer
from py4godot.classes.Button import Button
from py4godot.classes.AudioStreamPlayer2D import AudioStreamPlayer2D
from py4godot.classes.AudioStream import AudioStream
from py4godot.classes.Image import Image
from py4godot.singletons import get_singleton
from py4godot.classes.AnimationPlayer import AnimationPlayer
from py4godot.classes.OptionButton import OptionButton
from py4godot.classes.Texture2D import Texture2D
#GenAI Imports
import google.generativeai as genai
import os
from dotenv import load_dotenv

#Other Imports
import random
from deuces import Evaluator, Card
import itertools

@gdclass
class poker_game_processing(Node):
	
	#GUI
	chipLabel: Label = None
	label: Label = None
	input: LineEdit = None
	playerPotLabel: Label = None
	AIPotLabel: Label = None
	foldButton: Button = None
	checkButton: Button = None
	betButton: Button = None
	callButton: Button = None
	AIMovesLabel: Label = None
	newGameButton: Button = None
	newGameButtonTexture: Texture2D = None
	AIMove: Label = None
	popupLabel: Label = None
	cheatOptionButton: OptionButton = None
	cheatButton: Button = None
	#HandCards
	handCard1: Sprite2D = None
	handCard2: Sprite2D = None
	#TableCards
	tableCard1: Sprite2D = None
	tableCard2: Sprite2D = None
	tableCard3: Sprite2D = None
	tableCard4: Sprite2D = None
	tableCard5: Sprite2D = None
	#Other
	parentNode: Node2D = None
	tableAnimationPlayer: AnimationPlayer = None
	AITimer: Timer = None
	
	model = None
	chat = None
	chips = 0
	AIChips = 1000
	playerPot = 0
	AIPot = 0
	save_path: str = "user://chipData.dat"
	fullDeck = []
	currentDeck = []
	playerCards = []
	AICards = []
	communityCards = []
	playerMoves = []
	AIMoves = []
	turn = "player"
	last_aggressor = "none"
	round = 0
	initial = None
	gameIteration = 1
	smallBlind = 50
	bigBlind = 100
	skipAI = False


	
	resource_loader = None
	MissionHandler = None
	ChipHandler = None
	check1: AudioStream = None
	check2: AudioStream = None 
	check3: AudioStream = None
	check4: AudioStream = None
	cheer: AudioStream = None
	
	checkFX = []
	
	def _ready(self) -> None:
		
		#Get Node
		self.parentNode = self.get_parent()
		self.chipLabel = self.get_node("chipLabel")
		self.handCard1 = self.parentNode.get_node("PokerGameProcessing/Hand Cards/handCard1")
		self.handCard2 = self.parentNode.get_node("PokerGameProcessing/Hand Cards/handCard2")
		self.tableCard1 = self.parentNode.get_node("PokerGameProcessing/Table Cards/Card1")
		self.tableCard2 = self.parentNode.get_node("PokerGameProcessing/Table Cards/Card2")
		self.tableCard3 = self.parentNode.get_node("PokerGameProcessing/Table Cards/Card3")
		self.tableCard4 = self.parentNode.get_node("PokerGameProcessing/Table Cards/Card4")
		self.tableCard5 = self.parentNode.get_node("PokerGameProcessing/Table Cards/Card5")
		self.playerPotLabel = self.get_node("playerPot")
		self.AIPotLabel = self.get_node("AIPot")
		self.foldButton = self.get_node("ChoiceUI/FoldButton")
		self.checkButton = self.get_node("ChoiceUI/CheckButton")
		self.betButton = self.get_node("ChoiceUI/BetButton")
		self.callButton = self.get_node("ChoiceUI/CallButton")
		self.AIMovesLabel = self.get_node("AIMovesLabel")
		self.betAmountLabel = self.parentNode.get_node("GUI/betSlider/Label")
		self.newGameButton = self.get_node("newGameButton")
		self.newGameButtonTexture = self.get_node("NewGameTexture")
		self.pokerSFXPlayer = self.get_node("PokerSFX")
		self.popupLabel = self.get_node("Popup")
		self.tableAnimationPlayer = self.parentNode.get_node("PokerGameProcessing/AnimationPlayer")
		self.AIMoveLabel = self.get_node("AIMove")
		self.AITimer = self.parentNode.get_node("PokerGameProcessing/AIPause")
		self.cheatOptionButton = self.get_node("cheatOptions")
		self.cheatButton = self.get_node("cheatButton")
		self.cheatOptionButton.get_popup().add_theme_font_size_override("font_size", 60)
		
		self.resource_loader = get_singleton("ResourceLoader")
		self.MissionHandler = get_singleton("MissionHandler")
		self.ChipHandler = get_singleton("ChipHandler")
		self.check1 = self.resource_loader.load("res://assets/audio/sfx/check1.mp3")
		self.check2 = self.resource_loader.load("res://assets/audio/sfx/check2.mp3")
		self.check3 = self.resource_loader.load("res://assets/audio/sfx/check3.mp3")
		self.check4 = self.resource_loader.load("res://assets/audio/sfx/check4.mp3")
		self.cheer = self.resource_loader.load("res://assets/audio/sfx/crowd-cheering-314922.mp3")
		self.checkFX = [self.check1, self.check2, self.check3, self.check4]
		
		self.newGameButton.hide()
		self.newGameButtonTexture.hide()
		#Load Save Data
		self.chips = self.ChipHandler.call("get_chips")
		self.ChipHandler.call("save_file",self.chips,True)
		
		#Setup AI
		load_dotenv()
		KEY = os.environ.get("GEMINI_API_KEY")
		
		genai.configure(api_key=KEY)
		self.model = genai.GenerativeModel('gemini-flash-lite-latest')
		self.chat = self.model.start_chat(history=[])
		system_prompt = f"You are in a game of poker against a single AI that needs your responses to be perfectly parsed, you currently have "+str(self.AIChips)+" chips. The game will start with either you or the other AI, when the game starts the first AI to have a go will have the small blind which is "+str(self.smallBlind)+" and the other AI will have a big blind of "+str(self.bigBlind)+". You will have 4 options for each round: 'fold','check','call','bet'. When answering you MUST END your answer with one of these key words then a comma and the amount. EG: bet,100 . Add no other punctuation of special characters. The amount for value should ALWAYS be 0 EXCEPT when using the bet keyword. "
		initial_history = [
		{
			"role": "user",
			"parts": [system_prompt]
		},
		{
			"role": "model",
			"parts": ["Understood. I am ready to play poker."]
		}
		]
		self.chat = self.model.start_chat(history=initial_history)
		
		
		#Other Initilisation
		self.hideChoiceGUI()
		
		
	def _process(self, delta:float) -> None:
		self.chipLabel.text = str(self.chips)
		self.AIMovesLabel.text = "AI PLAYED: "+str(self.AIMoves)
		self.playerPotLabel.text = str(self.playerPot)
		self.AIPotLabel.text = str(self.AIPot)
		minValue = self.AIPot - self.playerPot
		self.parentNode.call("change_min_value_parent", minValue)
		if len(self.AIMoves) != 0:
			self.AIMoveLabel.text = self.AIMoves[-1]
		else:
			self.AIMoveLabel.text = ""
	def start_new_game(self):
		self.MissionHandler.call("addValue","handsPlayed",1)
		self.currentDeck = []
		self.fullDeck = []
		self.generate_deck()
		self.reset_card_positions()
		self.newGameButton.hide()
		self.newGameButtonTexture.hide()
		self.gameIteration += 1
		self.hide_cards()
		self.round = 0
		self.playerMoves = []
		self.AIMoves = []
		self.playerPot = 0
		self.AIPot = 0
		self.popupLabel.text = ""
		self.AICards = self.pop_random_card(2)
		self.playerCards = self.pop_random_card(2)
		self.display_initial_cards()
		
		if self.gameIteration % 2 == 0:
			self.turn = "player"
			self.setBlinds("player")
			self.last_aggressor = "ai"
			moveString = f"bet,{str(self.bigBlind)}"
			self.AIMoves.append(moveString)
			self.player_turn(True)
		else:
			self.turn = "ai"
			self.setBlinds("AI")
			self.last_aggressor = "player"
			moveString = f"bet,{str(self.bigBlind)}"
			self.playerMoves.append(moveString)
			self.initial = True
			self.AITimer.start()
		
	
	def advance_game_loop(self):
		print(f"CURRENT DECK: {self.currentDeck}")
		print(self.chat)
		self.parentNode.call("updateSlider")
		self.hideChoiceGUI()
		print(f"Current state of game: turn = {self.turn}, round = {self.round}, last_aggressor = {self.last_aggressor}")
		if self.turn == "player":
			nextTurn = "ai"
		else:
			nextTurn = "player"
		
		roundOver = False
		#Condition when someone bet and the other called
		if nextTurn == self.last_aggressor:
			roundOver = True
		
		#Condition when someone checked and the other checked too
		if len(self.playerMoves) > 0 and len(self.AIMoves) > 0:
			if self.playerMoves[-1] == "check,0" and self.AIMoves[-1] == "check,0" and len(self.playerMoves) == len(self.AIMoves):
				roundOver = True
		#Condition when round starts and first player checks
		blindChecked = (self.round == 0 and self.turn == self.last_aggressor and self.playerMoves[-1] == "check,0")
		if blindChecked:
			roundOver = True
		
		if roundOver:
			self.round += 1
			if self.gameIteration %2 == 0:
				self.last_aggressor = "player"
				self.turn = "player"
			else:
				self.last_aggressor = "ai"
				self.turn = "ai"
				
			if self.round == 1:
				self.tableAnimationPlayer.current_animation = "firstDeal"
				self.tableAnimationPlayer.play()
				self.communityCards = self.pop_random_card(3)
				self.parentNode.call("updateRegion",self.tableCard1, self.communityCards[0])
				self.parentNode.call("updateRegion",self.tableCard2, self.communityCards[1])
				self.parentNode.call("updateRegion",self.tableCard3, self.communityCards[2])
				self.tableCard1.show()
				self.tableCard2.show()
				self.tableCard3.show()
			elif self.round == 2:
				self.tableAnimationPlayer.current_animation = "secondDeal"
				self.tableAnimationPlayer.play()
				self.communityCards.append(self.pop_random_card(1)[0])
				self.parentNode.call("updateRegion", self.tableCard4, self.communityCards[3])
				self.tableCard4.show()
			elif self.round == 3:
				self.tableAnimationPlayer.current_animation = "thirdDeal"
				self.tableAnimationPlayer.play()
				self.communityCards.append(self.pop_random_card(1)[0])
				self.parentNode.call("updateRegion", self.tableCard5, self.communityCards[4])
				self.tableCard5.show()
			elif self.round == 4:
				self.showdown()
				return
				
			if self.gameIteration %2 == 0:
				self.player_turn(True)
			else:
				self.initial = True
				self.AITimer.start()
			return
		
		self.turn = nextTurn
		if self.turn == "player":
			self.player_turn(False)
		else:
			self.initial = False
			self.AITimer.start()
			
		
	def _on_prompt_input_label_text_submitted(self, new_text):
		response = self.chat.send_message(new_text)
		self.label.text = response.text
		self.input.text = ""
	
	
	def generate_deck(self):
		suits = "hcds"
		cardValues = ["2","3","4","5","6","7","8","9","T","J","Q","K","A"]
		for i in range(52):
			self.fullDeck.append(cardValues[i%13]+suits[i//13])
		print(f"FULL DECK: {self.fullDeck}")
		self.currentDeck = self.fullDeck
		
	def display_initial_cards(self):
		
		self.parentNode.call("updateRegion",self.handCard1, self.playerCards[0])
		self.parentNode.call("updateRegion",self.handCard2, self.playerCards[1])
		
	def player_turn(self,initial):
		#give small blind if initial = True and turn = 0, give big blind if initial = False and turn = 0
		#show the player the GUI for their actions in their turn
		#handling what is done after move is done by signal methods (if folded then continueing is set to False)
		
		self.showChoiceGUI(initial)
		
	def AI_turn(self):
		
		#if self.skipAI == True:
		#	self.showdown()
		#	return
		#give small blind if initial = True and turn = 0, give big blind if initial = False and turn = 0
		#if initial = True and turn = 0 then no previous data, give only current cards, blind and number of chips to AI
		#if initial = False and turn = 0 then give players move, current cards, blind and number of chips to AI
		#if turn >0 then send player history to AI along with all other available info
		#send the prompt and parse the response
		#depending on the result of the parsing, do the appropriate move, save in AI history (if folded then continueing is set to False)
		print("Round when creating prompt: "+str(self.round))
		if self.round == 0:
			if self.initial == True:
				prompt = "You have the small blind, therefore the pots are as shown: Your pot: "+str(self.smallBlind)+", Opponents pot: "+str(self.bigBlind)+". You have been dealt "+str(self.AICards)+". What will your action be? You CANNOT check in this situation, only bet, fold or call please. REMEMBER TO REFER TO SYSTEM PROMPT FOR INSTRUCTION ON HOW TO ANSWER" 
			else:
				prompt = "You have the big blind, therefore the pots are as shown: Your pot: "+str(self.bigBlind)+", Opponents pot: "+str(self.smallBlind)+". You have been dealt "+str(self.AICards)+". The opponent has "+str(self.playerMoves)+". What will your action be? REMEMBER TO REFER TO SYSTEM PROMPT FOR INSTRUCTION ON HOW TO ANSWER" 
		else:
			if self.initial == True:
				prompt = "The community cards have now been dealt, they are as follows: "+str(self.communityCards)+". It is your turn to go first, the pots are as shown: Your pot: "+str(self.AIPot)+", Opponents pot: "+str(self.playerPot)+". What will your action be? REMEMBER TO REFER TO SYSTEM PROMPT FOR INSTRUCTION ON HOW TO ANSWER"
			else:
				prompt = "The community cards have now been dealt, they are as follows: "+str(self.communityCards)+". The other AI has gone first and played: "+str(self.playerMoves[-1])+". The pots are as shown: Your pot: "+str(self.AIPot)+", Opponents pot: "+str(self.playerPot)+". What will your action be? REMEMBER TO REFER TO SYSTEM PROMPT FOR INSTRUCTION ON HOW TO ANSWER"
		response = self.chat.send_message(prompt)
		strippedResponse = response.text.strip()
		print(strippedResponse)
		action,amount = strippedResponse.split(",")
		
		self.AIMoves.append(strippedResponse)
		if action == "fold":
			totalPot = self.AIPot + self.playerPot
			self.chips += totalPot
			self.ChipHandler.call("save_file",self.chips,True)
			self.popupLabel.text = "You Won!"
			self.MissionHandler.call("addValue","handsWon",1)
			self.MissionHandler.call("addValue","consequetiveWon",1)
			self.start_new_game()
			
		elif action == "check":
			self.pokerSFXPlayer.stream = random.choice(self.checkFX)
			self.pokerSFXPlayer.play()
			self.advance_game_loop()
		elif action == "call":
			bet, callAmount = self.playerMoves[self.round].split(",")
			if self.round == 0:
				callAmount = float(callAmount) - self.smallBlind
			print("AI is calling, therefore adding: "+str(callAmount))
			self.AIPot += float(callAmount)
			self.advance_game_loop()
		elif action == "bet" or action == "bid":
			self.AIPot += float(amount)
			self.last_aggressor = "ai"
			self.advance_game_loop()
		else:
			print("UNSUCCESSFUL PARSING")
			print(response)
			print(action)
			
	def pop_random_card(self,numCards):
		cards = []
		
		for i in range(numCards):
			cards.append(random.choice(self.currentDeck))
			self.currentDeck.remove(cards[i])
		print(f"Cards added: {cards}, cards removed: {cards}")
		return cards

	def timerCalled(self):
		self.start_new_game()
	
	def hideChoiceGUI(self):
		self.foldButton.hide()
		self.checkButton.hide()
		self.betButton.hide()
		self.callButton.hide()
	
	def showChoiceGUI(self,initial):
		
		if initial == True and self.round != 0:
			self.checkButton.show()
			self.foldButton.show()
			self.betButton.show()
			return
		if len(self.AIMoves) != 0:
			print(self.AIMoves[-1])
			if self.AIMoves[-1] == "check,0" and initial==False:
				self.checkButton.show()
				self.foldButton.show()
				self.betButton.show()
				return
		if self.round == 0 and initial == True:
			self.callButton.show()
			self.foldButton.show()
			self.betButton.show()
			return
		if initial == False:
			self.callButton.show()
			self.foldButton.show()
			self.betButton.show()
			return
			
		
		
	
	def _on_fold_button_pressed(self):
		self.playerMoves.append("fold,0")
		self.hideChoiceGUI()
		totalPot = self.AIPot + self.playerPot
		self.AIChips += totalPot
		self.MissionHandler.call("setValue","consequetiveWon",0)
		self.start_new_game()
		
		
	def _on_check_button_pressed(self):
		self.playerMoves.append("check,0")
		self.hideChoiceGUI()
		self.advance_game_loop()
		self.pokerSFXPlayer.stream = random.choice(self.checkFX)
		self.pokerSFXPlayer.play()

	def _on_bet_button_pressed(self):
		
		amount = float(self.betAmountLabel.text)
		print("PLAYER BET AMOUNT: "+str(amount))
		playerRecordString = f"bet,{str(amount)}"
		self.playerMoves.append(playerRecordString)
		self.playerPot += amount
		self.chips -= amount
		self.ChipHandler.call("save_file",self.chips, True)
		self.last_aggressor = "player"
		self.hideChoiceGUI()
		self.advance_game_loop()

	def _on_call_button_pressed(self):
		print("Round when call pressed: "+ str(self.round))
		self.hideChoiceGUI
		self.playerMoves.append("call,0")
		if self.round != 0:
			bet = self.AIMoves[self.round]
			bet, amount = bet.split(",")
		else:
			amount = self.bigBlind-self.smallBlind
		self.playerPot += float(amount)
		self.chips -= float(amount)
		self.ChipHandler.call("save_file",self.chips, True)
		self.advance_game_loop()
	
	def setBlinds(self,startingPlayer):
		if startingPlayer == "player":
			self.playerPot += self.smallBlind
			self.AIPot += self.bigBlind
			self.chips -= self.smallBlind
			self.ChipHandler.call("save_file",self.chips, True)
			self.AIChips -= self.bigBlind
		else:
			self.playerPot += self.bigBlind
			self.AIPot += self.smallBlind
			self.chips -= self.bigBlind
			self.ChipHandler.call("save_file",self.chips, True)
			self.AIChips -= self.smallBlind
			
	def hide_cards(self):
		self.tableCard1.hide()
		self.tableCard2.hide()
		self.tableCard3.hide()
		self.tableCard4.hide()
		self.tableCard5.hide()
	
	def showdown(self):
		totalPot = self.AIPot + self.playerPot
		evaluator = Evaluator()
		
		
		board = [
			Card.new(self.communityCards[0]),
			Card.new(self.communityCards[1]),
			Card.new(self.communityCards[2]),
			Card.new(self.communityCards[3]),
			Card.new(self.communityCards[4])
		]
		playerHand = [
		   Card.new(self.playerCards[0]),
		   Card.new(self.playerCards[1])
		]
		AIHand = [
			Card.new(self.AICards[0]),
			Card.new(self.AICards[1])
		]

		AIScore, AICombo = evaluator.evaluate(AIHand,board)
		playerScore, playerCombo = evaluator.evaluate(playerHand,board)
		AIClass = evaluator.get_rank_class(AIScore)
		playerClass = evaluator.get_rank_class(playerScore)
		AIClass = evaluator.class_to_string(AIClass)
		playerClass = evaluator.class_to_string(playerClass)
		
		print(f"AI HAND: {str(self.AICards)}")
		print(f"PLAYER HAND: {str(self.playerCards)}")
		print(f"COMMUNITY CARDS: {str(self.communityCards)}")

		playerCombo = [Card.int_to_str(c) for c in playerCombo]
		AICombo = [Card.int_to_str(c) for c in AICombo]
		print(f"Best combos: AI: {str(AICombo)}, Player: {str(playerCombo)}")
		
		if playerScore < AIScore:
			self.pokerSFXPlayer.stream = self.cheer
			self.pokerSFXPlayer.play()
			self.chips += totalPot
			self.ChipHandler.call("save_file",self.chips, True)
			self.playerPot += self.AIPot
			self.AIPot = 0
			self.popupLabel.text = "You Won!"
			print(f"THE PLAYER WON WITH {str(playerScore)} POINTS WHICH IS A {str(playerClass)}")
			print(f"THE AI HAD {str(AIScore)} WHICH IS A {str(AIClass)}")
			self.MissionHandler.call("addValue","handsWon",1)
			self.MissionHandler.call("addValue","consequetiveWon",1)
			self.MissionHandler.call("wonWith",str(playerClass))
			
		elif AIScore < playerScore:
			self.AIChips += totalPot
			self.AIPot += self.playerPot
			self.playerPot = 0
			self.popupLabel.text = "You Lost!"
			print(f"THE AI WON WITH {str(AIScore)} POINTS WHICH IS A {str(AIClass)}")
			print(f"THE PLAYER HAD {str(playerScore)} WHICH IS A {str(playerClass)}")
			self.MissionHandler.call("setValue","consequetiveWon",0)
			self.MissionHandler.call("hadCards",str(playerClass))
		else:
			self.popupLabel.text = "Its a Draw"
			self.AIChips += self.AIPot
			self.chips += self.playerPot
			self.ChipHandler.call("save_file",self.chips, True)
			print("DRAW")
			print(f"THE AI HAD {str(AIScore)} POINTS WHICH IS A {str(AIClass)}")
			print(f"THE PLAYER HAD {str(playerScore)} WHICH IS A {str(playerClass)}")
			self.MissionHandler.call("setValue","consequetiveWon",0)
			self.MissionHandler.call("hadCards", str(playerClass))
			
		cardMap = {
			self.playerCards[0] : self.handCard1,
			self.playerCards[1] : self.handCard2,
			self.communityCards[0] : self.tableCard1,
			self.communityCards[1] : self.tableCard2,
			self.communityCards[2] : self.tableCard3,
			self.communityCards[3] : self.tableCard4,
			self.communityCards[4] : self.tableCard5
		}
		for card in playerCombo:
			cardMap[card].call("start_move_animation")
			
		self.newGameButton.show()
		self.newGameButtonTexture.show()
	
	def _on_new_game_button_pressed(self):
		self.pokerSFXPlayer.playing = False
		self.start_new_game()
	
	def reset_card_positions(self):
		self.handCard1.call("reset_card_positions_GD")
		self.handCard2.call("reset_card_positions_GD")
		self.tableCard1.call("reset_card_positions_GD")
		self.tableCard2.call("reset_card_positions_GD")
		self.tableCard3.call("reset_card_positions_GD")
		self.tableCard4.call("reset_card_positions_GD")
		self.tableCard5.call("reset_card_positions_GD")

	def _on_ai_pause_timeout(self):
		self.AI_turn()


	def _on_cheat_button_pressed(self):
		if self.cheatOptionButton.selected == 0:
			self.chips += 100
		elif self.cheatOptionButton.selected == 1:
			self.chips += 200
		elif self.cheatOptionButton.selected == 2:
			self.chips += 500
		elif self.cheatOptionButton.selected == 3:
			self.chips += 1000
		self.ChipHandler.call("save_file",self.chips, True)


	


	
