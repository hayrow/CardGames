extends Node2D

var suits = ["Spade","Heart","Diamond","Club"]
var ranks = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
var deck = []
var in_play = []
var ace_high:bool = true

var player1 = {"draw" = [], "hand" = [], "discard" = []}
var player2 = {"draw" = [], "hand" = [], "discard" = []}
var player3 = {"draw" = [], "hand" = [], "discard" = []}
var player4 = {"draw" = [], "hand" = [], "discard" = []}
var players = [player1,player2,player3,player4]

var max_players = 4

@onready var test_p1 = $"../CanvasLayer/Player1Control/TestP1"
@onready var test_p2 = $"../CanvasLayer/Player2Control/TestP2"
@onready var test_p1_card = $"../CanvasLayer/PlayArea/Player1Card"
@onready var test_p2_card = $"../CanvasLayer/PlayArea/Player2Card"

func _ready():
	randomize()
	create_deck()
	setup_war()


func create_deck():
	for suit in suits:
		for rank in ranks:
			var card = {
				"suit" = suit,
				"rank" = rank
			}
			deck.append(card)
	shuffle_deck(deck,5)
	
	#fisher-yates shuffle, swap cards
func shuffle_deck(shuffle, count):
	for shuffles in count:
		for i in len(shuffle):
			var j = randi() % len(shuffle)
			var hold = shuffle[i]
			shuffle[i] = shuffle[j]
			shuffle[j] = hold

func card_value(card):
	if card["rank"] == 'A':
		if ace_high:
			return 14
		else:
			return 1
	elif card["rank"]  == 'K':
		return 13
	elif card["rank"]  == 'Q':
		return 12
	elif card["rank"]  == 'J':
		return 11
	else:
		return int(card["rank"])

#WAR RULES 
#2 player game, split decks
	#players will trigger a card drawing
	#cards are compared, winner decided
	#winner gets card added to their discard pile, game proceeds
	#if draw deck becomes empty, shuffle discard, readd to draw pile
func setup_war():
	#split deck
	var deck_size = floor(len(deck))
	
	for p1 in range(0,deck_size/2,1):
		player1["draw"].append(deck.pop_back())
	
	for p2 in range(deck_size/2, deck_size,1):
		player2["draw"].append(deck.pop_back())
	
	

func check_winner():
	if len(player1["draw"]) == 0 and len(player1["discard"]) == 0:
		print("Player 2 wins the war!")
		return true
	elif len(player2["draw"]) == 0 and len(player2["discard"]) == 0:
		print("Player 1 wins the war!")
		return true
	else:
		return false
	

func play_round():
	#check win if both decks empty
	check_winner()
	#check if play deck is empty, reshuffle discard into hand
	if len(player1["draw"]) == 0:
		load_discard(player1)
	if len(player2["draw"]) == 0:
		load_discard(player2)
	
	var drawn_cards = draw_war_cards()
	
#	#do assumptive move if card are equal, give win to player1
#	TODO: Update code to do tiebreaker matches
	if card_value(drawn_cards[0]) >= card_value(drawn_cards[1]):
		print("Player1 wins hand")
		for card in drawn_cards:
			player1["discard"].append(card)
	else:
		print("Player2 wins hand")
		for card in drawn_cards:
			player2["discard"].append(card)
	update_war_UI()
	
	

func draw_war_cards():
	var p1_card = player1["draw"].pop_back()
	var p2_card = player2["draw"].pop_back()
	
#	naive approach for displaying cards, need to do tiebreaker + animations
	test_p1_card.text = "[center]" + p1_card["rank"] + " " + p1_card["suit"]
	test_p2_card.text = "[center]" + p2_card["rank"] + " " + p2_card["suit"]
	return [p1_card,p2_card]
		
func load_discard(player):
	shuffle_deck(player["discard"],3)
	for i in len(player["discard"]):
		player["draw"].append(player["discard"].pop_back())
		
func update_war_UI():
	#need to update playing field, and deck counts
	#naive implementation 
	test_p1.text = "[center][b]PLAYER 1[/b]\nDeck: " + str(len(player1["draw"]))+ "\nDiscard: "+str(len(player1["discard"]))
	test_p2.text = "[center][b]PLAYER 2[/b]\nDeck: " + str(len(player2["draw"]))+ "\nDiscard: "+str(len(player2["discard"]))
	
	
	
